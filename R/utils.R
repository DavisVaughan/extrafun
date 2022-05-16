name_unnamed_args <- function(args) {
  names <- names2(args)
  names <- name_unnamed(names)
  names(args) <- names
  args
}

name_unnamed <- function(names) {
  if (is.null(names)) {
    return(names)
  }

  unnamed <- names == ""

  if (any(unnamed)) {
    unnamed <- which(unnamed)
    names[unnamed] <- vec_paste0("..", unnamed)
  }

  names
}

vec_paste0 <- function (...) {
  args <- vec_recycle_common(...)
  exec(paste0, !!!args)
}
