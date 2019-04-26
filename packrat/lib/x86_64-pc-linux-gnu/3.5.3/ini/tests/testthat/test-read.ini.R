library(ini)
context("read.ini")

test_that("read.ini parse ini files", {
  expect_equal(read.ini("writeini.txt"), list('Hello World'=c(list('Foo'='Bar'), list('Foo1'='Bar=345'))))
  expect_warning(read.ini(""))
})
