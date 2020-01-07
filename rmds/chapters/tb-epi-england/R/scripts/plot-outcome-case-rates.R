
# Make generic case count plot fn -----------------------------------------

plot_case_rate = function(df, RateVar) {
  
  # Graph 1 - Outcome, UK birth status and BCG vaccination ------------------  
  ## By Birth status and vaccination status
  
  ## raw case numbers
  p1 <- df %>% 
    filter_at(.vars = RateVar, all_vars(. %in% 'Yes')) %>%
    filter(!is.na(ukborn)) %>%
    mutate(`BCG vaccination` = bcgvacc, Year = year) %>% 
    count(ukborn, `BCG vaccination`, Year) %>% 
    mutate(Cases = n) %>% 
    mutate(`BCG vaccination` = `BCG vaccination` %>% 
             forcats::fct_explicit_na(na_level = "Missing") %>% 
             forcats::fct_rev()) %>% 
    mutate(ukborn = ukborn %>% 
             fct_rev) %>% 
    ggplot(aes(x = Year, y = Cases, colour = `BCG vaccination`, group = `BCG vaccination`, fill = `BCG vaccination`)) +
    geom_col(alpha = 0.8) + 
    scale_x_continuous(breaks = seq(2001, 2015, 1), minor_breaks = NULL) +
    scale_fill_viridis_d(end = 0.9) +
    scale_colour_viridis_d(end = 0.9) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.position = "top") +
    facet_wrap(~ ukborn) +
    guides(colour = guide_legend(title = "BCG vaccination"), 
           fill = guide_legend(title = "BCG vaccination"))
  
  ## case rate - dropped BCG vaccination rates prior to 2008 due to uncertainty in the estimates as data was not nationally collected
  p2 <- df %>% 
    case_rate(rate_for = RateVar, strat_by = 'bcgvacc') %>% 
    filter_at(.vars = RateVar, all_vars(. %in% 'Yes')) %>%
    filter(!is.na(CoB), !(Year < 2009 && !is.na(bcgvacc))) %>% 
    mutate(`BCG vaccination` = bcgvacc %>% 
             forcats::fct_explicit_na(na_level = "Missing")) %>% 
    mutate(CoB = CoB %>% 
             forcats::fct_rev()) %>% 
    mutate_at(.vars= vars(`Case rate`, LowRate, HiRate), ~ . / 100) %>% 
    ggplot(aes(x = Year, y = `Case rate`, group = `BCG vaccination`, colour = `BCG vaccination`, fill = `BCG vaccination`)) + 
    geom_point(size = 1.4, alpha = 0.8) + 
    geom_linerange(aes(min = LowRate, max = HiRate), alpha = 0.8) + 
    geom_line(size = 1.2, alpha = 0.4) +
    scale_x_continuous(breaks = seq(2000, 2015, 1), minor_breaks = NULL) +
    scale_y_continuous(labels = percent) +
    scale_colour_viridis_d(end = 0.9) +
    scale_fill_viridis_d(end = 0.9) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.position = "none") +
    facet_wrap(~ CoB) +
    labs(y = "Case rate")
  
  
  plot <- grid.arrange(p1 + ggtitle('a.)'), p2 + ggtitle('b.)'), ncol = 1, heights = c(0.55, 0.45))
  
  return(plot)
}


# make-age-dist-plot ------------------------------------------------------

