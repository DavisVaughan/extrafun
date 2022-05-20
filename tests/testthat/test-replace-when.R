test_that("works with data frames", {
  df <- data_frame(x = 3:6, y = 4:7)

  out <- replace_when(
    df,
    df$x < 4, data_frame(x = 99, y = 100),
    df$y > 5, data_frame(x = 0, y = 0)
  )

  expect_identical(
    out,
    data_frame(
      x = c(99L, 4L, 0L, 0L),
      y = c(100L, 5L, 0L, 0L)
    )
  )
})

test_that("stops replacing at the first hit", {
  x <- c(1, 2, 3, 4, NA, 5, 6)

  replace <- c(rep(99, 4), rep(100, 3))

  out <- replace_when(
    x,
    x < 2, 10,
    x < 6, replace,
    is.na(x), 0,
    is.na(x), -1
  )

  expect_identical(out, c(10, 99, 99, 99, 0, 100, 6))
})

test_that("works when the replacement values are missing values", {
  expect_identical(
    replace_when(c(1, 2), c(TRUE, FALSE), NA),
    c(NA, 2)
  )
})

test_that("can handle when `x` is <unspecified>", {
  x <- NA
  expect_identical(replace_when(x, is.na(x), TRUE), TRUE)
})

test_that("is size stable on `x`", {
  expect_snapshot(error = TRUE, {
    replace_when(5:10, c(TRUE, FALSE), 2)
  })
  expect_snapshot(error = TRUE, {
    replace_when(5:10, rep(TRUE, 6), 2:3)
  })
})

test_that("is type stable on `x`", {
  expect_identical(replace_when(1:2, c(TRUE, FALSE), 3), c(3L, 2L))

  expect_snapshot(error = TRUE, {
    replace_when(1L, TRUE, 1, FALSE, "x")
  })
})

test_that("`...` can't be empty", {
  expect_snapshot(error = TRUE, {
    replace_when(1)
  })
})
