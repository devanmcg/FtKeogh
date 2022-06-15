pacman::p_load(tidyverse, sf, stars)

FtK <- 
  read_sf('S:/ArcGIS/FK_boundary', 
          'boundary_ftkeogh') %>%
  st_transform(26913)

dem <- 
  FtK  %>%
  as_Spatial()  %>%
  elevatr::get_elev_raster(z = 13, 
                           clip = 'bbox', 
                           verbose = F, 
                           override_size_check = T) 
# raster::writeRaster(dem, './SpatialData/DEM/dem.tif')

ftk_dem <- read_stars('./SpatialData/DEM/dem.tif') 

slope %>%
  filter(slope <= 0.02) %>%
ggplot( ) + theme_bw() +
  geom_stars( ) 

st_as_stars(slope)

slope <- terra::terrain(dem, 'slope') 
# raster::writeRaster(slope, './SpatialData/DEM/slope.tif')
