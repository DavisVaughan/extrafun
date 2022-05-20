vec_case_when <- function(...,
                          .default = NULL,
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

  n_inputs <- n_args / 2L

  loc_wheres <- seq.int(1L, n_args - 1L, by = 2)
  loc_values <- loc_wheres + 1L

  wheres <- args[loc_wheres]
  values <- args[loc_values]

  where_args <- names2(wheres)
  value_args <- names2(values)

  for (i in seq_len(n_inputs)) {
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

  # `+ 1L` to make room for `.default`
  n_pieces <- n_inputs + 1L

  locs <- vector("list", n_pieces)
  unused <- vec_rep(TRUE, times = .size)

  for (i in seq_len(n_inputs)) {
    where <- wheres[[i]]

    loc <- unused & where
    loc <- vec_as_location(loc, n = .size)
    locs[[i]] <- loc

    unused[where] <- FALSE
  }

  for (i in seq_len(n_inputs)) {
    loc <- locs[[i]]
    value <- values[[i]]
    arg <- value_args[[i]]

    value <- value_reslice(
      value = value,
      size = .size,
      loc = loc,
      arg = arg,
      call = .call
    )

    values[[i]] <- value
  }

  # Unused locations are where the `.default` goes
  loc_default <- vec_as_location(unused, n = .size)
  locs[[n_pieces]] <- loc_default

  if (is.null(.default)) {
    .default <- vec_init(.ptype, n = vec_size(loc_default))
  } else {
    .default <- vec_cast(
      x = .default,
      to = .ptype,
      x_arg = ".default",
      call = .call
    )

    .default <- value_reslice(
      value = .default,
      size = .size,
      loc = loc_default,
      arg = ".default",
      call = .call
    )
  }

  # Append `.default` to the end
  values <- c(values, list(.default))

  # Remove names used for error messages. We don't want them in the result.
  values <- unname(values)

  vec_unchop(
    x = values,
    indices = locs,
    ptype = .ptype
  )
}

value_reslice <- function(value,
                          size,
                          loc,
                          arg,
                          ...,
                          call = caller_env()) {
  check_dots_empty0(...)

  if (vec_size(value) == 1L) {
    # Recycle "up"
    vec_recycle(value, size = vec_size(loc))
  } else {
    # Slice "down", but enforce that `value` started at the same size as the
    # logical conditions
    vec_assert(
      x = value,
      size = size,
      arg = arg,
      call = call
    )

    vec_slice(value, loc)
  }
}
