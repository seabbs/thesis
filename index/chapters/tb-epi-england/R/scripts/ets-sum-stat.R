
# Plot overall notifications ----------------------------------------------

plot_overall_nots <- ets %>% 
  mutate(`UK birth status` = ukborn %>% 
           forcats::fct_explicit_na()) %>% 
  count(`UK birth status`, year) %>% 
  ggplot(aes(x = year, y = n, col = `UK birth status`)) +
  geom_line() +
  geom_label(aes(label = n)) +
  theme_minimal() +
  guides(label = FALSE) +
  labs(y = "Notifications") +
  scale_colour_viridis_d(end = 0.8) +
  theme(legend.position = "top")

ggsave("chapters/tb-epi-england/figures/plot-overall-nots.png", 
       plot_overall_nots, dpi = 320, width = 8, height = 8)



# Total notifications -----------------------------------------------------

var_count <- function(df, variable) {
  variable <- enquo(variable)
  
  df %>% 
    mutate(!!variable := !!variable %>% 
             forcats::fct_explicit_na()) %>% 
    count(!!variable) %>% 
    add_count(wt = n, name = "nn") %>% 
    mutate(per = pretty_percentage(n, nn, 1))
  
}

uk_born_count <- ets %>% 
  var_count(ukborn)


bcg_count <- ets %>%
  filter(year > 2008) %>% 
  var_count(bcgvacc)

scio_count <- ets %>% 
  filter(year > 2009) %>% 
  var_count(natquintile)

phec_count <- ets %>% 
  var_count(phec)

age_count <- ets %>% 
  var_count(agegrp)

ets_sum_counts <- list(uk_born_count, bcg_count, scio_count, phec_count, age_count)
names(ets_sum_counts) <- c("ukborn", "bcgvacc", "natquintile", "phec", "age")


saveRDS(ets_sum_counts, file = "chapters/tb-epi-england/data/ets_sum_counts.rds")
