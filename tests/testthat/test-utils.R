# ------------------------------------------------------------------------------
# list_names()

test_that("unnamed names get named with correct indices", {
  expect_identical(list_names(list(1)), "..1")
  expect_identical(list_names(list(1, x = 2, 3)), c("..1", "x", "..3"))
})

test_that("names aren't deduplicated", {
  expect_identical(list_names(list(x = 1, x = 2)), c("x", "x"))
})

test_that("using an `arg` adds a prefix", {
  expect_identical(list_names(list(1, x = 2), arg = "foo"), c("foo[[1]]", "foo$x"))
})
