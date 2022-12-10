# species <- "Hyacinthoides non-scripta"
# species <- "Erica cinerea"
# species <- "Geranium robertianum"
# lng <- -1.53630761358272
# lat <- 54.6981423390006
# colonisationRate <- 10
# coloinisationYears <- 100

# Create search area ------------------------------------------------------

create_searchAreaPolygon <- function(polygon, colonisationRate, coloinisationYears){
  
  searchArea <- sf::st_buffer(polygon, dist = colonisationRate * coloinisationYears)
  
  return(searchArea)
  
  
}

create_searchAreaPoint <- function(lng, lat, colonisationRate, coloinisationYears){
  
  location <- sf::st_as_sf(data.frame("lng" = lng, 
                                      "lat" = lat), 
                           coords = c("lng", "lat"), 
                           crs = sf::st_crs(4326), 
                           dim = "XY")
  searchArea <- sf::st_buffer(location, dist = colonisationRate * coloinisationYears)
  
  return(searchArea)
  
  
}

# Retrieve GBIF occurrences for a single species --------------------------

retrieve_GBIFOccurrences <- function(species, searchArea){
  
  occ_df <- data.frame(id = c(NA),
                       lat = c(NA), 
                       lon = c(NA))
  
  searchArea_wkt <- sf::st_as_text(searchArea$geometry)

  key <- rgbif::name_backbone(name = species, kingdom = 'plants')
  
  response <- rgbif::occ_search(taxonKey = as.numeric(key$usageKey), limit = 99999,
                                geometry = searchArea_wkt)
  
  if(is.null(response)){
    
    occ_df <- data.frame(id = response$data$key,
                         lat = response$data$decimalLatitude, 
                         lon = response$data$decimalLongitude) |>
      dplyr::filter(!is.na(lat) | !is.na(lon))
    
  } else {
    
    occ_df <- data.frame(id = c(NA),
                         lat = c(NA), 
                         lon = c(NA))
  }
  
  return(occ_df)
  
}



# Testing -----------------------------------------------------------------

# leaflet::leaflet() |>
#   leaflet::addTiles() |>
#   leaflet::setView(
#     lng = lng,
#     lat = lat,
#     zoom = 14
#   ) |>
#   leaflet::addPolygons(data = searchArea) |>
#   leaflet::addMarkers(lng = occ_df$lon, lat = occ_df$lat)





