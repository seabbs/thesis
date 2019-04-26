
# Generate clean sum inc --------------------------------------------------


## Summary script to generate stats for incidence across various stratificatons
if (regen_results) {
  inc_rate_con_age <- condensed_age_group_incidence %>%  
    mutate(I = Incidence %>% pretty_round(digits = 1), 
           LI = Inc_LCI %>% pretty_round(digits = 1),
           UI = Inc_UCI %>% pretty_round(digits = 1)) %>% 
    mutate(I = paste0(I, ' per 100,000 people (95% CI ', LI, ', ', UI, ')'))
  
  saveRDS(inc_rate_con_age, "chapters/tb-epi-england/data/inc_rate_con_age.rds" )
}else{
  inc_rate_con_age <- readRDS("chapters/tb-epi-england/data/inc_rate_con_age.rds" )
}



# Function to generate inc rate stats -------------------------------------

sum_inc_rate_stats = function(df, AgeGroup, CoB_choice) {
  
  SumIncRateAllCases <- df %>% 
    filter(`Age group (condensed)` %in% AgeGroup) %>% 
    select(Year, I, CoB, Incidence)
  
  Inc2000Total <-  SumIncRateAllCases %>% 
    filter(CoB %in% CoB_choice) %>%
    filter(Year == 2000)  %>% 
    select(I) %>% 
    unlist
  
  Inc2015Total <-  SumIncRateAllCases %>% 
    filter(CoB %in% CoB_choice) %>% 
    filter(Year == 2015) %>% 
    select(I) %>% 
    unlist
  
  IncMaxTotal <-  SumIncRateAllCases %>% 
    filter(CoB %in% CoB_choice) %>% 
    slice(which.max(Incidence)) %>% 
    select(Year, I) %>% 
    unlist
  
  IncMinTotal <-  SumIncRateAllCases %>% 
    filter(CoB %in% CoB_choice) %>% 
  slice(which.min(Incidence)) %>% 
  select(Year, I) %>% 
  unlist


return(list(Inc2000Total, Inc2015Total, IncMaxTotal, IncMinTotal))
}


# Get inc rate stats ------------------------------------------------------


## Summarise for all cases

## Run summary function for all cases
IncTotalAllCases <- sum_inc_rate_stats(inc_rate_con_age, 'All cases (crude)', 'Total')

## Run summary for all cases: 65+
IncTotal0_14 <- sum_inc_rate_stats(inc_rate_con_age, '0-14', 'Total')

## Run summary for all cases: 15-64
IncTotal15_64 <- sum_inc_rate_stats(inc_rate_con_age, '15-64', 'Total')

## Run summary for all cases: 65+
IncTotal65Up <- sum_inc_rate_stats(inc_rate_con_age, '65+', 'Total')

## Summarise for uk born cases

## Run summary function for all cases
IncTotalAllCases <- sum_inc_rate_stats(inc_rate_con_age, 'All cases (crude)', 'Total')

## Run summary for all cases: 65+
IncTotal0_14 <- sum_inc_rate_stats(inc_rate_con_age, '0-14', 'Total')

## Run summary for all cases: 15-64
IncTotal15_64 <- sum_inc_rate_stats(inc_rate_con_age, '15-64', 'Total')

## Run summary for all cases: 65+
IncTotal65Up <- sum_inc_rate_stats(inc_rate_con_age, '65+', 'Total')

## Summarise for non-uk born cases

## Run summary function for all cases
IncTotalAllCases <- sum_inc_rate_stats(inc_rate_con_age, 'All cases (crude)', 'Total')

## Run summary for all cases: 65+
IncTotal0_14 <- sum_inc_rate_stats(inc_rate_con_age, '0-14', 'Total')

## Run summary for all cases: 15-64
IncTotal15_64 <- sum_inc_rate_stats(inc_rate_con_age, '15-64', 'Total')

## Run summary for all cases: 65+
IncTotal65Up <- sum_inc_rate_stats(inc_rate_con_age, '65+', 'Total')