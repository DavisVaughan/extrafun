#' @export
coalesce <- function(..., .ptype = NULL, .size = NULL) {
  args <- list2(...)

  # Drop `NULL`s
  # TODO: `vctrs::list_drop_missing()`
  args <- Filter(function(x) !is.null(x), args)

  # Recycle early so logical conditions computed below will be the same length
  args <- vec_recycle_common(!!!args, .size = .size)

  # Name early to get correct indexing in `vec_case_when()` error messages
  args <- name_unnamed_args(args)

  not_missing <- lapply(args, vec_not_equal_na)

  args <- vec_interleave(not_missing, args)

  vec_case_when(!!!args, .ptype = .ptype)
}

vec_not_equal_na <- function(x) {
  !vec_equal_na(x)
}
