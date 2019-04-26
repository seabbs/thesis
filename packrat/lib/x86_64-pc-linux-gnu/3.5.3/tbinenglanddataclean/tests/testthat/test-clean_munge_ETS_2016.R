context("clean_munge_ETS_2016")

test_that("clean_munge_ETS_2016 fails correctly when file paths are not specified", {
  expect_error(clean_munge_ETS_2016(save_path = ''))
  expect_error(clean_munge_ETS_2016(data_path = ''))
})

