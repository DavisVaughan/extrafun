#' @export
replace_when <- function(x, ...) {
  # Finalize the ptype to handle the case when `x` is unspecified (i.e. all `NA`).
  # This is fine here because we know it came in finalized already (because
  # it was user input).
  ptype <- vec_ptype(x)
  ptype <- vec_ptype_finalise(ptype)

  size <- vec_size(x)

  vec_case_when(
    ...,
    .default = x,
    .default_arg = "x",
    .ptype = ptype,
    .size = size
  )
}
