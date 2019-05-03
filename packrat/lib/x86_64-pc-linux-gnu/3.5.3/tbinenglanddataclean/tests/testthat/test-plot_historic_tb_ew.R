context("plot_historic_tb_ew")



test_that("Default plot is produced", {
  vdiffr::expect_doppelganger("base_line_plot",
                      plot_historic_tb_ew())
})



test_that("Plot is produced with no zooming", {
  vdiffr::expect_doppelganger("no_zoom",
                              plot_historic_tb_ew(zoom_date_start = NULL))
})

test_that("Plot is produced with a supplied colour scheme", {
  vdiffr::expect_doppelganger("new_colour",
                              plot_historic_tb_ew(colour_scale = scale_colour_brewer()))
})

test_that("Plot is produced with a supplied theme", {
  vdiffr::expect_doppelganger("new_theme",
                              plot_historic_tb_ew(plot_theme = theme_bw()))
})