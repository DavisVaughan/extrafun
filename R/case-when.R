#' @export
case_when <- function(...,
                      .default = NULL,
                      .missing = NULL,
                      .ptype = NULL,
                      .size = NULL) {
  vec_case_when(
    ...,
    .default = .default,
    .missing = .missing,
    .ptype = .ptype,
    .size = .size
  )
}
