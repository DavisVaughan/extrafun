test_that("works with data frames", {
  out <- vec_case_when(
    c(FALSE, TRUE, FALSE, FALSE), data_frame(x = 1, y = 2),
    c(TRUE, TRUE, FALSE, FALSE), data_frame(x = 3, y = 4),
    c(FALSE, TRUE, FALSE, TRUE), data_frame(x = 3:6, y = 4:7),
  )

  expect_identical(
    out,
    data_frame(
      x = c(3, 1, NA, 6),
      y = c(4, 2, NA, 7)
    )
  )
})

test_that("first `TRUE` case wins", {
  expect_identical(
    vec_case_when(c(TRUE, FALSE), 1, c(TRUE, TRUE), 2, c(TRUE, TRUE), 3),
    c(1, 2)
  )
})

test_that("can replace missing values", {
  x <- c(1:3, NA)

  expect_identical(
    vec_case_when(
      x <= 1, 1,
      x <= 2, 2,
      is.na(x), 0
    ),
    c(1, 2, NA, 0)
  )
})

test_that("odd numbered inputs can be size zero", {
  expect_identical(
    vec_case_when(
      integer(), 1,
      integer(), 2
    ),
    numeric()
  )

  expect_snapshot(error = TRUE, {
    vec_case_when(integer(), 1:2)
  })
})

test_that("retains names of inputs", {
  value1 <- c(x = 1, y = 2)
  value2 <- c(z = 3, w = 4)

  out <- vec_case_when(
    c(TRUE, FALSE), value1,
    c(TRUE, TRUE), value2
  )

  expect_named(out, c("x", "w"))
})

test_that("even numbered inputs are cast to their common type", {
  expect_identical(vec_case_when(FALSE, 1, TRUE, 2L), 2)
  expect_identical(vec_case_when(FALSE, 1, TRUE, NA), NA_real_)

  expect_snapshot(error = TRUE, {
    vec_case_when(FALSE, 1, TRUE, "x")
  })
})

test_that("even numbered inputs must be size 1 or same size as logical conditions", {
  expect_identical(
    vec_case_when(c(TRUE, TRUE), 1),
    c(1, 1)
  )
  expect_identical(
    vec_case_when(c(TRUE, FALSE), c(1, 2), c(TRUE, TRUE), c(3, 4)),
    c(1, 4)
  )

  # Make sure input numbering is right in the error message!
  expect_snapshot(error = TRUE, {
    vec_case_when(c(TRUE, FALSE, TRUE, TRUE), 1:3)
  })
})

test_that("`NA` in odd numbered inputs becomes `FALSE`", {
  expect_identical(vec_case_when(NA, 1, default = 2), 2)
})

test_that("A `NULL` `default` fills in with missing values", {
  expect_identical(
    vec_case_when(c(TRUE, FALSE, FALSE), 1),
    c(1, NA, NA)
  )
})

test_that("`default` fills in all unused slots", {
  expect_identical(
    vec_case_when(c(TRUE, FALSE, FALSE), 1, default = 2),
    c(1, 2, 2)
  )
})

test_that("`default` is initialized correctly in the logical / unspecified case", {
  # i.e. `vec_ptype(NA)` is unspecified but the result should be finalized to logical
  expect_identical(vec_case_when(FALSE, NA), NA)
})

test_that("`default` must be size 1", {
  expect_snapshot(error = TRUE, {
    vec_case_when(FALSE, 1L, default = 2:3)
  })
})

test_that("`default` is cast to `...` ptype", {
  expect_identical(vec_case_when(FALSE, 1L, default = 2), 2L)

  expect_snapshot(error = TRUE, {
    vec_case_when(FALSE, 1L, default = 2.5)
  })
})

test_that("odd numbered inputs must all be the same size", {
  expect_snapshot(error = TRUE, {
    vec_case_when(c(TRUE, FALSE), 1, TRUE, 2)
  })
  expect_snapshot(error = TRUE, {
    vec_case_when(c(TRUE, FALSE), 1, c(TRUE, FALSE, TRUE), 2)
  })
})

test_that("odd numbered inputs must be logical", {
  expect_snapshot(error = TRUE, {
    vec_case_when(1.5, 2)
  })

  # Make sure input numbering is right in the error message!
  expect_snapshot(error = TRUE, {
    vec_case_when(1, 2, 3.5, 4)
  })
})

test_that("`size` overrides the odd numbered input sizes", {
  expect_snapshot(error = TRUE, {
    vec_case_when(TRUE, 1, size = 5)
  })

  # Make sure input numbering is right in the error message!
  expect_snapshot(error = TRUE, {
    vec_case_when(c(TRUE, FALSE), 1, c(TRUE, FALSE, TRUE), 2, size = 2)
  })
})

test_that("`ptype` overrides the even numbered input types", {
  expect_identical(
    vec_case_when(FALSE, 1, TRUE, 2, ptype = integer()),
    2L
  )

  # Make sure input numbering is right in the error message!
  expect_snapshot(error = TRUE, {
    vec_case_when(FALSE, 1, TRUE, 2, ptype = character())
  })
})

test_that("can't have an odd number of inputs", {
  expect_snapshot(error = TRUE, {
    vec_case_when(1)
  })
  expect_snapshot(error = TRUE, {
    vec_case_when(1, 2, 3)
  })
})

test_that("can't have empty dots", {
  expect_snapshot(error = TRUE, {
    vec_case_when()
  })
  expect_snapshot(error = TRUE, {
    vec_case_when(default = 1)
  })
})

test_that("named dots show up in the error message", {
  expect_snapshot(error = TRUE, {
    vec_case_when(x = 1.5, 1)
  })
  expect_snapshot(error = TRUE, {
    vec_case_when(x = TRUE, 1, y = c(TRUE, FALSE), 2)
  })
  expect_snapshot(error = TRUE, {
    vec_case_when(TRUE, 1, FALSE, x = "y")
  })
})
