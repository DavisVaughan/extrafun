#' @export
vec_case_when <- function(conditions,
                          values,
                          ...,
                          conditions_arg = "",
                          values_arg = "",
                          default = NULL,
                          default_arg = "default",
                          ptype = NULL,
                          size = NULL,
                          call = caller_env()) {
  check_dots_empty0(..., call = call)

  vec_check_list(conditions, arg = "conditions", call = call)
  vec_check_list(values, arg = "values", call = call)

  list_check_all_vectors(values, arg = values_arg, call = call)

  n_conditions <- length(conditions)
  n_values <- length(values)

  if (n_conditions != n_values) {
    message <- glue(
      "The number of supplied conditions ({n_conditions}) must equal ",
      "the number of supplied values ({n_values})."
    )
    abort(message, call = call)
  }
  if (n_conditions == 0L) {
    abort("At least one condition must be supplied.", call = call)
  }

  if (!is_string(conditions_arg)) {
    abort("`conditions_arg` must be a string.", call = call)
  }
  if (!is_string(values_arg)) {
    abort("`values_arg` must be a string.", call = call)
  }
  if (!is_string(default_arg)) {
    abort("`default_arg` must be a string.", call = call)
  }

  condition_args <- list_names(conditions, arg = conditions_arg)
  value_args <- list_names(values, arg = values_arg)

  names(conditions) <- condition_args
  names(values) <- value_args

  for (i in seq_len(n_conditions)) {
    condition <- conditions[[i]]
    condition_arg <- condition_args[[i]]

    vec_assert(
      x = condition,
      ptype = logical(),
      arg = condition_arg,
      call = call
    )
  }

  size <- vec_size_common(
    !!!conditions,
    .size = size,
    .call = call
  )

  # Allow `default` to participate in common type determination.
  # In terms of size/ptype behavior it is exactly like any other `values` element.
  # Have to collect inputs and splice them in all at once due to
  # https://github.com/r-lib/vctrs/issues/1570
  extras <- list(default)
  names(extras) <- default_arg
  everything <- c(values, extras)

  ptype <- vec_ptype_common(
    !!!everything,
    .ptype = ptype,
    .call = call
  )

  # Cast early to generate correct error message indices
  values <- vec_cast_common(
    !!!values,
    .to = ptype,
    .call = call
  )

  if (is.null(default)) {
    default <- vec_init(ptype)
  } else {
    default <- vec_cast(
      x = default,
      to = ptype,
      x_arg = default_arg,
      call = call
    )
  }

  # Check for correct sizes
  for (i in seq_len(n_conditions)) {
    condition <- conditions[[i]]
    condition_arg <- condition_args[[i]]

    vec_assert(condition, size = size, arg = condition_arg, call = call)
  }

  value_sizes <- list_sizes(values)

  for (i in seq_len(n_values)) {
    value_size <- value_sizes[[i]]

    if (value_size != 1L) {
      value <- values[[i]]
      value_arg <- value_args[[i]]

      vec_assert(value, size = size, arg = value_arg, call = call)
    }
  }

  default_size <- vec_size(default)
  if (default_size != 1L) {
    vec_assert(default, size = size, arg = default_arg, call = call)
  }

  n_used <- 0L
  locs <- vector("list", n_values)

  # Starts as unused. Any `TRUE` value in `condition` flips it to used.
  are_unused <- vec_rep(TRUE, times = size)

  for (i in seq_len(n_conditions)) {
    if (!any(are_unused)) {
      # Early exit if all values are matched, for performance
      break
    }

    condition <- conditions[[i]]

    # Treat `NA` in `condition` as `FALSE`.
    # `TRUE & NA == NA`, `FALSE & NA == FALSE`.
    # `which()` drops `NA`s
    loc <- are_unused & condition
    loc <- which(loc)

    locs[[i]] <- loc

    are_unused[loc] <- FALSE
    n_used <- n_used + 1L
  }

  if (n_used == n_conditions && any(are_unused)) {
    # If all of the `conditions` are used, then we check if we need `default`
    are_unused <- which(are_unused)

    n_used <- n_used + 1L
    n_values <- n_values + 1L

    locs[[n_values]] <- are_unused
    values[[n_values]] <- default
    value_sizes[[n_values]] <- default_size
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
    ptype = ptype
  )
}
