## Extract case counts from the data
extract_case_counts = function(df, strat_var =  c('age', 'year', 'ukborn')) {
  df %>% 
    mutate(age = replace(age, age >= 90, 90) %>% as.character) %>%
    mutate(age = replace(age, age %in% '90', '90+')) %>% 
    mutate(age = factor(age, levels = c(as.character(0:89), '90+'))) %>% 
    count_(vars = strat_var) %>% 
    ungroup() %>% 
    rename(Year = year, Cases = n, CoB = ukborn) %>% 
    rename(Age = age) %>% 
    mutate(`Age group (condensed)` = Age %>%  as.character %>% replace(Age %in% '90+', '90') %>% 
             as.numeric %>%
             cut(breaks = c(0, 15, 65, 91), right = FALSE, ordered_result = TRUE, labels = c('0-14', '15-64', '65+'))) %>% 
    mutate(`Age group` = Age %>%  as.character %>% replace(Age %in% '90+', '90') %>% 
             as.numeric %>%
             cut(breaks = c(seq(0,90,5), 91), right = FALSE, ordered_result = TRUE, labels = c(paste(seq(0,85, 5), seq(4,89,5), sep = '-'), '90+'))) -> case_year_age
  return(case_year_age)
}

## Function to estimate the case rate for a given variable, stratified by given variables, dependant on age, year, agegrp2, and uk birth status. Missing data for the rate variable is dropped
case_rate = function(df, rate_for, strat_by = NULL, age_split = NULL, CoB_split = TRUE, Year_strat = TRUE) {
  CaseCountVar <- c('age', 'year', 'ukborn')
  GroupByCase <- c()
  GroupByTotCase <- c()
  
  if (!is.null(strat_by)) {
    
    CaseCountVar <- c(CaseCountVar, strat_by)
    GroupByCase <- c(GroupByCase, strat_by)
    GroupByTotCase <- c(GroupByTotCase, strat_by)
  }
  
  if (!is.null(rate_for)) {
    
    CaseCountVar <- c(CaseCountVar, rate_for)
    GroupByCase <- c(GroupByCase, rate_for)
  }
  
  if (!is.null(age_split)) {
    GroupByCase <- c(GroupByCase, age_split)
    GroupByTotCase <- c(GroupByTotCase, age_split)
  }
  
  if (CoB_split) {
    GroupByCase <- c(GroupByCase, 'CoB')
    GroupByTotCase <- c(GroupByTotCase, 'CoB')
  }

  if (Year_strat) {
    GroupByCase <- c(GroupByCase, 'Year')
    GroupByTotCase <- c(GroupByTotCase, 'Year')
  }
  
  
  df %>%  
    filter_at(.vars = rate_for, all_vars(!is.na(.))) %>% 
    extract_case_counts(strat_var = CaseCountVar) %>% 
    group_by(.dots = GroupByCase) %>%
    summarise(Cases = sum(Cases, na.rm = TRUE)) %>% 
    ungroup %>% 
    group_by(.dots = GroupByTotCase) %>%
    add_count(wt = Cases) %>% 
    rename(`Total cases` = n) %>% 
    ungroup() %>%
    rowwise %>% 
    filter(!(`Total cases` <= 0)) %>% 
    mutate(`Case rate` = prop.test(Cases, `Total cases`)$estimate * 100,
           LowRate = prop.test(Cases, `Total cases`)$conf.int[1] * 100, 
           HiRate = prop.test(Cases, `Total cases`)$conf.int[2] * 100)
}
