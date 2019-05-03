
# function of incidence by age and year -----------------------------------

table_inc_year_age = function(df, round=1)
{
  df %>%
    mutate(Incidence = round(Incidence, digits = round), Inc_LCI = round(Inc_LCI, digits = round), Inc_UCI = round(Inc_UCI, digits = round)) %>% 
    mutate(Incidence = paste0(Incidence, ' (', Inc_LCI, ', ', Inc_UCI, ')')) %>%
    select(Year, `Age group`, Incidence) %>% 
    spread(key = `Age group`, value = Incidence) -> df
  return(df)
}
