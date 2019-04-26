context("pretty_suptabref")

test_that("pretty_suptabref works correctly
          as an aliases for pretty_captioner", {
  expect_equal("Supplementary Table S1: Example caption",
               pretty_suptabref("1", "Example caption"))
})
