vec_case_when <- function(...,
                          .default = NULL,
                          .default_arg = ".default",
                          .ptype = NULL,
                          .size = NULL,
                          .call = caller_env()) {
  args <- list2(...)
  args <- name_unnamed_args(args)

  n_args <- length(args)

  if (n_args == 0L) {
    abort("`...` can't be empty.", call = .call)
  }
  if ((n_args %% 2) != 0L) {
    message <- c(
      "`...` must contain an even number of inputs.",
      i = glue("{n_args} inputs were provided.")
    )
    abort(message, call = .call)
  }

  if (!is_string(.default_arg)) {
    abort("`.default_arg` must be a string.", call = .call)
  }

  n_wheres <- n_args / 2L
  loc_wheres <- seq.int(1L, n_args - 1L, by = 2)
  wheres <- args[loc_wheres]
  where_args <- names2(wheres)

  for (i in seq_len(n_wheres)) {
    where <- wheres[[i]]
    where_arg <- where_args[[i]]

    vec_assert(
      x = where,
      ptype = logical(),
      arg = where_arg,
      call = .call
    )

    if (anyNA(where)) {
      # `NA` in `where` is skipped
      where <- vec_assign(where, vec_equal_na(where), FALSE)
    }

    wheres[[i]] <- where
  }

  .size <- vec_size_common(
    !!!wheres,
    .size = .size,
    .call = .call
  )

  n_values <- n_wheres + 1L
  loc_values <- loc_wheres + 1L
  values <- args[loc_values]
  # Allow `.default` to participate in common type determination.
  # In terms of size/ptype behavior it is exactly like any other `values` element.
  values <- c(values, list2("{.default_arg}" := .default))
  value_args <- names2(values)

  .ptype <- vec_ptype_common(
    !!!values,
    .ptype = .ptype,
    .call = .call
  )

  # Cast early to generate correct error message indices
  values <- vec_cast_common(
    !!!values,
    .to = .ptype,
    .call = .call
  )

  if (is.null(.default)) {
    # If the `.default` was `NULL` all along, update it with the now known
    # common type based on the actual inputs
    values[[n_values]] <- vec_init(.ptype)
  }

  # Check for correct sizes
  for (i in seq_len(n_wheres)) {
    where <- wheres[[i]]
    where_arg <- where_args[[i]]

    vec_assert(where, size = .size, arg = where_arg, call = .call)
  }

  value_sizes <- list_sizes(values)

  for (i in seq_len(n_values)) {
    value <- values[[i]]
    value_arg <- value_args[[i]]
    value_size <- value_sizes[[i]]

    if (value_size != 1L) {
      vec_assert(value, size = .size, arg = value_arg, call = .call)
    }
  }

  locs <- vector("list", n_values)
  unused <- vec_rep(TRUE, times = .size)
  n_used <- 0L

  for (i in seq_len(n_wheres)) {
    if (!any(unused)) {
      break
    }

    where <- wheres[[i]]

    loc <- unused & where
    loc <- vec_as_location(loc, n = .size)
    locs[[i]] <- loc

    unused[where] <- FALSE
    n_used <- n_used + 1L
  }

  if (n_used == n_wheres && any(unused)) {
    # If we still have unused locations left, those are for the `.default`
    locs[[n_values]] <- vec_as_location(unused, n = .size)
    n_used <- n_used + 1L
  }

  for (i in seq_len(n_used)) {
    loc <- locs[[i]]
    value <- values[[i]]
    value_size <- value_sizes[[i]]

    if (value_size == 1L) {
      # Recycle "up"
      value <- vec_recycle(value, size = vec_size(loc))
    } else {
      # Slice "down"
      value <- vec_slice(value, loc)
    }

    values[[i]] <- value
  }

  # Remove names used for error messages. We don't want them in the result.
  values <- unname(values)

  if (n_used != n_values) {
    # Trim to only what will be used to fill the result
    seq_used <- seq_len(n_used)
    values <- values[seq_used]
    locs <- locs[seq_used]
  }

  vec_unchop(
    x = values,
    indices = locs,
    ptype = .ptype
  )
}
