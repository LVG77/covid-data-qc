sapply(dir("R", full.names = T), source)
library(rvest)

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
deaths <- extract_tbl(qc_tables, 3, "deaths")

write.table(cases, "data/cases_test.csv", sep = ",", col.names = !file.exists("data/cases_test.csv"), append = T)
write.table(cases, "data/deaths_test.csv", sep = ",", col.names = !file.exists("data/deaths_test.csv"), append = T)
