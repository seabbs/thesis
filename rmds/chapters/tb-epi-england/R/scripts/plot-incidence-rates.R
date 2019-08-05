
# Plot inc rates fn -------------------------------------------------------

plot_inc_rates <- function(df) {
  plot <-  df %>% 
  ggplot(aes(x = Year, y = Incidence, colour = CoB)) +
    geom_linerange(aes(ymin = Inc_LCI, ymax = Inc_UCI)) +
    geom_point(size = 1.4) +
    geom_line(aes(group = CoB), size = 1.2, alpha = 0.6) +
    labs(y = "Incidence rate (per 100,000 people)") +
    theme_minimal() +
    scale_x_continuous(breaks = c(2000:2015), minor_breaks = NULL) +
    scale_colour_viridis_d(end = 0.9) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.position = "top") +
    facet_grid(CoB ~`Age group (condensed)`, scale = 'free_y') +
    guides(col=guide_legend(title="UK birth status"))
  
  return(plot)
}

# Plot - total incidence rates --------------------------------------------

plot_overall_inc_rates <- condensed_age_group_incidence %>% 
  filter(`Age group (condensed)` %in% c("All cases (adj)")) %>% 
  filter(!is.na(CoB), Year < 2016, !(CoB %in% c('Total (LFS)'))) %>%
  plot_inc_rates

ggsave("chapters/tb-epi-england/figures/plot-overall-inc-rates.png", 
       plot_overall_inc_rates, dpi = 320, width = 8, height = 8)


# plot age strat inc rates ------------------------------------------------

plot_age_inc_rates <- condensed_age_group_incidence %>% 
  filter(!(`Age group (condensed)` %in% c("All cases (crude)", "All cases (adj)"))) %>% 
  filter(!is.na(CoB), Year < 2016, !(CoB %in% c('Total (LFS)'))) %>%
  plot_inc_rates


ggsave("chapters/tb-epi-england/figures/plot-age-inc-rates.png", 
       plot_age_inc_rates, dpi = 320, width = 8, height = 8)


# plot age diet of inc rates ----------------------------------------------

plot_age_dist_inc_rates <- age_grouped_incidence %>% 
  filter(as.numeric(Year) %% 5 == 0) %>% 
  filter(!(`Age group` %in% c('All cases (crude)', 'All cases (adj)'))) %>% 
  mutate(Year = Year %>% ordered) %>% 
  filter(!is.na(CoB), as.numeric(Year) < 16, !(CoB %in% c('Total (LFS)'))) %>% 
  mutate(CoB = CoB %>% as.character %>% factor(levels = c('Total', 'UK born', 'Non-UK born'))) %>%
  ggplot(aes(x = `Age group`, y = Incidence, colour = CoB)) +
  geom_linerange(aes(ymin = Inc_LCI, ymax = Inc_UCI)) +
  geom_point(size = 1.4) +
  geom_line(aes(group = CoB), size = 1.2, alpha = 0.6) +
  labs(y = "Incidence rate (per 100,000 people)",
       x = "Age group") +
  scale_colour_viridis_d(end = 0.9) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90),
        legend.position = "top") +
  facet_grid(CoB ~ Year, scales = 'free_y') +
  guides(col=guide_legend(title = "UK birth status"))

ggsave("chapters/tb-epi-england/figures/plot-age-dist-inc-rates.png", 
       plot_age_dist_inc_rates, dpi = 320, width = 8, height = 8)


# plot inc rates in children ----------------------------------------------


plot_zoomed_inc_rates_children_ukborn <- incidence %>% 
  filter(Age %in% c('All cases (crude)', seq(0,7,1) %>% as.character)) %>% 
  filter(!is.na(CoB), Year < 2016, CoB %in% c('UK born')) %>%
  group_by(Age)  %>% 
  ggplot(aes(x = Year, y = Incidence, colour = Age, group = Age)) +
  geom_linerange(aes(ymin = Inc_LCI, ymax = Inc_UCI)) +
  geom_point(size = 1.4) + 
  geom_line(size = 1.2, alpha = 0.6) +
  theme_minimal() +
  scale_colour_viridis_d(end = 0.9) +
  theme(axis.text.x = element_text(angle = 90), 
        legend.position = "none") +
  labs(y = "Incidence rate (per 100,000 people)") +
  facet_wrap(~ Age, scales = "free_y")

ggsave("chapters/tb-epi-england/figures/plot-zoomed-inc-rates-children-ukborn.png", 
       plot_zoomed_inc_rates_children_ukborn,
       dpi = 320, width = 8, height = 8)
