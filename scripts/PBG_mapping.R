pacman::p_load(tidyverse, sf, stars)
pacman::p_load_gh('devanmcg/wesanderson')
source('https://raw.githubusercontent.com/devanmcg/rangeR/master/R/CustomGGplotThemes.R')


ftk_sf <- read_sf('./SpatialData/boundary', 
                  'boundary_ftkeogh_LL') %>% 
  st_transform(26913) 

prod_d <- 
  readxl::read_xlsx('./PastureStocking/RangeProd.xlsx', 
                    'SSURGO') %>%
  select(musym, compname, rsprod_l, rsprod_r, rsprod_h) %>%
  rename(low = rsprod_l, 
         norm = rsprod_r, 
         high = rsprod_h)
  
es_sf <-
  read_sf('./SpatialData/soils/eco_sites', 
            'ftk_es') %>%
  rename(musym = MUSYM) %>%
  select(-MUKEY)

 es_prod <- left_join(es_sf, prod_d)

pastures <- 
  read_sf('./SpatialData/pastures', 
          'pastures') 

ggplot(pastures) + theme_map(14) +
geom_sf(aes(fill = pasture), 
        color = 'grey70', 
        show.legend = F)  +
  geom_sf_text(aes (label = pasture), 
               show.legend = FALSE) 

pbg <- 
  pastures %>% 
  filter(pasture %in% c('Upper Coal Creek', '2a North', '2a South', '3 Pasture',
                        'Sandridge North Native', 'Sandridge South Native', 
                        "Moon Creek", "Upper Lignite Creek", 'North 4', 'South 4')) %>%
  mutate(unit = case_when(
    pasture %in% c("North 4", "South 4") ~ "4 pastures", 
    pasture %in% c('Sandridge North Native', 'Sandridge South Native')  ~ "Sandridge", 
    #pasture %in% c('2a North', '2a South') ~ '2A', 
    TRUE ~ pasture), 
    pasture = case_when(
      pasture %in% c("North 4", "South 4") ~  paste(substr(pasture, 1,1), "4"),
      pasture %in% c('Sandridge North Native', 'Sandridge South Native')  ~ str_remove_all(pasture, " Native"), 
      #pasture %in% c('2a North', '2a South') ~ '2A', 
      TRUE ~ pasture), 
    group = case_when(
      substr(pasture, 1,5) == 'Upper' ~ "manage", 
      TRUE ~ 'study'  )) %>%
  mutate(area = st_area(.)) %>%
  group_by(group, pasture) %>%
  summarise(area = sum(area))

pbg_prod <- st_intersection(pbg, es_prod)

pbg_prod %>%
  mutate(acres = as.numeric(st_area(.) * 0.0002471054), 
         across(c(low, norm, high), ~ . * acres) ) %>%
  pivot_longer(names_to = "scenario", 
               values_to = "t_ac", 
               cols = c('low', 'norm', 'high')) %>%
  filter(!is.na(t_ac)) %>% 
  group_by(scenario, unit) %>%
  summarize(productivity = sum(t_ac), 
            .groups = 'drop') %>%
  mutate(AUMs_50 = (productivity*0.5)/915)

ggplot() + theme_map(14) + 
  geom_sf(data = pbg_prod, 
          aes (fill = norm/1000),
          color = NA,
          show.legend = TRUE) +  
  geom_sf(data = pastures, 
          fill = NA, 
          color = 'grey70')  + 
  geom_sf(data = pbg, 
          fill = NA, 
          color = 'white')  + 
  geom_sf_text(data = pbg, 
               aes (label = unit), 
               show.legend = FALSE) + 
  geom_sf(data = ftk_sf, 
          fill = NA, 
          color = "black") +
  scale_fill_gradientn("Normal\norage\nproduction\n(t/ac)", colors= wes_palette("Zissou1"))

# Study pastures 

study <-
  pbg %>%
  filter(group == 'study') %>%
  mutate(trt = case_when(
    pasture %in% c('Moon Creek', 'N 4') ~ "8 yr, Biennial", 
    pasture %in% c('3 Pasture', 'S 4' ) ~ "4 yr, Biennial",
    pasture %in% c('2a North', 'Sandridge North') ~ "8 yr, Annual", 
    pasture %in% c('2a South', 'Sandridge South') ~ "4 yr, Annual"
  ))

# st_write(study, './SpatialData/pastures/PatchBurn/pastures.shp')


study_sites <-
  pbg_prod %>%
  filter(group == 'study', 
         ! site %in% c('None', 'none')) %>%
  mutate(acres = as.numeric(st_area(.) * 0.0002471054), 
         trt = case_when(
                  pasture %in% c('Moon Creek', 'N 4') ~ "8 yr, Biennial", 
                  pasture %in% c('3 Pasture', 'S 4' ) ~ "4 yr, Biennial",
                  pasture %in% c('2a North', 'Sandridge North') ~ "8 yr, Annual", 
                  pasture %in% c('2a South', 'Sandridge South') ~ "4 yr, Annual"
  )) %>%
  group_by(pasture, site) %>%
  summarize(acres = sum(acres)) %>%
  arrange(pasture, desc(acres)) %>%
  slice(1:3)

# st_write(study_sites, './SpatialData/soils/study_sites/study_sites.shp')

ggplot() + theme_map(14) + 
  geom_sf(data = study_sites, 
          aes(fill = site), 
          color = 'white',
          show.legend = TRUE)  + 
  geom_sf(data = study,  
                fill = NA,
               color = "black") + 
  # geom_sf_text(data = study,  
  #              aes (label = pasture), 
  #              fontface= 'bold') + 
  scale_fill_manual("Ecological site", values= wes_palette("Zissou1"))


study_sites %>%
  as_tibble() %>%
  select(pasture, site, acres) %>%
  pivot_wider(names_from = site, 
              values_from = acres)
  pander::pander("Acreage of three most extensive ecological sites by pasture.") 
  

  
# sample locations 
  
ftk_dem <- read_stars('./SpatialData/DEM/dem.tif') 
  
slope <- 
  terra::terrain(dem, 'slope') %>%
    raster::rasterToContour(nlevels = 100, maxpixels = 100000) 
flat_areas <-
  slope %>%
  st_as_sf() %>%
  filter(level <= 0.05) %>%
         st_crop(study_sites) %>%
 st_cast("MULTIPOINT") %>%
  mutate(points = mapview::npts(., by_feature = TRUE)) %>%
  filter(points >= 4) %>%
  st_cast("LINESTRING") 
    
  
  
    ggplot( ) + theme_map() +
     geom_sf(data = study_sites,
             fill = "grey90") +
    geom_sf(data = flat_areas,
            aes(color = level), 
            size = 1)  +    
      geom_sf(data = study, 
              fill = NA, 
              size = 1,
              color = "black") 

  

