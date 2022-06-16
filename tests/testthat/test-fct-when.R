test_that("result is ordered by default, but can opt out with `.ordered`", {
  expect_s3_class(fct_when(TRUE, "a"), c("ordered", "factor"), exact = TRUE)
  expect_s3_class(fct_when(TRUE, "a", .ordered = FALSE), "factor", exact = TRUE)
})

test_that("names are retained", {
  out <- fct_when(
    c(TRUE, FALSE, TRUE), c(a = "x"),
    c(FALSE, TRUE, TRUE), c(b = "y")
  )

  expect_identical(
    out,
    factor(c(a = "x", b = "y", a = "x"), levels = c("x", "y"), ordered = TRUE)
  )
})

test_that("levels are used in order they appear", {
  expect_identical(
    levels(fct_when(
      c(FALSE, TRUE), "a",
      c(TRUE, FALSE), "b"
    )),
    c("a", "b")
  )
})

test_that("levels are used regardless of whether they appear in the final data", {
  expect_identical(
    levels(fct_when(FALSE, "x", FALSE, "y")),
    c("x", "y")
  )
  expect_identical(
    levels(fct_when(TRUE, "x", FALSE, "y", .default = "z")),
    c("x", "y", "z")
  )
})

test_that("`.default` is used when no condition is `TRUE`", {
  out <- fct_when(
    c(TRUE, FALSE, FALSE, NA),
    "a",
    c(TRUE, TRUE, FALSE, NA),
    "b",
    .default = "c"
  )

  expect_identical(out, factor(c("a", "b", "c", "c"), ordered = TRUE))
})

test_that("unhandled value results in implicit `NA` level", {
  out <- fct_when(
    c(TRUE, NA, FALSE, NA),
    "a",
    c(TRUE, TRUE, FALSE, NA),
    "b"
  )

  expect_identical(
    out,
    factor(c("a", "b", NA, NA), levels = c("a", "b"), ordered = TRUE)
  )
})

test_that("explicit `NA` in `.default` results in an explicit `NA` level", {
  expect_identical(
    levels(fct_when(TRUE, "x", FALSE, "y", .default = NA)),
    c("x", "y", NA)
  )
})

test_that("explicit `NA` in value inputs results in an explicit `NA` level", {
  expect_identical(
    levels(fct_when(TRUE, NA, FALSE, "x")),
    c(NA, "x")
  )
})

test_that("level inputs are cast to character", {
  expect_snapshot(error = TRUE, {
    fct_when(TRUE, 1)
  })
})

test_that("`.default` is cast to character", {
  expect_snapshot(error = TRUE, {
    fct_when(TRUE, "x", .default = 1)
  })
})

test_that("levels can't be duplicated", {
  # Make sure indexing is correct in error message!
  expect_snapshot(error = TRUE, {
    fct_when(c(TRUE, FALSE), "x", c(FALSE, TRUE), "x")
  })

  expect_snapshot(error = TRUE, {
    fct_when(c(TRUE, FALSE), "x", .default = "x")
  })
})

test_that("level inputs must be single strings", {
  # Make sure indexing is correct in error message!
  expect_snapshot(error = TRUE, {
    fct_when(c(TRUE, FALSE), "x", c(FALSE, TRUE), c("a", "b"))
  })

  expect_snapshot(error = TRUE, {
    fct_when(c(TRUE, FALSE), "x", c(FALSE, TRUE), bar = c("a", "b", "c"))
  })
})

test_that("must contain at least one input", {
  expect_snapshot(error = TRUE, {
    fct_when()
  })
})

test_that("must contain an even number of inputs", {
  expect_snapshot(error = TRUE, {
    fct_when(TRUE)
  })
})

test_that("`.default` must be a single string", {
  expect_snapshot(error = TRUE, {
    fct_when(c(TRUE, FALSE), "x", .default = c("a", "b"))
  })
})

test_that("`.size` can enforce a size for the logical conditions", {
  expect_snapshot(error = TRUE, {
    fct_when(TRUE, "x", .size = 2)
  })
})

test_that("`.ordered` is validated", {
  expect_snapshot(error = TRUE, {
    fct_when(TRUE, "x", .ordered = 1)
  })
})
