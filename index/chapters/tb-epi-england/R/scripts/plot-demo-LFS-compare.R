
# age dist population demographics ----------------------------------------

age_dist_pop <- demographics %>% 
  filter(!is.na(CoB),
         Year %% 5 == 0,
         Year > 2000) %>%
  mutate(Year = Year %>% as.factor) %>% 
  group_by(CoB, `Age group`, Year) %>% 
  summarise(Population = sum(Population)) %>%
  ungroup %>% 
  add_count(CoB, Year, wt = Population) %>% 
  mutate(n = Population / n) %>% 
  filter(CoB %in% c('UK born', 'Non-UK born')) %>% 
  ggplot(aes(x = `Age group`, y = n, col = Year, group = Year)) +
  geom_point(size = 1.4, alpha = 0.8) +
  geom_line(size = 1.2, alpha = 0.6) +
  facet_wrap(~CoB, ncol = 1) + 
  scale_color_viridis_d(end = 0.9) +
  scale_y_continuous(labels = percent) +
  theme_minimal() +
  labs(y = "Proportion of the population") +
  theme(axis.text.x = element_text(angle = 90)) +
  theme(plot.title = element_text(hjust = 0),
        legend.position = "top")

ggsave("chapters/tb-epi-england/figures/age-dist-pop.png", 
       age_dist_pop, dpi = 320, width = 8, height = 8)

# Look at total population over time --------------------------------------
overall_pop <- demographics %>% 
  group_by(CoB, Year) %>% 
  drop_na(CoB) %>% 
  summarise(Population = sum(Population)) %>% 
  ggplot(aes(x = Year, y = Population, fill = CoB, colour = CoB)) +
  geom_point(size = 1.4) +
  geom_line(size = 1.1, alpha = 0.8) +
  scale_y_continuous(labels = comma) +
  scale_colour_viridis_d() +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0), legend.position = 'top')

ggsave("chapters/tb-epi-england/figures/plot-overall-pop.png", 
       overall_pop, dpi = 320, width = 8, height = 8)

## Look at bi yearly differences between LFS and ONS
age_strat <- demographics %>%
  group_by(`Age group`, CoB, Year) %>% 
  summarise(Population = sum(Population)) %>% 
  spread(key = "CoB", value = "Population") %>% 
  mutate(diff = (`Total` - `Total (LFS)`)/ Total) %>% 
  ggplot(aes(x = Year, y = diff, col = `Age group`)) +
  geom_point() +
  geom_line() +
  scale_colour_viridis_d() +
  scale_y_continuous(labels = percent) +
  expand_limits(y = 0) +
  facet_wrap(~`Age group`, scale = "free_y") +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(y = "Percentage difference (ONS estimate - LFS estimate)")
  
ggsave("chapters/tb-epi-england/figures/plot-age-strat.png", 
       age_strat , dpi = 320, width = 8, height = 8)