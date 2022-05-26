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

  vec_case_when(
    condition, true = true,
    !condition, false = false,
    .default = missing,
    .default_arg = "missing",
    .ptype = ptype,
    .size = size
  )
}
