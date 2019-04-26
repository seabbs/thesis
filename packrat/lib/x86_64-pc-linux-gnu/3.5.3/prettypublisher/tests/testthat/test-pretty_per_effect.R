context("pretty_per_effect")

test_that("pretty_per_effect produces a publishable percentage effect", {
  expect_equal("2% (1% to 3%)",
               pretty_per_effect(1.02, lci = 1.01, uci = 1.03, digits = 0, sep = " to "))
})

test_that("pretty_per_effect can handle a single formated string", {
  est <- 1.2
  lci <- 1.1
  uci <- 1.3
  x <- pretty_ci(est, lci, uci, inline = TRUE)

  expect_equal("20% (95% CI 10% to 30%)",
               pretty_per_effect(x, string = TRUE, inline = TRUE))
})

test_that("pretty_per_effect can handle decreasing percentage", {
  est <- 1.2
  lci <- 1.1
  uci <- 1.3
  x <- pretty_ci(est, lci, uci, inline = TRUE)

  expect_equal("-20% (95% CI -30% to -10%)",
               pretty_per_effect(x, string = TRUE, inline = TRUE,
                                 effect_direct = "decrease"))
})

test_that("pretty_per_effect fails when effect_direct is mispecified", {
  expect_error(pretty_per_effect(x, string = TRUE, effect_direct = "nonsense"))
})

test_that("pretty_per_effect can handle vectorised input", {
  est <- c(1.2, 1.1)
  lci <- c(1.1, 1)
  uci <- c(1.3, 1.2)

  expect_equal(pretty_per_effect(est, lci, uci), c("20% (10% to 30%)", "10% (0% to 20%)"))
})

test_that("pretty_per_effect can handle specified seperators", {
  est <- c(1.2, 1.1)
  lci <- c(1.1, 1)
  uci <- c(1.3, 1.2)

  x <- pretty_ci(est, lci, uci, inline = TRUE, sep = ", ")

  expect_equal(pretty_per_effect(x[1], string = TRUE, inline = TRUE, sep = ", "),
               "20% (95% CI 10%, 30%)")
  expect_equal(pretty_per_effect(x, string = TRUE, inline = TRUE, sep = ", "),
               c("20% (95% CI 10%, 30%)",
                 "10% (95% CI 0%, 20%)"))
})
