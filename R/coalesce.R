#' @export
coalesce <- function(..., .ptype = NULL, .size = NULL) {
  values <- list2(...)

  # Drop `NULL`s
  # TODO: `vctrs::list_drop_missing()`
  values <- Filter(function(x) !is.null(x), values)

  if (length(values) == 0L) {
    abort("`...` can't be empty.")
  }

  # Recycle early so logical conditions computed below will be the same length
  values <- vec_recycle_common(!!!values, .size = .size)

  # Name early to get correct indexing in `vec_case_when()` error messages
  values <- list_name(values)

  conditions <- lapply(values, vec_not_equal_na)

  vec_case_when(conditions = conditions, values = values, ptype = .ptype)
}

vec_not_equal_na <- function(x) {
  !vec_equal_na(x)
}
