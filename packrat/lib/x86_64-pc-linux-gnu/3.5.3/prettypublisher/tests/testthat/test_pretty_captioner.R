context("pretty_captioner")

test_that("pretty_captioner can used without a label to specify
          captioning options", {
  expect_equal(NULL,
               pretty_captioner(cap_fun_name = "test0", reinit = TRUE))
          })

test_that("pretty_captioner can be used inline", {
  expect_equal("Figure 1", pretty_captioner("1",
                                             display = "c",
                                             cap_fun_name = "test1"))
  expect_equal("figure 1", pretty_captioner("1",
                                             display = "c",
                                             cap_fun_name = "test1",
                                             inline = TRUE))
})

test_that("pretty_captioner can correctly generate multiple captions", {
  expect_equal("Figure 1: Example caption",
               pretty_captioner("1",
                                "Example caption",
                                 cap_fun_name = "test2"))
  expect_true(exists("test1"))
  expect_equal("Figure 2: Example caption",
               pretty_captioner("2",
                                "Example caption",
                                cap_fun_name = "test2"))
})

test_that("pretty_captioner displays only cite information correctly", {
  expect_equal("Figure 1", pretty_captioner("3",
                                "Example caption",
                                display = "c",
                                cap_fun_name = "test3"))
})

test_that("pretty_captioner can detect if captioner function
          has been altered", {
  expect_equal("Figure S1: Example caption",
               pretty_captioner("1",
                                "Example caption",
                                sec_prefix = "S",
                                cap_fun_name = "test3", reinit = TRUE))
  expect_true(exists("test3"))

  cap <- get("test3")
  cap <- sum
  assign("test3", cap, envir = globalenv())
  expect_error(pretty_captioner("2", "Example caption", cap_fun_name = "test3"))
  })
