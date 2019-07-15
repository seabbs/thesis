
# Select variables of interest --------------------------------------------


filt_ets <- ets %>% 
  select(caserepdate, year, sex, age, phec, 
         occat, ethgrp, ukborn, timesinceent,
         symptonset, datediag, startedtreat, starttreatdate, 
         txenddate, pulmextrapulm, culture, sputsmear, anyres,
         prevdiag, bcgvacc, bcgvaccyr, overalloutcome, tomdeathrelat, 
         dateofdeath, txenddate, natquintile)


# Account for nested data -------------------------------------------------


nest_filt_ets <- filt_ets %>%
  mutate(tomdeathrelat = ifelse(overalloutcome == 'Died', 
                                tomdeathrelat %>% as.character, 
                                overalloutcome %>% as.character) %>%
           factor) %>% 
  mutate(dateofdeath = ifelse(overalloutcome == 'Died', 
                              dateofdeath, 100000)) %>%
  mutate(starttreatdate = ifelse(startedtreat == 'Started', 
                                 starttreatdate,
                                 startedtreat)) %>% 
  mutate(txenddate = ifelse(overalloutcome == 'Treatment completed', 
                            txenddate, 
                            overalloutcome)) %>%
  mutate(bcgvaccyr = ifelse(bcgvacc == 'Yes',
                            bcgvaccyr %>% as.character,
                            bcgvacc) %>% factor)  %>% 
  mutate(dateofdeath = ifelse(overalloutcome %in% "Died", 
                              dateofdeath,
                              "N/A") %>% 
           as.factor) %>% 
  mutate(timesinceent = ifelse(ukborn %in% "UK born", "N/A", timesinceent))


# Plot nested missing data ------------------------------------------------

missing_stru <- nest_filt_ets %>% 
  sample_frac(0.2) %>% 
  arrange(desc(caserepdate)) %>% 
  vis_miss(warn_large_data = FALSE, sort_miss = TRUE,
           show_perc = TRUE, cluster = FALSE) +
  coord_flip() +
  theme(legend.position = "bottom") +
  theme(axis.text.x = element_text(angle = 0, hjust = 1),
        text = element_text(size = 18))

ggsave("chapters/tb-epi-england/figures/plot-missing-struct.png", 
       missing_stru, dpi = 320, width = 8, height = 12)

# Estimate missing ness pre and post 2009 ---------------------------------

make_nested_missing_tab <- function(df) {
  df %>%
    miss_var_summary %>%
    mutate(percent = pretty_round(pct_miss, digits = 1)) %>% 
    select(Variable = variable, `Missing (N)` = n_miss, `Missing (%)` = percent)
  
}

miss_ets_pre_2009 <- nest_filt_ets %>% 
  filter(year < 2009) %>% 
  make_nested_missing_tab

miss_ets_post_2008 <- nest_filt_ets %>% 
  filter(year > 2008) %>% 
  make_nested_missing_tab()

saveRDS(miss_ets_pre_2009, file = "chapters/tb-epi-england/data/miss_ets_pre_2009.rds")
saveRDS(miss_ets_post_2008, file = "chapters/tb-epi-england/data/miss_ets_post_2008.rds")



# Summary stats -----------------------------------------------------------

## For nested variables an alternative measure of missing data is to consider the number of missing data 
## points when top level outcome is known

## Started treatment date
date_treatment <- ets %>% 
  filter(startedtreat %in% "Started") %>% 
  count(starttreatdate) %>% 
  add_count(wt = n, name = "nn") %>% 
  filter(is.na(starttreatdate)) %>% 
  mutate(per = pretty_percentage(n, nn, 1)) %>% 
  pull(per)

## Ended treatment
date_treatment_end <- ets %>% 
  filter(startedtreat %in% "Started") %>% 
  filter(overalloutcome %in% "Treatment completed") %>% 
  count(txenddate) %>% 
  add_count(wt = n, name = "nn") %>% 
  filter(is.na(txenddate)) %>% 
  mutate(per = pretty_percentage(n, nn, 1)) %>% 
  pull(per)

## Date of death
date_death_missing <- ets %>% 
  filter(overalloutcome == "Died") %>% 
  summarise(missing = sum(is.na(dateofdeath)), n = n()) %>% 
  mutate(per = pretty_percentage(missing, n, 1)) %>% 
  pull(per)

## Cause of death proportion missing
tomdeathrelat_missing <- ets %>% 
  filter(overalloutcome == "Died") %>% 
  count(tomdeathrelat) %>% 
  add_count(wt = n, name = "nn") %>% 
  mutate(pretty_per = pretty_percentage(n, nn, 1)) %>% 
  filter(is.na(tomdeathrelat)) %>% 
  pull(pretty_per)

missing_stats <- c(date_treatment, date_death_missing, tomdeathrelat_missing, 
                   date_treatment_end)
names(missing_stats) <- c("date_treat", "date_death", "cause_death", "date_treat_end")


saveRDS(missing_stats, file = "chapters/tb-epi-england/data/missing_stats.rds")
