
# Miss data ---------------------------------------------------------------
complete_per = function(var, digits=0)
{
 tmp <- sum(!is.na(var))
 tmp2 <- length(var)
 
 per <- pretty_percentage(tmp, tmp2, 1)
   
 return(per) 
}

# Group by incidence ------------------------------------------------------
count_ext <- function(time_length, df, filter=NULL, condition=NULL) {
  #drop NA values
  df <- df[!is.na(df[[time_length]]),]
  #apply count filtering
  if (is.null(filter)) {
    df_fil <- df
  }else{
    df_fil <- df[df[[filter]] %in% condition,]
  }
  df_inc <- df_fil %>% count_(time_length)
  
  # Add days with no notifications
  temp <- data_frame(date= seq.Date(min(df[[time_length]]), max(df[[time_length]]), 'day' ))
  df_inc <- merge(temp, df_inc, by.x='date', by.y=time_length, all.x=TRUE, all.y=TRUE) %>% as_data_frame
  df_inc$n <- ifelse(is.na(df_inc$n), 0, df_inc$n)
  df_inc$day <-seq(1, nrow(df_inc))
  return(df_inc)
}


prop_date1_after_date2 <- function(date1, date2)
{
  t <- (ETS_ext[[date1]] - ETS_ext[[date2]]) %>% na.omit
  t <- ifelse(t<0,0,1)
  t <- sum(t)/length(t)*100
  t <- round(t, digits=1)
  return(t)
}

mean_date1_after_date2 <- function(date1, date2)
{
  t <- (ETS_ext[[date1]] - ETS_ext[[date2]]) %>% na.omit
  m_t <- mean(t)
  m_t <- round(m_t)
  q_t <- quantile(t)[2:4]
  q_t <- paste0(names(q_t),': ', q_t) %>% paste(collapse=', ')
  t <- paste0(m_t, ' (', q_t,')')
  return(t)
}