#' @export
if_else <- function(condition,
                    true,
                    false,
                    ...,
                    missing = NULL,
                    ptype = NULL,
                    size = NULL) {
  check_dots_empty0(...)

  # Assert early since we `!` the `condition`
  vec_assert(
    x = condition,
    ptype = logical(),
    arg = "condition"
  )

  conditions <- list(
    condition,
    !condition
  )
  values <- list(
    true = true,
    false = false
  )

  vec_case_when(
    conditions = conditions,
    values = values,
    default = missing,
    default_arg = "missing",
    ptype = ptype,
    size = size
  )
}
