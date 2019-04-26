context("pretty_inline_ci")


test_that("pretty_inline_ci produces a publishable inline ci", {
  expect_equal("2.00 (95% CI 1.00 to 3.00)",
               pretty_inline_ci("2.00 (1.00 to 3.00)",
                                note = "95% CI ")
               )
})

test_that("pretty_inline_ci can change note added", {
  expect_equal("2.00 (90% credible interval: 1.00 to 3.00)",
               pretty_inline_ci("2.00 (1.00 to 3.00)",
                                note = "90% credible interval: ")
  )
})

test_that("pretty_inline_ci can change note added and not add bracket", {
  expect_equal("2.00 90% credible interval: 1.00 to 3.00)",
               pretty_inline_ci("2.00 (1.00 to 3.00)",
                                note = "90% credible interval: ",
                                replace_bracket = FALSE)
  )
})

test_that("pretty_inline_ci can handle a vector of inputs", {
  expect_equal(c("0.0 (95% CI -123.0-10.0)",
                 "1.0 (95% CI -0.2-2.0)"),
               pretty_inline_ci(c("0.0 (-123.0-10.0)",
                                "1.0 (-0.2-2.0)"),
                                note = "95% CI ")
  )
})
