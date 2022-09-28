pacman::p_load(tidyverse, sf, stars)

FtK <- 
  read_sf('./SpatialData/boundary', 
          'boundary_ftkeogh_LL') %>%
  st_transform(32613) %>%
  st_buffer(500)

ftk <- FtK %>% as('Spatial')

# Before L 9
  B_NBR_0916 <- terra::rast('S:/DevanMcG/FireScience/Landsat/LC09_L2SP_036028_20220916_20220918_02_T1_SR_NBR.tif') %>%
              terra::crop(ftk)
  
  A_NBR_0925 <- terra::rast('S:/DevanMcG/FireScience/Landsat/LC09_L2SP_035028_20220925_20220927_02_T1_SR_NBR.tif') %>%
    terra::crop(ftk)
  
  
  dNBR = B_NBR_0916 - A_NBR_0925
  raster::plot(dNBR)

  terra::writeRaster(dNBR, './Fire/Fall2022dNBR.tif' )


  