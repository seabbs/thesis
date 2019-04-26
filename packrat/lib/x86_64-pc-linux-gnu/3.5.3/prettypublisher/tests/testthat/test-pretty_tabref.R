context("pretty_tabref")

test_that("pretty_tabref works correctly
          as an aliases for pretty_captioner", {
  expect_equal("Table 1: Example caption",
               pretty_tabref("1", "Example caption", reinit = TRUE))
})
