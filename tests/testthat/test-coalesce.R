test_that("names in error messages are indexed correctly", {
  expect_snapshot(error = TRUE, {
    coalesce(1, "x")
  })
  expect_snapshot(error = TRUE, {
    coalesce(1, y = "x")
  })
})

test_that("`...` can't be empty", {
  expect_snapshot(error = TRUE, {
    coalesce()
  })
  expect_snapshot(error = TRUE, {
    coalesce(NULL)
  })
})

test_that("recycling is done on the values early", {
  expect_identical(coalesce(1, 1:2), c(1, 1))
})

test_that("inputs are recycled to their common size", {
  expect_identical(coalesce(1, c(2, 3)), c(1, 1))
})

test_that("inputs are cast to their common type", {
  expect_identical(coalesce(1L, 2), 1)
})

test_that("`.ptype` can override the common type", {
  expect_identical(coalesce(1L, 2, .ptype = integer()), 1L)
})

test_that("`.size` can override the common size", {
  expect_snapshot(error = TRUE, {
    coalesce(1L, 2:4, .size = 2L)
  })
  expect_snapshot(error = TRUE, {
    coalesce(1L, x = 2:4, .size = 2L)
  })
})

test_that("`NULL` inputs are dropped", {
  expect_identical(coalesce(c(NA, 1), NULL, 2), c(2, 1))
})
