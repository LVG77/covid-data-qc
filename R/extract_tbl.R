
extract_tbl <- function(tbl_list, idx = 1, var_id = "cases") {
  df <- tbl_list[[idx]]
  names(df) <- c("regions", "value")
  df <- df[!grepl("^\\(?Source", df$regions), ] 
  df <- df[!grepl("Total", df$regions), ] 
  df[ , "value"] <- as.integer(gsub("[^\\d]+", "", df[ , "value"], perl = TRUE))
  df[ ,"type"] <- var_id
  df[ ,"date"] <- t_stamp
  df
}