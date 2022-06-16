#' @export
case_when <- function(...,
                      .default = NULL,
                      .ptype = NULL,
                      .size = NULL) {
  args <- list2(...)
  args <- list_name(args)
  args <- args_split(args)

  conditions <- args$conditions
  values <- args$values

  vec_case_when(
    conditions = conditions,
    values = values,
    default = .default,
    default_arg = ".default",
    ptype = .ptype,
    size = .size
  )
}
