if_else <- function(condition,
                    true,
                    false,
                    ...,
                    missing = NULL,
                    ptype = NULL,
                    size = NULL) {
  check_dots_empty0(...)

  condition <- vec_cast(
    x = condition,
    to = logical(),
    x_arg = "condition"
  )

  args <- list(
    condition, true = true,
    !condition, false = false
  )

  if (!is.null(missing)) {
    missing <- list(vec_equal_na(condition), missing = missing)
    args <- c(args, missing)
  }

  vec_case_when(!!!args, .ptype = ptype, .size = size)
}
