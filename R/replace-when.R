#' @export
replace_when <- function(x, ...) {
  # Finalize the ptype to handle the case when `x` is unspecified (i.e. all `NA`).
  # This is fine here because we know it came in finalized already (because
  # it was user input).
  ptype <- vec_ptype(x)
  ptype <- vec_ptype_finalise(ptype)

  size <- vec_size(x)

  args <- list2(...)
  args <- set_names(args, list_names(args))
  args <- args_split(args)

  conditions <- args$conditions
  values <- args$values

  vec_case_when(
    conditions = conditions,
    values = values,
    default = x,
    default_arg = "x",
    ptype = ptype,
    size = size
  )
}
