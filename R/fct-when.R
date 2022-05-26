#' @export
fct_when <- function(...,
                     .default = NULL,
                     .size = NULL,
                     .ordered = TRUE) {
  args <- list2(...)
  args <- name_unnamed_args(args)

  n_args <- length(args)

  if (!is_bool(.ordered)) {
    abort("`.ordered` must be a single `TRUE` or `FALSE`.")
  }

  if (n_args == 0L) {
    abort("`...` can't be empty.")
  }
  if ((n_args %% 2) != 0L) {
    message <- c(
      "`...` must contain an even number of inputs.",
      i = glue("{n_args} inputs were provided.")
    )
    abort(message)
  }

  # Check that value args are length 1.
  # They represent the factor levels, in order.
  values <- seq.int(1L, n_args - 1L, by = 2) + 1L
  values <- args[values]

  sizes <- list_sizes(values)
  scalars <- sizes == 1L
  if (!all(scalars)) {
    loc <- which(!scalars)
    loc <- loc[[1L]]
    size <- sizes[[loc]]
    arg <- names(values)[[loc]]

    message <- c(
      "All value inputs must be strings.",
      i = glue("`{arg}` is length {size}.")
    )

    abort(message)
  }

  # Check that `.default` is length 1 if supplied
  if (!is.null(.default) && vec_size(.default) != 1L) {
    message <- c(
      "`.default` must be a string.",
      i = glue("`.default` is length {vec_size(.default)}.")
    )

    abort(message)
  }

  # Let `vec_case_when()` handle the type casting.
  # Called after the length checks so length issues have good error messages.
  out <- vec_case_when(
    !!!args,
    .default = .default,
    .ptype = character(),
    .size = .size
  )

  # Include `.default` at the end
  levels <- c(values, list(.default))
  levels <- unname(levels)
  levels <- vec_unchop(levels, ptype = character())

  if (vec_duplicate_any(levels)) {
    loc <- vec_duplicate_detect(levels)
    loc <- which(loc)[[1L]]
    level <- levels[[loc]]

    message <- c(
      "Factor levels can't be duplicated.",
      i = glue("Level \"{level}\" is duplicated.")
    )

    abort(message)
  }

  factor(
    x = out,
    levels = levels,
    ordered = .ordered,
    exclude = NULL
  )
}
