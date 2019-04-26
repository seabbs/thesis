context("pretty_ci")

test_that("pretty_ci produces a publishable ci", {
  expect_equal("2.00 (1.00 to 3.00)",
               pretty_ci(2, lci = 1, uci = 3, digits = 2, sep = " to "))
})

test_that("pretty_ci can handle a single string", {
  expect_equal("2.00 (1.00 to 3.00)",
               pretty_ci(est = c(2, 1, 3), string = TRUE, digits = 2, sep = " to "))
})

test_that("pretty_ci can handle character input", {
  expect_equal("2.00 (1.00 to 3.00)",
               pretty_ci("2", lci = "1", uci = "3", digits = 2, sep = " to "))
})

test_that("pretty_ci can return a ci with an explantory note", {
  expect_equal("2.00 (95% CI 1.00 to 3.00)",
               pretty_ci("2", lci = "1", uci = "3", digits = 2,
                         sep = " to ", inline = TRUE, note = "95% CI "))
})

test_that("pretty_ci can handle a vector of inputs", {
  expect_equal(c("0.0 (-123.0-10.0)",
                 "1.0 (-0.2-2.0)",
                 "100.0 (50.0-200.0)",
                 "300.0 (100.0-400.0)",
                 "21221.0 (12321.0-30122.0)",
                 "403.0 (200.0-500.0)"),
               pretty_ci(est = c(0, 1, 100, 300, 21221, 403),
                         lci = c(-123, -0.2, 50, 100, 12321, 200),
                         uci = c(10, 2, 200, 400, 30122, 500),
                         sep = "-",
                         digits = 1)
               )
})




test_that("pretty_ci can be used in a dplyr workflow", {
  df_input <- data_frame(est = c(0, 1), lci = c(0, 2), uci = c(1, 4))
  df_int <- mutate(df_input, ci = pretty_ci(est = est,
                                            lci = lci,
                                            uci = uci,
                                            sep = " by ",
                                            digits = 0)
                   )
  df_output <- c("0 (0 by 1)", "1 (2 by 4)")

    expect_equal(nrow(df_input), nrow(df_int))
    expect_equal(df_output, df_int$ci)
            })

test_that("pretty_ci can be used in a dplyr workflow with the estimate as a string", {
  df_input <- data_frame(est = c(0, 1), lci = c(0, 2), uci = c(1, 4))
  df_int <- mutate(df_input, ci = pretty_ci(est = df_input,
                                            string = TRUE,
                                            sep = " by ",
                                            digits = 0)
  )
  df_output <- c("0 (0 by 1)", "1 (2 by 4)")

  expect_equal(nrow(df_input), nrow(df_int))
  expect_equal(df_output, df_int$ci)
})


test_that("pretty_ci can be used to produe a percentage", {
  expect_equal("84% (82% to 96%)",
               pretty_ci(est = 84, lci = 82, uci = 96,
                         digits = 0, sep = " to ", percentage = TRUE))
})
