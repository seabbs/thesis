## ----knitr-setup, include = FALSE----------------------------------------
knitr::opts_chunk$set(fig.align = "center",
                      fig.width = 5,
                      fig.height = 4,
                      dpi = 100)


## ----vis-miss------------------------------------------------------------
library(naniar)

vis_miss(airquality)

## ----upset-plot----------------------------------------------------------

library(UpSetR)

airquality %>%
  as_shadow_upset() %>%
  upset()


## ----upset-plot-riskfactors----------------------------------------------

riskfactors %>%
  as_shadow_upset() %>%
  upset()

# explore as many sets as there are variables with missing data in risk factors
# (24)
n_var_miss(riskfactors)

riskfactors %>%
  as_shadow_upset() %>%
  upset(nsets = 24)


## ----ggplot-geom-miss-point----------------------------------------------
library(ggplot2)
# using regular geom_point()
ggplot(airquality,
       aes(x = Ozone,
           y = Solar.R)) +
geom_point()

library(naniar)

# using  geom_miss_point()
ggplot(airquality,
       aes(x = Ozone,
           y = Solar.R)) +
 geom_miss_point()

# Facets!
ggplot(airquality,
       aes(x = Ozone,
           y = Solar.R)) +
 geom_miss_point() + 
 facet_wrap(~Month)

# Themes
ggplot(airquality,
       aes(x = Ozone,
           y = Solar.R)) +
 geom_miss_point() + 
 theme_dark()



## ----gg-miss-var---------------------------------------------------------

gg_miss_var(airquality)
library(ggplot2)
gg_miss_var(airquality) + labs(y = "Look at all the missing ones")


## ----gg-miss-var-show-pct------------------------------------------------
gg_miss_var(airquality, show_pct = TRUE)

## ----gg-miss-var-group---------------------------------------------------

gg_miss_var(airquality,
            facet = Month)


## ----gg-miss-case--------------------------------------------------------
gg_miss_case(airquality)
gg_miss_case(airquality) + labs(x = "Number of Cases")

## ----gg-miss-case-order-by-case------------------------------------------

gg_miss_case(airquality, order_cases = TRUE)


## ----gg-miss-case-group--------------------------------------------------

gg_miss_case(airquality, facet = Month)


## ----gg-miss-fct---------------------------------------------------------

gg_miss_fct(x = riskfactors, fct = marital)
library(ggplot2)
gg_miss_fct(x = riskfactors, fct = marital) + labs(title = "NA in Risk Factors and Marital status")

# using group_by
library(dplyr)
riskfactors %>%
  group_by(marital) %>%
  miss_var_summary()


## ----gg-miss-span--------------------------------------------------------

# data method

miss_var_span(pedestrian, hourly_counts, span_every = 3000)

gg_miss_span(pedestrian, hourly_counts, span_every = 3000)
# works with the rest of ggplot
gg_miss_span(pedestrian, hourly_counts, span_every = 3000) + labs(x = "custom")
gg_miss_span(pedestrian, hourly_counts, span_every = 3000) + theme_dark()


## ----gg-miss-span-group--------------------------------------------------

gg_miss_span(pedestrian, 
             hourly_counts, 
             span_every = 3000, 
             facet = sensor_name)


## ----gg-miss-case-cumsum-------------------------------------------------
gg_miss_case_cumsum(airquality)
library(ggplot2)
gg_miss_case_cumsum(riskfactors, breaks = 50) + theme_bw()


## ----gg-miss-var-cumsum--------------------------------------------------
gg_miss_var_cumsum(airquality)

## ----gg-miss-which-------------------------------------------------------
gg_miss_which(airquality)

