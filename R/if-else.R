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

  vec_case_when(
    condition, true = true,
    !condition, false = false,
    .default = missing,
    .default_arg = "missing",
    .ptype = ptype,
    .size = size
  )
}
