
extract_tbl <- function(tbl_list, idx = 1, col_name = "cases") {
  df <- tbl_list[[idx]]
  names(df) <- c("regions", col_name)
  df <- df[!grepl("^\\(?Source", df$regions), ] 
  df <- df[!grepl("Total", df$regions), ] 
  df[ , col_name] <- as.integer(gsub("\\s", "", df[ , col_name]))
  df[ ,"date"] <- t_stamp
  df
}