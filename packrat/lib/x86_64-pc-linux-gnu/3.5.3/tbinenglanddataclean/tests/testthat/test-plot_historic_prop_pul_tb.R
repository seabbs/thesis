context("plot_historic_prop_pul_tb")


test_that("A plot is created with default settings", {
  vdiffr::expect_doppelganger("base_line_plot",
                              plot_historic_prop_pul_tb())
})

test_that("A plot is created with a specified colour scale", {
  vdiffr::expect_doppelganger("plot_with_scale",
                                plot_historic_prop_pul_tb(colour_scale = scale_colour_brewer())

  )
})

test_that("A plot is created with a specified theme",{
  vdiffr::expect_doppelganger("plot_with_theme",
                                plot_historic_prop_pul_tb(plot_theme = theme_bw())
                                )
})