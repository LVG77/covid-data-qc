sapply(dir("R", full.names = T), source)
library(rvest)

pins::board_register_github(repo = "LVG77/covid-data-qc", branch = "datasets")

covid_qc <- pins::pin_get("covid_qc", board = "github", cache = FALSE)

url <- "https://www.quebec.ca/en/health/health-issues/a-z/2019-coronavirus/situation-coronavirus-in-quebec/"

qc_tables <- xml2::read_html(url) %>% 
  rvest::html_table()

time_stp <- qc_tables %>% 
  .[[1]] %>% 
  colnames() %>% 
  .[[2]]

t_stamp <- time_stp %>% 
  gsub(".*on|,.*", "", .) %>% 
  gsub("^\\s", "", ., perl = TRUE) %>% 
  as.Date("%B %d")

if (!t_stamp %in% covid_qc$date) {
  cases <- extract_tbl(qc_tables, 1, "conf_cases")
  deaths <- extract_tbl(qc_tables, 3, "deaths")
  
  covid_upd <- 
    covid_qc %>% 
    rbind(cases) %>% 
    rbind(deaths) 
  
  pins::pin(covid_upd, name = "covid_qc", board = "github")
}




# cases <- readr::read_csv("/Users/lvg/Desktop/cases.csv")
# 
# cases_df <- cases %>%
#   dplyr::rename(value = conf_cases) %>%
#   dplyr::mutate(type = "conf_cases") %>%
#   dplyr::select(regions, value, type, date)
# 
# pins::pin(cases_df, name = "covid_qc", board = "github")