plot_age_year_case_rate <- function(df, RateVar, year_strat = NULL, min_y = 0,  max_y = 0.6) {
  
  if (!is.null(year_strat)) { 
    df <- df %>% 
      filter(year == year_strat)
  }
  
  p3 <- df %>% 
    case_rate(rate_for = RateVar, strat_by = 'bcgvacc', 
              Year_strat = FALSE, age_split = '`Age group`') %>% 
    filter_at(.vars = RateVar, all_vars(. %in% 'Yes')) %>%
    filter(!is.na(CoB), !(`Age group` %in% '90+'), !is.na(`Age group`)) %>% 
    mutate(`BCG vaccination` = bcgvacc %>% 
             forcats::fct_explicit_na(na_level = "Missing")) %>% 
    mutate(CoB = CoB %>% 
             forcats::fct_rev()) %>% 
    mutate_at(.vars= vars(`Case rate`, LowRate, HiRate), ~ . / 100) %>% 
    ggplot(aes(x = `Age group`, y = `Case rate`, group = `BCG vaccination`, colour = `BCG vaccination`, fill = `BCG vaccination`)) + 
    geom_point(size = 1.4,alpha = 0.8) + 
    geom_linerange(aes(min = LowRate, max = HiRate), alpha = 0.8) + 
    geom_line(size = 1.2, alpha = 0.4) +
    scale_y_sqrt(breaks = c(0, 0.001, 0.005, 0.02, 0.05, seq(0.1, max_y, 0.1)),
                 limits = c(min_y, max_y),
                 minor_breaks = NULL,
                 labels = percent) + 
    scale_colour_viridis_d(end = 0.9) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.position = "top") +
    facet_wrap(~ CoB) +
    labs(y = "Case rate (square root scale)", 
         x = "Age group") +
    guides(fill = guide_legend(title = "BCG vaccination"),
           colour = guide_legend(title = "BCG vaccination"))

return(p3)
}

# Make mortality plot -----------------------------------------------------

plot_all_mort_case_rate <- plot_case_rate(ets, "mortality")

ggsave("chapters/tb-epi-england/figures/plot-all-mort-case-rate.png", 
       plot_all_mort_case_rate, dpi = 320, width = 8, height = 8)

plot_all_mort_age_dist <- plot_age_year_case_rate(ets, "mortality", max_y = 0.6)

ggsave("chapters/tb-epi-england/figures/plot-all-mort-age-dist.png", 
       plot_all_mort_age_dist, dpi = 320, width = 8, height = 8)


# Make TB mortality plots -------------------------------------------------


plot_tb_mort_case_rate <- plot_case_rate(ets, "TBMortality")

ggsave("chapters/tb-epi-england/figures/plot-tb-mort-case-rate.png", 
       plot_tb_mort_case_rate, dpi = 320, width = 8, height = 8)

plot_tb_mort_age_dist <- plot_age_year_case_rate(ets, "TBMortality", max_y = 0.3)

ggsave("chapters/tb-epi-england/figures/plot-tb-mort-age-dist.png", 
       plot_tb_mort_age_dist, dpi = 320, width = 8, height = 8)


# Make success treat 12 plot ----------------------------------------------

plot_succ_treat_case_rate <- plot_case_rate(ets, "SuccTreat12")

ggsave("chapters/tb-epi-england/figures/plot-succ-treat-case-rate.png", 
       plot_succ_treat_case_rate, dpi = 320, width = 8, height = 8)

plot_succ_treat_age_dist <- plot_age_year_case_rate(ets, "SuccTreat12", min_y = 0.4,  max_y = 1.0)

ggsave("chapters/tb-epi-england/figures/plot-suc-treat-age-dist.png", 
       plot_succ_treat_age_dist, dpi = 320, width = 8, height = 8)




# Loss to follow up -------------------------------------------------------

ets_with_loss <- ets %>% 
  drop_na(overalloutcome) %>% 
  filter(!(overalloutcome %in% "Not Evaluated")) %>% 
  mutate(LossFollow = case_when(overalloutcome %in% "Lost to follow up" ~ "Yes",
                                TRUE ~ "No")) 

plot_loss_fol_case_rate <- plot_case_rate(ets_with_loss, "LossFollow")

ggsave("chapters/tb-epi-england/figures/plot-loss-fol-case-rate.png", 
       plot_loss_fol_case_rate, dpi = 320, width = 8, height = 8)

plot_loss_fol_age_dist <- plot_age_year_case_rate(ets_with_loss, "LossFollow",
                                                    max_y = 0.4)

ggsave("chapters/tb-epi-england/figures/plot-loss-fol-age-dist.png", 
       plot_loss_fol_age_dist, dpi = 320, width = 8, height = 8)




