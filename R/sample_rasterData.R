# Sample Air Quality Raster -----------------------------------------------

# path <- c("C:/Users/User/OneDrive - University of Leeds/WCCRToolData/mappm102021g.tif")
# lng <- -1.93359375
# lat <- 53.8395636788336

sample_airQuality <- function(path, lng, lat){
  
  # Read raster
  airQual_rast <- terra::rast(x = path)
  
  # Construct a data frame from longitude and latitude values
  location_df <- data.frame("lng" = lng, "lat" = lat)
  location_sf <- sf::st_as_sf(x = location_df, coords = c("lng", "lat"), crs = sf::st_crs("EPSG:4326")) |>
    sf::st_transform(crs = sf::st_crs("EPSG:27700"))
  
  # Sample raster to retrieve DAMS score
  airQual_score <- terra::extract(airQual_rast, terra::vect(location_sf))
  
  
}

