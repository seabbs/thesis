context("pretty_figref")

test_that("pretty_figref works correctly
          as an aliases for pretty_captioner", {
  expect_equal("Figure 1: Example caption",
               pretty_figref("1", "Example caption"))
})
