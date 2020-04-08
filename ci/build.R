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
  .[2]

print(time_stp)
# time_stp <- " April 8"
# time_stp <- " April 8, 1 p.m."
# time_stp <- "Number of confirmed cases, on April 8, 1 p.m."

t_stamp <- time_stp %>% 
  gsub(".*\\son\\s", "", .) %>%
  gsub(",.*", "", .) %>%
  trimws() %>% 
  paste0(", 2020") %>%
  as.Date("%B %d, %Y")

if (!t_stamp %in% covid_qc$date) {
  cases <- extract_tbl(qc_tables, 1, "conf_cases", t_stamp)
  deaths <- extract_tbl(qc_tables, 3, "deaths", t_stamp)
  
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
# pins::pin_remove("covid_qc", board = "github")
# pins::pin(cases_df, name = "covid_qc", board = "github")
