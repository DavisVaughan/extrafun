# ------------------------------------------------------------------------------
# name_unnamed()

test_that("unnamed names get named with correct indices", {
  expect_identical(name_unnamed(""), "..1")
  expect_identical(name_unnamed(c("", "x", "")), c("..1", "x", "..3"))
})

test_that("names aren't deduplicated", {
  expect_identical(name_unnamed(c("x", "x")), c("x", "x"))
})
