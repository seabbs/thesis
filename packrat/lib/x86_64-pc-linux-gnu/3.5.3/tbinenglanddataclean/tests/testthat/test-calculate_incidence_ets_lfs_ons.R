context("calculate_incidence_ets_lfs_ons.R")

test_that("Test that process incidence is the same as previously",{
  skip_if(!dir.exists("../../data/tb_data/tbinenglanddataclean"), "TB data is not available for test")
  
  tmp <- suppressWarnings(calculate_incidence_ets_lfs_ons(data_path = "../../data/tb_data/tbinenglanddataclean",
                                  ets_name = "clean_ets_2016.rds",
                                  demo_name = "E_ons_lfs_2000_2016.rds",
                                  return = TRUE,
                                  save = FALSE,
                                  verbose = FALSE))
  
  expect_known_hash(tmp, hash = "988bf63907")
})


test_that("Test that incidence estimation works with no missing data",{
  skip_if(!dir.exists("../../data/tb_data/tbinenglanddataclean"), "TB data is not available for test")
  
  ets <- readRDS("../../data/tb_data/tbinenglanddataclean/clean_ets_2016.rds")
  
  ets_complete <- tidyr::drop_na(ets, ukborn)
  
  saveRDS(ets_complete, "../../data/tb_data/tbinenglanddataclean/test_complete_ets.rds")
  
  tmp <- suppressWarnings(calculate_incidence_ets_lfs_ons(data_path = "../../data/tb_data/tbinenglanddataclean",
                                         ets_name = "test_complete_ets.rds",
                                         demo_name = "E_ons_lfs_2000_2016.rds",
                                         return = TRUE,
                                         save = FALSE,
                                         verbose = FALSE))
  
  system("rm ../../data/tb_data/tbinenglanddataclean/test_complete_ets.rds")
  
  expect_known_hash(tmp, hash = "b690694d46")
})