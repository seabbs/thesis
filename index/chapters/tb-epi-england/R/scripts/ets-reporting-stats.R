## Prep stats for reporting
total_nots <- ets_sum_counts[["ukborn"]] %>% 
  slice(1) %>% 
  pull(nn) %>% 
  format(big.mark=",",scientific=FALSE)

# Total nots --------------------------------------------------------------


# UK born stats -----------------------------------------------------------


ukborn_nots <-  ets_sum_counts[["ukborn"]] %>% 
  filter(ukborn == "Non-UK Born") %>% 
  pull(per)


# BCG vac stats -----------------------------------------------------------


bcgvacc_nots <- ets_sum_counts[["bcgvacc"]] %>% 
  filter(bcgvacc == "Yes") %>% 
  pull(per)

bcgvacc_miss <- ets_sum_counts[["bcgvacc"]] %>% 
  filter(bcgvacc == "(Missing)") %>% 
  pull(per)

bcgvacc_known <- ets_sum_counts[["bcgvacc"]] %>% 
  filter(!bcgvacc == "(Missing)") %>% 
  add_count(wt = n) %>% 
  mutate(per = pretty_percentage(n, nn, 1)) %>% 
  filter(bcgvacc == "Yes") %>% 
  pull(per)


# age stats ---------------------------------------------------------------

age_nots_extract <- function(df, age) {
  df %>% 
  {.[["age"]]} %>% 
    filter(agegrp == age) %>% 
    pull(per)
}

young_adult_nots <- ets_sum_counts %>% 
  age_nots_extract("15-44")

children_nots <- ets_sum_counts %>% 
  age_nots_extract("0-14")

old_nots <- ets_sum_counts %>% 
  age_nots_extract("65+")


# phec-stats --------------------------------------------------------------

phec_nots_extract <- function(df, sel_phec) {
  df %>% 
  {.[["phec"]]} %>% 
    filter(phec == sel_phec) %>% 
    pull(per)
}

london_nots <- ets_sum_counts %>% 
  phec_nots_extract("London")

west_mid_nots <- ets_sum_counts %>% 
  phec_nots_extract("West Midlands")


# socio stats -------------------------------------------------------------

socio_nots <- ets_sum_counts[["natquintile"]] %>% 
  filter(natquintile == "1") %>% 
  pull(per)

