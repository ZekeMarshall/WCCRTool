# Create search area ------------------------------------------------------

create_searchArea <- function(lng, lat, searchBuffer){
  
  # lng <- -1.93359375
  # lat <- 53.8395636788336
  # searchBuffer <- 400
  
  location <- sf::st_as_sf(data.frame("lng" = lng, 
                                      "lat" = lat), 
                           coords = c("lng", "lat"), 
                           crs = sf::st_crs("ESPG:4326"), 
                           dim = "XY")
  searchArea <- sf::st_buffer(sf_df, dist = searchBuffer)
  
  return(searchArea)
  
  
}

# Retrieve GBIF occurrences for a single species --------------------------

retrieve_GBIFOccurrences <- function(species, searchArea){
  
  searchArea_wkt <- sf::st_as_text(searchArea$geometry)
  
  # species <- "Hyacinthoides non-scripta"

  key <- rgbif::name_backbone(name = species, kingdom = 'plants')
  
  res <- rgbif::occ_search(taxonKey = as.numeric(key$usageKey), limit = 99999, 
                           geometry = searchArea_wkt)
  
  return(res)
  
  
}



# leaflet::leaflet() |> 
#   leaflet::addTiles() |>
#   leaflet::setView(
#     lng = lng,
#     lat = lat,
#     zoom = 14
#   ) |>
#   leaflet::addPolygons(data = searchArea,
#                        color = "#35B779", 
#                        weight = 3, 
#                        fillOpacity = 0, 
#                        opacity = 1)


# Retrieve GBIF occurrences for multiple species --------------------------




