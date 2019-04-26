
# basic-completeness reporting --------------------------------------------

complete_sym_year <- ets %>%
  group_by(Year = year) %>% 
  summarise(Complete = pretty_percentage(sum(!is.na(symptonset)),
                                         length(symptonset), digits = 1))

saveRDS(complete_sym_year, file = "chapters/tb-epi-england/data/complete_sym_year.rds")

complete_diag_year <- ets %>%
  group_by(Year = year) %>% 
  summarise(Complete = pretty_percentage(sum(!is.na(datediag)),
                                         length(datediag), digits = 1))


saveRDS(complete_diag_year, file = "chapters/tb-epi-england/data/complete_diag_year.rds")

complete_treatstart_year <- ets %>%
  group_by(Year = year) %>% 
  filter(startedtreat == "Started" | is.na(startedtreat)) %>% 
  summarise(Complete = pretty_percentage(sum(!is.na(starttreatdate)),
                                         length(starttreatdate), digits = 1))


saveRDS(complete_treatstart_year, file = "chapters/tb-epi-england/data/complete_treatstart_year.rds")

complete_treatend_year <- ets %>%
  group_by(Year = year) %>% 
  filter(overalloutcome %in% c("Treatment completed", "Not Evaluated")) %>% 
  summarise(Complete = pretty_percentage(sum(!is.na(txenddate)),
                                         length(txenddate), digits = 1))


saveRDS(complete_treatend_year, file = "chapters/tb-epi-england/data/complete_treatend_year.rds")

complete_dateofdeath_year <- ets %>%
  group_by(Year = year) %>% 
  filter(overalloutcome %in% c("Died", "Not Evaluated")) %>% 
  summarise(Complete = pretty_percentage(sum(!is.na(dateofdeath)),
                                         length(dateofdeath), digits = 1))


saveRDS(complete_dateofdeath_year, file = "chapters/tb-epi-england/data/complete_dateofdeath_year.rds")


symptonset_complete <- complete_per(ets$symptonset)

saveRDS(symptonset_complete, file = "chapters/tb-epi-england/data/symptonset_complete.rds")

datediag_complete <- complete_per(ets$datediag)

saveRDS(datediag_complete, file = "chapters/tb-epi-england/data/datediag_complete.rds")

# Plot-detection-metric ---------------------------------------------------

plot_detection_metric <- function(df, metric) {

  ## See incidence functions
  df_expanded <- count_ext(metric, df) %>% 
    mutate(notifications = n) %>% 
    select(-n) %>% 
    filter(date > "1999-12-31")
  
  ## Plot overall incidence by year
  overall_plot <- df_expanded %>% 
    count(year(date), wt = notifications) %>% 
    ggplot(aes(x= `year(date)`, y = n)) +
    geom_smooth(method = 'loess', alpha = 0.4, color = "grey") +
    geom_point(size = 1.2, alpha = 0.6) +
    scale_y_continuous(labels = comma) +
    theme_minimal() +
    labs(title = "a.)",
         x = "Year",
         y = "Notifications")
  
  ## plot incidence by month
  month_plot <- df_expanded %>% 
    count(floor_date(date, "month"), wt = notifications) %>% 
    ggplot(aes(x= `floor_date(date, "month")`, y = n)) +
    geom_smooth(method = 'loess', alpha = 0.4, color = "grey") +
    geom_point(size = 1.2, alpha = 0.6) +
    scale_y_continuous(labels = comma) +
    theme_minimal() +
    labs(title = "b.)",
         x = "Year",
         y = "Notifications")
  
  
  ## plot normalised incidence by month
  sum_month_plot <- df_expanded %>% 
    count(floor_date(date, "month"), wt = notifications) %>% 
    add_count(year(`floor_date(date, "month")`), wt = n) %>% 
    mutate(n = n / nn) %>% 
    mutate(month = month(`floor_date(date, "month")`, label = TRUE)) %>% 
    ggplot(aes(x= month, y = n)) +
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) +
    geom_jitter(alpha = 0.4) + 
    scale_y_continuous(labels = percent) +
    theme_minimal() +
    labs(title = "c.)",
         x = "Month",
         y = "Proportion of that years notifications")
  
  ## Plot normalised incidencce by day
  sum_day_plot <- df_expanded %>% 
    count(floor_date(date, "day"), wt = notifications) %>% 
    add_count(floor_date(`floor_date(date, "day")`, "month"), wt = n) %>% 
    mutate(n = n / nn) %>% 
    mutate(mday = mday(`floor_date(date, "day")`)) %>% 
    ggplot(aes(x= mday, y = n, group = mday)) +
    geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) +
    geom_jitter(alpha = 0.05) + 
    scale_y_continuous(labels = percent) +
    theme_minimal() +
    labs(title = "d.)",
         x = "Day of the month",
         y = "Proportion of that months notifications")
  
  grid_plot <- grid.arrange(overall_plot, month_plot, sum_month_plot, sum_day_plot, nrow = 2)
  
  return(grid_plot)
}


# produce-plots -----------------------------------------------------------


plot_not_detection <- plot_detection_metric(ets, "caserepdate")

ggsave("chapters/tb-epi-england/figures/plot-detection-not.png", 
       plot_not_detection, dpi = 320, width = 8, height = 8)

plot_sym_detection <- plot_detection_metric(ets, "symptonset")

ggsave("chapters/tb-epi-england/figures/plot-detection-sympton.png", 
       plot_sym_detection, dpi = 320, width = 8, height = 8)

plot_starttreatdate_detection <- ets %>% 
  filter(year(starttreatdate) < 2015,
         year(starttreatdate) > 2000 ) %>% 
  plot_detection_metric("starttreatdate")

ggsave("chapters/tb-epi-england/figures/plot-detection-starttreatdate.png", 
       plot_starttreatdate_detection, dpi = 320, width = 8, height = 8)

plot_treatend_detection <- ets %>% 
  filter(year(txenddate) < 2015,
         year(txenddate) > 2000) %>% 
  filter(overalloutcome == "Treatment completed") %>% 
  plot_detection_metric("txenddate")

ggsave("chapters/tb-epi-england/figures/plot-detection-treatend.png", 
       plot_treatend_detection, dpi = 320, width = 8, height = 8)


plot_dateofdeath_detection <- ets %>% 
  filter(year(dateofdeath) < 2015,
         year(dateofdeath) > 2000) %>% 
  filter(overalloutcome == "Died") %>% 
  plot_detection_metric("dateofdeath")

ggsave("chapters/tb-epi-england/figures/plot-detection-dateofdeath.png", 
       plot_dateofdeath_detection, dpi = 320, width = 8, height = 8)