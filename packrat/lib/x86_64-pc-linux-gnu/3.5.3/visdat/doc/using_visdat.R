## ----setup, echo = FALSE, include = FALSE--------------------------------

knitr::opts_chunk$set(fig.width = 5,
                      fig.height = 4)


## ----head-iris-----------------------------------------------------------

head(iris)


## ----glimpse-------------------------------------------------------------

dplyr::glimpse(iris)


## ----visdat-glimpse------------------------------------------------------
library(visdat)
dplyr::glimpse(typical_data)


## ----load-data-----------------------------------------------------------

vis_dat(typical_data)


## ----example-vis-miss----------------------------------------------------

vis_miss(typical_data)


## ----vis_dat-------------------------------------------------------------

library(visdat)

vis_dat(airquality)


## ----visdat-typical------------------------------------------------------

vis_dat(typical_data)

vis_dat(typical_data, 
        sort_type = FALSE)


## ----vis_miss------------------------------------------------------------

vis_miss(airquality)


## ----vismiss-new-data----------------------------------------------------

df_test <- data.frame(x1 = 1:10000,
                      x2 = rep("A", 10000),
                      x3 = c(rep(1L, 9999), NA))

vis_miss(df_test)


## ----vismiss-mtcars------------------------------------------------------

df_test <- data.frame(x1 = 1:10000,
                      x2 = rep("tidy", 10000),
                      x3 = rep("data", 10000))

vis_miss(df_test)


## ----vismiss-------------------------------------------------------------

vis_miss(airquality,
         sort_miss = TRUE)


## ----vis_miss-cluster----------------------------------------------------

vis_miss(airquality, 
         cluster = TRUE)


## ----plotly-example------------------------------------------------------

library(plotly)

vis_dat(airquality) %>% ggplotly()
vis_miss(airquality) %>% ggplotly()


