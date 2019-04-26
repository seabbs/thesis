library(ini)
context("write ini")

test_that("write.ini write ini to file", {
  
  iniFile <- tempfile(fileext = '.ini')
  on.exit(file.remove(iniFile))
  ini <- list('Hello World'=c(list('Foo'='Bar'), list('Foo1'='Bar=345')))
  write.ini(ini, iniFile)
  
  expect_equal(readLines(iniFile), readLines("writeini.txt"))
})
