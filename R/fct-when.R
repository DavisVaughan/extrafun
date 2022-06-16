#' @export
fct_when <- function(...,
                     .default = NULL,
                     .missing = NULL,
                     .size = NULL,
                     .ordered = TRUE) {
  args <- list2(...)
  args <- list_name(args)
  args <- args_split(args)

  conditions <- args$conditions
  values <- args$values

  if (!is_bool(.ordered)) {
    abort("`.ordered` must be a single `TRUE` or `FALSE`.")
  }

  # Check that value args are length 1.
  # They represent the factor levels, in order.
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

  # Check that `.missing` is length 1 if supplied
  if (!is.null(.missing) && vec_size(.missing) != 1L) {
    message <- c(
      "`.missing` must be a string.",
      i = glue("`.missing` is length {vec_size(.missing)}.")
    )
    abort(message)
  }

  # Let `vec_case_when()` handle the type casting.
  # Called after the length checks so length issues have good error messages.
  out <- vec_case_when(
    conditions = conditions,
    values = values,
    default = .default,
    default_arg = ".default",
    missing = .missing,
    missing_arg = ".missing",
    ptype = character(),
    size = .size
  )

  # Include `.default` and `.missing` at the end, in that order
  levels <- unname(values)
  levels <- c(levels, list(.default, .missing))
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
