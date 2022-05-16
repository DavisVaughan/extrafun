test_that("works with data frames", {
  out <- if_else(
    c(FALSE, TRUE, FALSE, NA),
    data_frame(x = 1, y = 2),
    data_frame(x = 3, y = 4),
    missing = data_frame(x = 3:6, y = 4:7)
  )

  expect_identical(
    out,
    data_frame(
      x = c(3, 1, 3, 6),
      y = c(4, 2, 4, 7)
    )
  )
})

test_that("is size stable on the size of `condition`", {
  expect_snapshot(error = TRUE, {
    if_else(TRUE, 1:2, 1L)
  })
})

test_that("If `missing` isn't supplied, defaults to a missing value", {
  expect_identical(
    if_else(c(NA, TRUE, FALSE), 1, 2),
    c(NA, 1, 2)
  )
})

test_that("If `missing` is supplied, uses it", {
  expect_identical(
    if_else(c(NA, TRUE, FALSE), 1, 2, missing = c(3, 4, 5)),
    c(3, 1, 2)
  )
})

test_that("`condition` must be castable to logical", {
  expect_snapshot(error = TRUE, {
    if_else("x", 1, 2)
  })
})

test_that("common type errors mention arg names", {
  expect_snapshot(error = TRUE, {
    if_else(TRUE, "x", 3)
  })
  expect_snapshot(error = TRUE, {
    if_else(TRUE, "x", "y", missing = 3)
  })
})

test_that("common size errors mention arg names", {
  expect_snapshot(error = TRUE, {
    if_else(c(TRUE, FALSE), 1:3, 1)
  })
  expect_snapshot(error = TRUE, {
    if_else(c(TRUE, FALSE), 1, 1:3)
  })
})

test_that("must have empty dots", {
  expect_snapshot(error = TRUE, {
    if_else(TRUE, 1, 2, 3)
  })
})
