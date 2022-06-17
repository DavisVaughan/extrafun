# I don't feel very strongly about these because they are just
# _when() variants with some special sauce around them. Don't want
# an explosion of variants.
# case_match() is case_when(.x %in% ..., ) repeated
# replace_match() is replace_when(.x, .x %in% ..., ) repeated

case_match <- function(.x,
                       ...,
                       .default = NULL,
                       .ptype = NULL,
                       .size = NULL) {
  args <- collect_match_dots(..., .x = .x)

  case_when(
    !!!args,
    .default = .default,
    .ptype = .ptype,
    .size = .size
  )
}

replace_match <- function(.x, ...) {
  args <- collect_match_dots(..., .x = .x)
  replace_when(.x, !!!args)
}

collect_match_dots <- function(..., .x, .call = caller_env()) {
  args <- list2(...)
  args <- set_names(args, list_names(args))

  n_args <- length(args)

  if ((n_args %% 2) != 0L) {
    message <- c(
      "`...` must contain an even number of inputs.",
      i = glue("{n_args} inputs were provided.")
    )
    abort(message, call = .call)
  }

  loc_wheres <- seq.int(1L, n_args - 1L, by = 2)

  wheres <- args[loc_wheres]
  wheres <- lapply(wheres, vec_cast, to = .x, call = .call)
  wheres <- lapply(wheres, vec_in, needles = .x)
  args[loc_wheres] <- wheres

  args
}
