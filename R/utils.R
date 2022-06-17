args_split <- function(args, error_call = caller_env()) {
  n_args <- length(args)

  if (n_args == 0L) {
    abort("`...` can't be empty.", call = error_call)
  }
  if ((n_args %% 2L) != 0L) {
    message <- c(
      "`...` must contain an even number of inputs.",
      i = glue("{n_args} inputs were provided.")
    )
    abort(message, call = error_call)
  }

  loc_conditions <- seq.int(1L, n_args - 1L, by = 2)
  loc_values <- loc_conditions + 1L

  conditions <- args[loc_conditions]
  values <- args[loc_values]

  list(
    conditions = conditions,
    values = values
  )
}

list_names <- function(x, arg = "") {
  names <- names2(x)
  unnamed <- names == ""

  if (arg == "") {
    loc_unnamed <- which(unnamed)
    names[loc_unnamed] <- vec_paste0("..", loc_unnamed)
  } else {
    loc_named <- which(!unnamed)
    loc_unnamed <- which(unnamed)
    names[loc_named] <- vec_paste0(arg, "$", names[loc_named])
    names[loc_unnamed] <- vec_paste0(arg, "[[", loc_unnamed, "]]")
  }

  names
}

vec_paste0 <- function (...) {
  args <- vec_recycle_common(...)
  exec(paste0, !!!args)
}
