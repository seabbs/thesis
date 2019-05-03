context("pretty_supfigref")

test_that("pretty_supfigref works correctly
          as an aliases for pretty_captioner", {
  expect_equal("Supplementary Figure S1: Example caption",
               pretty_supfigref("1", "Example caption"))
})
