context("polca tidiers")

f <- cbind(A, B, C, D)~1

test_that("polca tidiers work", {
    skip_if_not_installed("poLCA")
    require(poLCA)
    data(values)
    M1 <- poLCA(f, values, nclass = 2, verbose = FALSE)

    td <- tidy(M1)
    check_tidy(td, exp.row = 16, exp.col = 5)
    
    au <- augment(M1)
    check_tidy(au, exp.col = 7)
    
    gl <- glance(M1)
    check_tidy(gl, exp.col = 7)
})

test_that("data argument can be added for augment", {
    skip_if_not_installed("poLCA")
    require(poLCA)
    
    data(values)
    M1 <- poLCA(f, values, nclass = 2, verbose = FALSE)
    
    au <- augment(M1, values)
    check_tidy(au, exp.col = 6)
})

test_that("rows removed for NAs get new columns with NAs", {
    skip_if_not_installed("poLCA")
    require(poLCA)
    
    data(values)

    values2 <- values
    values2[1, 1] <- NA
    M2 <- poLCA(f, values2, nclass = 2, verbose = FALSE)
    
    au <- augment(M2, values)
    check_tidy(au, exp.col = 6)
})
