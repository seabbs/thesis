context("mcmc tidiers")

test_that("tidy.stanfit works", {
    skip_if_not_installed("rstan")
    infile <- system.file("extdata", "rstan_example.rda", package = "broom")
    load(infile)

    td <- tidy(rstan_example, conf.int = TRUE, rhat = TRUE, ess = TRUE)
    check_tidy(td, exp.row = 18, exp.col = 7)
})
