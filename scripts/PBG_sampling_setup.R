pacman::p_load(tidyverse, sf)

patches <- 
  read_sf('./SpatialData/PatchBurning/Patches', 
          'patches') %>%
  select(-acres)

es_sf <-
  read_sf('./SpatialData/soils/eco_sites', 
          'ftk_es') %>%
  rename(musym = MUSYM) %>%
  select(-MUKEY) %>%
  st_transform(st_crs(patches))

patches %>%
  group_by(pasture) %>%
  mutate(patch = seq(1,3,1)) %>%
  arrange(pasture) %>%
  st_intersection(es_sf) %>%
  filter(! site %in% c('None')) %>%
  mutate(temp = gsub("([A-Z]+)",",\\1",musym)) %>%
  separate(temp, c('code', 'slope'), sep = ',') %>% 
  #filter(slope %in% c('A', 'B', 'C', 'D')) %>%
  select(-code, -slope) %>%
  mutate(area = st_area(.)) %>%
  group_by(pasture, patch, site) %>%
  arrange(desc(area)) %>%
  select(-area) %>% 
  group_by(pasture, patch) %>% 
  slice(1:3) %>%
  ungroup() %>%
  st_cast('MULTIPOLYGON') %>%
  st_cast('POLYGON') %>%
  mutate(area = st_area(.)) %>%
  group_by(pasture, patch, site) %>%
  arrange(desc(area)) %>%
  slice(1) %>%
  st_write('./SpatialData/PatchBurning/Patches/DomSites.shp')
  ggplot() + theme_bw(14) + 
  geom_sf(aes(fill = site)) +
  geom_sf(data = patches, fill = NA)


  mutate(musym = gsub("([0-9]+)",",\\1",musym)
         strsplit(x,","))




es_prod <- left_join(es_sf, prod_d)

ggplot() + theme_bw(14) + 
  geom_sf(data = es_sf) +
  geom_sf(data = patches, 
          aes(fill = BurnYr))

# Setting up plots 

plots <-
  read_sf('./SpatialData/PatchBurning/Sampling', 
          'PlotsBySite')

trt <- 
  read_sf('./SpatialData/PatchBurning/Pastures', 
                    'pastures') %>%
  select(trt) %>%
  st_transform(st_crs(plots))

PatchSites <- 
  read_sf('./SpatialData/PatchBurning/Patches', 
          'DomSites') %>%
  select(-musym, -area) %>%
  st_intersection(trt)

longFRIplots <-
  plots %>%
    select(-id) %>%
    st_intersection(PatchSites) %>%
    filter(trt == '6') %>%
    arrange(pasture, patch) %>%
    mutate(id = seq(1, n(), 1)) 

longFRIppoints <-
  longFRIplots %>%
    st_cast("MULTIPOINT") %>%
    st_cast('POINT') %>%
    rename(plot = id) %>% 
    group_by(plot) %>%
    mutate(point = LETTERS[1:n()]) %>%
  select(pasture, plot, point, )


  ggplot() + theme_bw(14) + 
  geom_sf( ) +
  geom_sf(data = filter(patches, trt == '6'),
          fill= NA) 
