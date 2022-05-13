replace_when <- function(x, ...) {
  # Finalize the ptype to handle the case when `x` is unspecified (i.e. all `NA`).
  # This is fine here because we know it came in finalized already (because
  # it was user input).
  ptype <- vec_ptype(x)
  ptype <- vec_ptype_finalise(ptype)

  size <- vec_size(x)

  replace <- vec_case_when(..., ptype = ptype, size = size)

  # Where was a replacement made?
  loc <- which(!vec_equal_na(replace))

  replace <- vec_slice(replace, loc)

  vec_assign(x, loc, replace)
}
