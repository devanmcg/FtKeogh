pacman::p_load(tidyverse, sf, stars)

FtK <- 
  read_sf('S:/ArcGIS/FK_boundary', 
          'boundary_ftkeogh') %>%
  st_transform(26913)

ftk_dem <- read_stars('S:/DevanMcG/GIS/SpatialData/FtKeogh/DEM/USGS_1_n47w106.tif') %>%
            st_transform(26913) %>%
              st_crop(FtK)

ggplot( ) + theme_bw() +
  geom_stars(data =  ftk_dem) +
  coord_equal() +
  scale_fill_viridis_c("tree cover") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0))
