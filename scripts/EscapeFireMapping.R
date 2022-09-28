pacman::p_load(tidyverse, sf, stars)

FtK <- 
  read_sf('./SpatialData/boundary', 
          'boundary_ftkeogh_LL') %>%
  st_transform(26913) %>%
  st_buffer(500)

ftk <- FtK %>% as('Spatial')

# Before L 9
  B7_0916 <- terra::rast('C:/Users/devan.mcgranahan/Downloads/LC09_L1TP_036028_20220916_20220916_02_T1_B7.tif') %>%
              terra::crop(ftk)
  
  B5_0916 <- terra::rast('C:/Users/devan.mcgranahan/Downloads/LC09_L1TP_036028_20220916_20220916_02_T1_B5.tif') %>%
              terra::crop(ftk)
  
  bNBR = ( (B5_0916 - B7_0916) / (B5_0916 + B7_0916) ) 

# AFter L 9
  
  B7_0921 <- terra::rast('C:/Users/devan.mcgranahan/Downloads/LC09_L1GT_128216_20220921_20220921_02_T2_B7.tif') %>%
                terra::crop(ftk)

  B5_0921 <- terra::rast('C:/Users/devan.mcgranahan/Downloads/LC09_L1GT_128216_20220921_20220921_02_T2_B5.tif') %>%
                terra::crop(ftk)
  
  aNBR = ( (B5_0921 - B7_0921) / (B5_0921 + B7_0921) ) 
  
  dNBR = bNBR - aNBR %>%
    as_raster()
    st_as_stars(
      .x,
      ignore_file = FALSE,
      as_attributes = all(terra::is.factor(.x))
    )
            

  raster::plot(dNBR)
  
  st_bbox(FtK) %>% raster::plot() 
  
  # Before S2
  B08_18 <- terra::rast('S:/DevanMcG/FireScience/Sentinel/T13TDM_20220918T175009_B08.jp2') %>%
    terra::crop(ftk)
  B12_18 <- terra::rast('S:/DevanMcG/FireScience/Sentinel/T13TDM_20220918T175009_B12.jp2') %>%
    terra::crop(ftk)
  
  bNBRs  = (B08_18 - B12_18) / (B08_18 + B12_18) 
  
  raster::plot(B08_18) 
  raster::plot(B12_18) 
  
  # After S2
  B08_21 <- terra::rast('S:/DevanMcG/FireScience/Sentinel/T13TDM_20220921T180039_B08.jp2') %>%
    terra::crop(ftk)
  B12_21 <- terra::rast('S:/DevanMcG/FireScience/Sentinel/T13TDM_20220921T180039_B12.jp2') %>%
    terra::crop(ftk)

  aNBRs  = (B08_21 - B12_21) / (B08_21 + B12_21) 
  
  raster::plot(B08_21) 
  raster::plot(B12_21)
  