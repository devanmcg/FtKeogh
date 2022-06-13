pacman::p_load(tidyverse, sf, stars)

fk_es <- read_sf('S:/DevanMcG/GIS/SpatialData/FtKeogh/soils/eco_sites', 
                 'ftk_es')

fk_es %>%
  mutate(Name = case_when(
    Name %in% c("Sands", "Sandy-Steep") ~ "Sandy", 
    Name %in% c("Clayey", "Claypan", "Dense clay") ~ "Clays", 
    Name == "Shallow Clay" ~ "Shallow", 
    TRUE ~ Name  )) %>%
  select(MUSYM:Name) %>%
  rename(site = Name)
