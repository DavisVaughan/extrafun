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
})
