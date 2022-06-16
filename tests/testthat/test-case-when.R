test_that("passes through to vec_case_when()", {
  expect_identical(
    case_when(c(TRUE, FALSE, FALSE), 1:3, c(TRUE, TRUE, FALSE), 4:6),
    c(1L, 5L, NA)
  )
})

test_that("`.missing` shows the right arg name", {
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, .missing = "x")
  })
})

test_that("`.default` shows the right arg name", {
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, .default = "x")
  })
})

test_that("input names are used in error messages", {
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, x = 1, 2)
  })
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, TRUE, x = "x")
  })
})

test_that("inputs are automatically named with their position for error messages", {
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, 1, 2)
  })
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, TRUE, "x")
  })
})

test_that("must be an even number of inputs", {
  expect_snapshot(error = TRUE, {
    case_when(TRUE)
  })
  expect_snapshot(error = TRUE, {
    case_when(TRUE, 1, TRUE)
  })
})

test_that("errors with zero inputs", {
  expect_snapshot(error = TRUE, {
    case_when()
  })
  expect_snapshot(error = TRUE, {
    case_when(.default = 1)
  })
})
