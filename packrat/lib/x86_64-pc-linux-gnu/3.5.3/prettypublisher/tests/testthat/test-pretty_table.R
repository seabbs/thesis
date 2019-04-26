context("pretty_table")

test_that("pretty_table output matches that from kable", {
  df <- iris[1, 1:2]
  expect_equal(kable(df), pretty_table(df, tab_fun = kable))
})

test_that("pretty_table output matches that from kable;
          given no caption function specified", {
  df <- iris[1, 1:2]
  expect_equal(kable(df), pretty_table(df, cap_fun = NULL, tab_fun = kable))
})

test_that("pretty_table adds footer for kable function", {
  df <- iris[1, 1:2]
  expect_out <- c("|Sepal.Length   |Sepal.Width |",
                  "|:--------------|:-----------|",
                  "|5.1            |3.5         |",
                  "|Example footer |            |")

  expect_equal(expect_out,
               as.character(pretty_table(df,
                                         footer = "Example footer",
                                         tab_fun = kable)))
})


test_that("pretty table changes column names", {
  df <- iris[1, 1:2]
  expect_out <- c("|   1|   2|", "|---:|---:|", "| 5.1| 3.5|")

  expect_equal(expect_out,
               as.character(pretty_table(df,
                                         col_names = as.character(1:2),
                                         tab_fun = kable)))
})

test_that("pretty table requires a table function to wrap", {
  expect_error(pretty_table(iris, tab_fun = NULL))
})

test_that("pretty table produces a table with no label or caption set", {
  df <- iris[1:2, 1:2]
  expect_out <- c("| Sepal.Length| Sepal.Width|",
                  "|------------:|-----------:|",
                  "|          5.1|         3.5|",
                  "|          4.9|         3.0|")

  expect_equal(expect_out,
               as.character(pretty_table(df,
                                         tab_fun = kable,
                                         cap_fun = paste0)))
})

test_that("pretty table produces a table with no label set", {
  df <- iris[1:2, 1:2]
  expect_out <- c("| Sepal.Length| Sepal.Width|",
                  "|------------:|-----------:|",
                  "|          5.1|         3.5|",
                  "|          4.9|         3.0|")

  expect_equal(expect_out,
               as.character(pretty_table(df,
                                         tab_fun = kable,
                                         caption = "",
                                         cap_fun = paste0)))
})


test_that("pretty table produces a table with no caption set", {
  df <- iris[1:2, 1:2]
  expect_out <- c("| Sepal.Length| Sepal.Width|",
                  "|------------:|-----------:|",
                  "|          5.1|         3.5|",
                  "|          4.9|         3.0|")

  expect_equal(expect_out,
               as.character(pretty_table(df,
                                         tab_fun = kable,
                                         label = "",
                                         cap_fun = paste0)))
})

test_that("pretty table can pass a vector", {
  expect_out <- c("|&nbsp; | &nbsp;|",
                  "|:------|------:|",
                  "|       |      1|",
                  "|       |      2|",
                  "|       |      3|")

  expect_equal(expect_out,
               as.character(pretty_table(c(1, 2, 3),
                                         tab_fun = kable,
                                         label = "",
                                         cap_fun = paste0)))
})



