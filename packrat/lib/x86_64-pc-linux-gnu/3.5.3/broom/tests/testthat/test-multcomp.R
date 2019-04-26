context("multcomp tidiers")

test_that("tidy.glht works", {
    skip_if_not_installed("multcomp")
    require(multcomp)

    amod <- aov(breaks ~ wool + tension, data = warpbreaks)
    wht <- glht(amod, linfct = mcp(tension = "Tukey"))

    td <- tidy(wht)
    check_tidy(td, exp.row = 3, exp.col = 3)
})

test_that("tidy.confint.glht and tidy.summary.glht works", {
    skip_if_not_installed("multcomp")
    require(multcomp)
    amod <- aov(breaks ~ wool + tension, data = warpbreaks)
    wht <- glht(amod, linfct = mcp(tension = "Tukey"))
    
    CI <- confint(wht)
    td <- tidy(CI)
    check_tidy(td, exp.row = 3, exp.col = 5)

    ss <- summary(wht)
    td <- tidy(ss)
    check_tidy(td, exp.row = 3, exp.col = 6)    
})

test_that("tidy.clt works", {
    skip_if_not_installed("multcomp")
    require(multcomp)
    
    amod <- aov(breaks ~ wool + tension, data = warpbreaks)
    wht <- glht(amod, linfct = mcp(tension = "Tukey"))

    cld <- cld(wht)
    td <- tidy(cld)
    check_tidy(td, exp.row = 3, exp.col = 2)
})
