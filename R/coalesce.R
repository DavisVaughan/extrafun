coalesce <- function(..., ptype = NULL, size = NULL) {
  args <- list2(...)
  args <- vec_recycle_common(!!!args)

  # For correct indexing in `vec_case_when()` error messages
  names <- names2(args)
  unnamed <- names == ""
  names[unnamed] <- glue("..{seq_along(names)}")[unnamed]
  names(args) <- names

  not_missing <- lapply(args, vec_not_equal_na)

  args <- vec_interleave(not_missing, args)

  vec_case_when(!!!args, ptype = ptype, size = size)
}

vec_not_equal_na <- function(x) {
  !vec_equal_na(x)
}
