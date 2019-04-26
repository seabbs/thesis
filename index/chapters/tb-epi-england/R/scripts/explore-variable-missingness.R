
# Function to model missing data ------------------------------------------

model_var_missing <- function(df, var, confounders, confounder_names) {
  
 df <- df %>% 
   select_at(.vars = c(var, confounders)) %>% 
   mutate_at(.vars = var, funs(case_when(is.na(.) ~ "Missing",
                                         TRUE ~ "Complete") %>% 
                                 factor(levels = c("Complete", "Missing")))) %>% 
   drop_na()
 
 model <- glm(as.formula(paste0(var, " ~ .")), data = df, family = binomial(link="logit"))
 
 ## Tidy model output table
 table <- model %>% 
   tidy(conf.int = TRUE) %>% 
   mutate_at(.vars = c("estimate", "conf.low", "conf.high"),
             exp) %>% 
   slice(-1) %>% 
   mutate(`Odds Ratio` = pretty_ci(estimate, conf.low, conf.high, sep = ", "),
          `P value (Wald)` = signif(p.value, 3)) %>% 
   select(-estimate, -std.error, -statistic, -p.value, -conf.low, -conf.high)
            
    
 ## Get clean variable names and demographic data     
  data <- map2_dfr(confounders, confounder_names, ~ group_by(df, .dots = c(.x, var)) %>% 
                    count %>% 
                    group_by(.dots = .x) %>% 
                    add_count(wt = n) %>% 
                    filter_at(.vars = var, all_vars(. == "Missing")) %>% 
                    select(-contains(var)) %>% 
                    drop_na %>% 
                    ungroup %>% 
                    rename_if(is.factor, funs(paste0("Category"))) %>% 
                    mutate_if(is.factor, as.character) %>% 
                    mutate(Variable = .y) %>% 
                    mutate(key = paste0(.x, Category)) %>% 
                    mutate(Missing = pretty_round(n / nn * 100, 1)) %>% 
                    mutate(Missing = paste0(Missing, "% (", n, ")")) %>% 
                    select(Variable, Category, `Missing (N)` = Missing, 
                           Notifications = nn, key))
  
  lik_tests <- tibble(Variable = confounder_names,
                      `P value (LRT)` = map_dbl(confounders, ~anova(
                        model,
                        update(model, paste0(". ~ . - ", .)),
                        test = "LRT")$`Pr(>Chi)`[2]
                        ) %>% 
                        signif(3))
  
  ## Combine model, data and likelihood into a table
  output <- data %>% 
    left_join(table, by = c("key" = "term")) %>% 
    select(-key) %>% 
    mutate(`Odds Ratio` = `Odds Ratio` %>% replace_na("")) %>% 
    mutate(dummy = Variable) %>% 
    group_by(dummy) %>% 
    mutate(Variable = c(Variable[1], rep("", n() - 1))) %>% 
    ungroup %>% 
    select(-dummy) %>% 
    left_join(lik_tests, by = "Variable") %>% 
    mutate(`P value (LRT)` = `P value (LRT)` %>% 
             replace_na("")) %>% 
    mutate(`P value (Wald)` = `P value (Wald)` %>% 
             replace_na(""))
  
  colnames(output) <- colnames(output) %>% 
    str_replace("Notifications", paste0("Notifications (", nrow(df), ")"))
  
  return(output)
} 


confounders_var <- c("year", "sex", "agegrp", "ethgrp", "ukborn", "natquintile")
confounder_names <- c("Year", "Sex", "Age", "Ethnic group", "UK birth status", "Socio-economic status")

# BCG vac -----------------------------------------------------------------

bcg_missingness <- ets %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  model_var_missing(var = "bcgvacc", confounders_var, confounder_names)



# year of BCG -------------------------------------------------------------

bcg_year_missingness <- ets %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  filter(bcgvacc == "Yes") %>% 
  model_var_missing(var = "bcgvaccyr", confounders_var, confounder_names)


# date of death -----------------------------------------------------------
death_date_missingness <- ets %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  filter(overalloutcome == "Died") %>% 
  model_var_missing(var = "dateofdeath", confounders_var, confounder_names)

# cause of death ----------------------------------------------------------
death_cause_missingness <- ets %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  filter(overalloutcome == "Died") %>% 
  model_var_missing(var = "tomdeathrelat", confounders_var, confounder_names)


# date symptom onset ------------------------------------------------------

date_symptoms_missingness <- ets %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  model_var_missing(var = "symptonset", confounders_var, confounder_names)


# date of diag ------------------------------------------------------------

date_diag_missingness <- ets %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  model_var_missing(var = "datediag", confounders_var, confounder_names)


# date of starting treatment ----------------------------------------------
date_treat_start_missingness <- ets %>% 
  filter(startedtreat == "Started") %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  model_var_missing(var = "starttreatdate", confounders_var, confounder_names)



# date of ending treatment ------------------------------------------------
date_treat_end_missingness <- ets %>% 
  filter(overalloutcome %in% c("Treatment completed")) %>% 
  filter(year > 2009) %>% 
  mutate(year = factor(year)) %>% 
  model_var_missing(var = "txenddate", confounders_var, confounder_names)



model_miss_results <- list(bcg_missingness, bcg_year_missingness,
                        death_cause_missingness, date_symptoms_missingness,
                        date_diag_missingness, death_date_missingness, 
                        date_treat_start_missingness, date_treat_end_missingness)

names(model_miss_results) <- c("bcgvacc", "bvcvaccyr", "tomdeathrealat",
                               "symptonset", "datediag", "dateofdeath", 
                               "starttreatdate", "txenddate")

saveRDS(model_miss_results, file = "chapters/tb-epi-england/data/model_miss_results.rds")