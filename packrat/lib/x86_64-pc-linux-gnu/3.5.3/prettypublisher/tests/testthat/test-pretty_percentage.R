context("pretty_percentage")

test_that("pretty_percentage produces a publishable percentage", {
  expect_equal("35% (35/100)", pretty_percentage(35, 100, digits = 0))
})

test_that("pretty_percentage produces a publishable proportion", {
  expect_equal("0.05 (23/457)", pretty_percentage(23, 457, digits = 2,
                                                  percent_scaling = 1,
                                                  as_per = FALSE))
})


test_that("pretty_percentage can cope with a single denominator,
          and multiple numerators", {
    num_vector <- c(100, 10, 45, 1000, 45, 201, 34, 16)
    denom_vector <- c(1000)
    results_vector <- c("10.0% (100/1000)", "1.0% (10/1000)",
                        "4.5% (45/1000)", "100.0% (1000/1000)",
                        "4.5% (45/1000)", "20.1% (201/1000)",
                        "3.4% (34/1000)", "1.6% (16/1000)")

    expect_length(pretty_percentage(num_vector, denom_vector, digits = 1),
                  length(results_vector))
    expect_equal(results_vector, pretty_percentage(num_vector,
                                                   denom_vector,
                                                   digits = 1))
  })

test_that("pretty_percentage is correctly dealing
          with numeric vector inputs", {
  num_vector <- c(100, 10, 45, 1000, 45, 201, 34, 16)
  denom_vector <- c(232, 100, 398, 2332, 20321, 10, 100, 48)
  results_vector <- c("43.1% (100/232)",   "10.0% (10/100)",
                      "11.3% (45/398)", "42.9% (1000/2332)",
                      "0.2% (45/20321)", "2010.0% (201/10)",
                      "34.0% (34/100)", "33.3% (16/48)")

  expect_length(pretty_percentage(num_vector,
                                  denom_vector, digits = 1),
                length(results_vector))
  expect_equal(results_vector,
               pretty_percentage(num_vector,
                                 denom_vector,
                                 digits = 1))
})
