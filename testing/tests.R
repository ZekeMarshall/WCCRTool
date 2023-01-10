source("Utility/filepaths.R")
source("Utility/constants.R")
source("R/clip_vectorData.R")

species <- "Hyacinthoides non-scripta"
# species <- "Erica cinerea"
# species <- "Geranium robertianum"
lng <- -1.53630761358272
lat <- 54.6981423390006
lng_testOcc <- -1.5325
lat_testOcc <- 54.699
colonisationRate <- 10
colonisationYears <- 100

lonleft = -1.749058
lonright = -1.711675
latbot = 54.49248
lattop = 54.50931


# Establish location as sf point
location <- sf::st_as_sf(data.frame("lng" = lng, 
                                    "lat" = lat), 
                         coords = c("lng", "lat"), 
                         crs = sf::st_crs(4326), 
                         dim = "XY")

# Buffer location sf point to create search area
searchArea <- sf::st_buffer(location, dist = colonisationRate * colonisationYears)
searchArea27700 <- searchArea |>
  sf::st_transform(crs = sf::st_crs(27700))


# Set slip area for spatial data
clipArea <- searchArea27700

# Read spatial data
AWData <- read_AWData(AWPath = AWPath)
NFIData <- read_NFIData(NFIPath = NFIPath)
urbanAreasData <- read_urbanAreasData(urbanAreasPath = urban.areas_path)
roadsData <- read_roadsData(roadsPath = roads_path)
railwaysData <- read_railwaysData(railwaysPath = railways_path)
riversData <- read_riversData(riversPath = rivers_path)

# Clip spatial data
AWData_clipped <- clip_AWData(AWData = AWData, clipArea = clipArea)
NFIData_clipped <- clip_NFIData(NFIData = NFIData, clipArea = clipArea)
urbanAreasData_clipped <- clip_urbanAreasData(urbanAreasData = urbanAreasData, clipArea = clipArea)
roadsData_clipped <- clip_roadsData(roadsData = roadsData, clipArea = clipArea)
railwaysData_clipped <- clip_railwaysData(railwaysData = railwaysData, clipArea = clipArea)
riversData_clipped <- clip_riversData(riversData = riversData, clipArea = clipArea)

# Remove AW polygons in NFI dataset
# NFIData_cropped <- AWData_clipped |>
#   sf::st_crop(NFIData_clipped) 

leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::setView(
    lng = lng,
    lat = lat,
    zoom = 14
  ) |>
  leaflet::addAwesomeMarkers(lng = c(lng, lng_testOcc), lat = c(lat, lat_testOcc)) |>
  leaflet::addPolygons(data = searchArea,
                       color = searchArea_color,
                       weight = 5,
                       # opacity = 1,
                       fill = FALSE,
                       fillColor = searchArea_color,
                       fillOpacity = 0.75) |>
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
                       fillOpacity = 0.5,
                       layerId = ~OBJECTID_1,
                       popup = paste("NFI ID: ", NFIData_clipped$OBJECTID_1, "<br>",
                                     "Woodland Category: ", NFIData_clipped$IFT_IOA, "<br>")) |>
  leaflet::addPolygons(data = urbanAreasData_clipped,
                       color = urban_color,
                       weight = 5,
                       # opacity = 1,
                       fill = TRUE,
                       fillColor = urban_color,
                       fillOpacity = 0.5,
                       layerId = ~name1_text,
                       popup = paste("Urban Area Name: ", urbanAreasData_clipped$name1_text, "<br>")) |>
  leaflet::addPolygons(data = roadsData_clipped,
                       color = road_color,
                       weight = 5,
                       # opacity = 1,
                       fill = TRUE,
                       fillColor = road_color,
                       fillOpacity = 0.5,
                       layerId = ~name1,
                       popup = paste("Road Name: ", roadsData_clipped$name1, "<br>")) |>
  leaflet::addPolygons(data = railwaysData_clipped,
                       color = railways_color,
                       weight = 5,
                       # opacity = 1,
                       fill = TRUE,
                       fillColor = railways_color,
                       fillOpacity = 1.0,
                       layerId = ~ELR,
                       popup = paste("ELR: ", railwaysData_clipped$ELR, "<br>")) #|>
  # leaflet::addPolygons(data = riversData_clipped,
  #                      color = rivers_color,
  #                      weight = 5,
  #                      # opacity = 1,
  #                      fill = TRUE,
  #                      fillColor = rivers_color,
  #                      fillOpacity = 0.5)


# Test Clipping Ancient Woodland Data -------------------------------------


