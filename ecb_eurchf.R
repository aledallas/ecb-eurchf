# Retrieve EUr/CHF currency exchange data from ECB
library(tidyverse)
library(xml2)
library(writexl)

url <- "https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/chf.xml"

pg <- read_html(url)

# extract obesrvations
obs_raw <- pg %>% 
  xml_find_all(".//obs") %>% # more than three times faster than going through xml_child
  xml_attrs()

# do some cleaning
obs <- obs_raw %>% 
  enframe() %>% 
  unnest_wider(value) %>% 
  select(-name) %>% 
  mutate(time_period = as.Date(time_period),
         obs_value = as.numeric(obs_value)) %>% 
  arrange(desc(time_period))

# write output
writexl::write_xlsx(obs, "ecb_eurchf.xlsx")
