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

    where <- vec_cast(
      x = where,
      to = logical(),
      x_arg = where_arg,
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

  sizes <- list_sizes(wheres)
  invalid <- sizes != .size
  if (any(invalid)) {
    invalid <- which(invalid)
    invalid <- invalid[[1L]]
    invalid_arg <- where_args[[invalid]]
    invalid_size <- sizes[[invalid]]

    message <- c(
      glue("All odd numbered `...` inputs must be size {.size}."),
      i = glue("`{invalid_arg}` is size {invalid_size}.")
    )

    abort(message, call = .call)
  }

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

  locs <- vector("list", n_values)
  unused <- vec_rep(TRUE, times = .size)

  for (i in seq_len(n_wheres)) {
    where <- wheres[[i]]

    loc <- unused & where
    loc <- vec_as_location(loc, n = .size)
    locs[[i]] <- loc

    unused[where] <- FALSE
  }

  # Unused locations are where the `.default` goes
  locs[[n_values]] <- vec_as_location(unused, n = .size)

  for (i in seq_len(n_values)) {
    loc <- locs[[i]]
    value <- values[[i]]
    arg <- value_args[[i]]

    if (vec_size(value) == 1L) {
      # Recycle "up"
      value <- vec_recycle(value, size = vec_size(loc))
    } else {
      # Slice "down", but enforce that `value` started at the same size as the
      # logical conditions
      vec_assert(
        x = value,
        size = .size,
        arg = arg,
        call = .call
      )

      value <- vec_slice(value, loc)
    }

    values[[i]] <- value
  }

  # Remove names used for error messages. We don't want them in the result.
  values <- unname(values)

  vec_unchop(
    x = values,
    indices = locs,
    ptype = .ptype
  )
}
