pacman::p_load(tidyverse, sf, stars, terra, wesanderson)
load('./albersEAC.Rdata')

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
  
  
  dNBR <- terra::rast('./Fire/Fall2022dNBR.tif' ) 
  terra::crs(dNBR) <- "epsg:26913" 
  
  terra::writeRaster(dNBR, './Fire/Fall2022dNBR_utm13.tif' )
  
# work on dNBR of fire with terra
  dNBR_rast <- rast('./Fire/EscapeFire_dNBR_utm13.tif')
  names(dNBR_rast) <- "dNBR"
  dNBR_rast[dNBR_rast <= 1500] <- NA
  terra::writeRaster(dNBR_rast, './Fire/Fall2022dNBR_utm13_2.tif' )
  values(dNBR_rast) <- if(between(0, 1505)), 'NA'
  
  raster::plot(dNBR_rast)
  
  hist(dNBR_rast)
  terra::quantile(dNBR_rast$dNBR, probs=seq(0, 1, 0.25), na.rm=TRUE) 
  global(dNBR_rast, fun=quantile, probs=seq(0, 1, 0.33), na.rm=TRUE)
  
  
  dNBR_star <- read_stars('./Fire/Fall2022dNBR_utm13_2.tif') %>%
    rename(dNBR = Fall2022dNBR_utm13_2.tif) 
  
  dNBR_cat <- 
  dNBR_star %>%
    mutate(dNBR = as.character(dNBR), 
      dNBR = case_when(
      between(as.numeric(dNBR), 1600, 3235) ~ 'low', 
      between(as.numeric(dNBR), 3235, 4267) ~ 'med',
      between(as.numeric(dNBR), 4267, 5977) ~ 'high', 
      dNBR >= 5977 ~ "very high", 
      TRUE ~ 'NA'), 
      dNBR = factor(dNBR, levels = c('NA', 'low', 'med', 'high', 'very high' ))) 
  
  dNBR_cat %>%
    st_transform(albersEAC) %>%
     write_stars('./Fire/cat_dNBR_aea.tif')
  
  ggplot() + theme_bw() + 
    geom_stars(data = dNBR_cat) +
    scale_fill_manual("Severity", values = c('white', wes_palette('Zissou1')[c(2,3,4,5)]))
  
               