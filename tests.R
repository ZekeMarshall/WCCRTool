source("Utility/filepaths.R")
source("Utility/constants.R")
source("R/clip_vectorData.R")

species <- "Hyacinthoides non-scripta"
# species <- "Erica cinerea"
# species <- "Geranium robertianum"
lng <- -1.53630761358272
lat <- 54.6981423390006
colonisationRate <- 100
colonisationYears <- 100

location <- sf::st_as_sf(data.frame("lng" = lng, 
                                    "lat" = lat), 
                         coords = c("lng", "lat"), 
                         crs = sf::st_crs(4326), 
                         dim = "XY")
searchArea <- sf::st_buffer(location, dist = colonisationRate * colonisationYears)
searchArea27700 <- searchArea |>
  sf::st_transform(crs = sf::st_crs(27700))

# occ_df <- data.frame(id = c(NA),
#                      lat = c(NA), 
#                      lon = c(NA))
# 
# searchArea_wkt <- sf::st_as_text(searchArea$geometry)
# 
# key <- rgbif::name_backbone(name = species, kingdom = 'plants')
# 
# response <- rgbif::occ_search(taxonKey = as.numeric(key$usageKey), limit = 99999,
#                               geometry = searchArea_wkt)
# 
# occ_df <- data.frame(id = response$data$key,
#                      lat = response$data$decimalLatitude, 
#                      lon = response$data$decimalLongitude) |>
#   dplyr::filter(!is.na(lat) | !is.na(lon))


clipArea <- searchArea27700

AWData <- read_AWData(AWPath = AWPath)

NFIData <- read_NFIData(NFIPath = NFIPath)

AWData_clipped <- AWData |>
  sf::st_intersection(searchArea27700) |>
  sf::st_transform(crs = sf::st_crs(4326))

NFIData_clipped <- NFIData |>
  sf::st_intersection(clipArea) |>
  sf::st_transform(crs = sf::st_crs(4326)) #|>
  # sf::st_crop(AWData_clipped)

NFIData_cropped <- AWData_clipped |>
  sf::st_crop(NFIData_clipped) 

leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::setView(
    lng = lng,
    lat = lat,
    zoom = 14
  ) |>
  leaflet::addPolygons(data = searchArea,
                       color = searchArea_color,
                       weight = 5,
                       # opacity = 1,
                       fill = FALSE,
                       fillColor = searchArea_color,
                       fillOpacity = 0.5) |>
  # leaflet::addPolygons(data = AWData_clipped,
  #                      color = AW_color,
  #                      weight = 5,
  #                      # opacity = 1,
  #                      fill = TRUE,
  #                      fillColor = AW_color,
  #                      fillOpacity = 0.5) |>
  leaflet::addPolygons(data = NFIData_clipped,
                       color = OW_color,
                       weight = 5,
                       # opacity = 1,
                       fill = TRUE,
                       fillColor = OW_color,
                       fillOpacity = 0.5) #|>
  # leaflet::addMarkers(lng = occ_df$lon, lat = occ_df$lat)


# Test Clipping Ancient Woodland Data -------------------------------------


