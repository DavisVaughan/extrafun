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

  if (is.null(missing)) {
    vec_case_when(
      condition, true = true,
      !condition, false = false,
      .ptype = ptype,
      .size = size
    )
  } else {
    vec_case_when(
      condition, true = true,
      !condition, false = false,
      vec_equal_na(condition), missing = missing,
      .ptype = ptype,
      .size = size
    )
  }
}
