sapply(dir("R", full.names = T), source)

url <- "https://www.quebec.ca/en/health/health-issues/a-z/2019-coronavirus/situation-coronavirus-in-quebec/"

qc_tables <- xml2::read_html(url) %>% 
  rvest::html_table()

time_stp <- qc_tables %>% 
  .[[1]] %>% 
  colnames() %>% 
  .[[2]]

t_stamp <- time_stp %>% 
  gsub(".*on|,.*", "", .) %>% 
  gsub("^\\s", "", .) %>% 
  as.Date("%B %d")


cases <- extract_tbl(qc_tables, 1, "conf_cases")
extract_tbl(qc_tables, 3, "deaths")

write.table(cases, "data/cases.csv", sep = ",", col.names = !file.exists("data/cases.csv"), append = T, row.names = FALSE)
