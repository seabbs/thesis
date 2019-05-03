context("pretty_round")

test_that("pretty_round adds trailing zeros as expected", {
  expect_match(pretty_round(2.1, digits = 2), "2.10")
})

test_that("pretty_round matches rounding behaviour seen in round", {
  expect_equal(round(4.24343, digits = 3 ),
               as.numeric(pretty_round(4.24343, digits = 3)))
})

test_that("pretty_round is correctly dealing with numeric vector inputs", {
  vector <- c(1.33, 13123423.234124, 0.232342, 0.000492, 1.343)
  char_vector <- c("1.33", "13123423.23", "0.23", "0.00", "1.34")
  expect_length(pretty_round(vector), length(vector))
  expect_equal(char_vector, pretty_round(vector, digits = 2))
})

test_that("pretty round can succesfully convert character input", {
  expect_equal("2.00", pretty_round("2", digits = 2))
})


test_that("pretty round can pass values not to be formated", {
  vector <- c("", " ", "Inf", NaN, NA)
  char_vector <- c("", "", "Inf", NaN, NA)
  expect_length(pretty_round(vector), length(vector))
  expect_equal(char_vector, pretty_round(vector, digits = 2))
})
