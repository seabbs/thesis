plot_case_age_dist <- ets %>% 
  filter(year %% 5 == 0,
         year > 2000) %>% 
  mutate(agegrp2 = agegrp2 %>% 
           factor(levels = c(paste(seq(0, 85, 5), 
                                   seq(4, 89, 5),
                                   sep = "-"),
                             "90+"))
  ) %>% 
  drop_na(agegrp2, ukborn, year) %>% 
  count(ukborn, agegrp2, year) %>% 
  add_count(year, ukborn, wt = n, name = "nn") %>% 
  mutate(n = n / nn) %>% 
  mutate(`UK birth status` = ukborn) %>% 
  mutate(Year = factor(year)) %>% 
  ggplot(aes(x = agegrp2, y = n, col = Year, group = Year)) +
  geom_point(size = 1.4, alpha = 0.8) + 
  geom_line(size = 1.2, alpha = 0.6) +
  scale_y_continuous(labels = percent) +
  scale_colour_viridis_d(end = 0.9) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90)) +
  theme(legend.position = "top") +
  labs(y = "Percentage of total notifications",
       x = "Age group") +
  facet_wrap(~`UK birth status`, ncol = 1)


ggsave("chapters/tb-epi-england/figures/plot-case-age-dist.png", 
       plot_case_age_dist, dpi = 320, width = 8, height = 8)