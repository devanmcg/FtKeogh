pacman::p_load(tidyverse, sf)
source('https://raw.githubusercontent.com/devanmcg/rangeR/master/R/CustomGGplotThemes.R')

shp_fp = 'S:/Jay Angerer/GIS'

grazing_sf <- read_sf(shp_fp, 'Grazing pastures 2021')

grazing_sf %>%
  pivot_longer(names_to = 'month', 
               values_to = 'assignment', 
               cols = Jan_2021:Dec_2021) %>%
  mutate(Assignment = case_when(
                    assignment == "REST" ~ "Being 'rested'", 
                    is.na(assignment) ~ 'Not stocked', 
                    TRUE ~ 'Stocked'),
         month = str_extract(month, "^.*(?=(_))"), 
         month = case_when(
                  month %in% c('July', 'June', 'April',
                               'March', 'Sept') ~ substr(month, 1, 3), 
                  TRUE ~ month), 
         month = factor(month, levels = month.abb)) %>%
  st_sf() %>% 
  ggplot() + theme_map() + 
  geom_sf(aes(fill = Assignment), 
          alpha = 0.5) + 
  facet_wrap(~ month) +
  labs(title = "Pasture-level management by month (2021)") + 
  theme(plot.margin = margin(3,2,2,2))

StockingMonths <- 
  grazing_sf %>%
    pivot_longer(names_to = 'month', 
                 values_to = 'assignment', 
                 cols = Jan_2021:Dec_2021) %>%
    select(Fld_Name, month, assignment, geometry) %>%
    mutate(assignment = case_when(
                          assignment == "REST" ~ 'NA', 
                          is.na(assignment) ~ 'NA', 
                          TRUE ~ 'stocked'), 
          month = str_extract(month, "^.*(?=(_))"), 
          month = case_when(
                      month %in% c('July', 'June', 'April',
                                   'March', 'Sept') ~ substr(month, 1, 3), 
                      TRUE ~ month), 
          month = paste0(month, " ")) %>%
    rename(pasture = Fld_Name) %>%
    pivot_wider(names_from = "assignment", 
                values_from = 'month') %>%
    select(pasture, stocked, geometry) %>%
   group_by(pasture) %>% 
    mutate(stocked = paste( unlist(stocked), collapse='')) %>%
    ungroup() %>%
    mutate(stocked = trimws(stocked), 
           pasture = str_to_title(pasture), 
           stocked = ifelse(stocked == "", "Not stocked", stocked)) %>%
    st_sf() 

write_sf(StockingMonths, 'S:/DevanMcG/GIS/FtKeoghMapping/PastureStocking/2021_StockingMonths.shp')

StockingMonths %>%
  mutate(pasture = str_replace_all(pasture, ' ', '\n')) %>% 
  mutate(area = st_area(.), 
         area = as.numeric(area)/1000) %>%
  filter(area >= 200, 
         stocked != "Not stocked") %>%
  ggplot() + theme_map() + 
  geom_sf(data = grazing_sf, 
          aes(fill = pasture), 
          fill = NA) + 
  geom_sf(aes(fill = pasture), 
          alpha = 0.5, 
          show.legend = F) + 
  geom_sf_text(aes(label = stocked), 
               size = 3) + 
  labs(title = "Pasture-level management by month (2021)", 
       caption = 'For clarity, only stocked pastures > 50 ac shown') + 
  theme(plot.margin = margin(3,2,2,2))

StockingMonths %>%
  select(-geometry) %>%
  pander::pander()
