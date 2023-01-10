source("Utility/constants.R", local = TRUE)
source("Utility/filepaths.R", local = TRUE)
source("Utility/load_data.R", local = TRUE)

# Source model function scripts
source("R/sample_rasterData.R", local = TRUE)
source("R/queryNFIAPI.R", local = TRUE)
source("R/retrieveOccs.R", local = TRUE)
source("R/retrieveMDD.R", local = TRUE)
source("R/retrieveOSA.R", local = TRUE)
source("R/spatialOperations.R", local = TRUE)

user_woodland_sf <- readRDS(file = "testing/user_woodland_sf.rds")

searchArea_4326 <- readRDS(file = "testing/sitePolygonBuffer_4326.rds")

occs_sf <- readRDS(file = "testing/occs_sf.rds")

searchArea_bbox <- sf::st_bbox(searchArea_4326)

nfi_data <- queryNFIAPI(lonleft = searchArea_bbox$xmin, 
                        lonright = searchArea_bbox$xmax, 
                        latbot = searchArea_bbox$ymin, 
                        lattop = searchArea_bbox$ymax)

occs_df <- occs_sf |>
  # sf::st_transform(sf::st_crs(3857)) |>
  sf::st_coordinates() |>
  as.data.frame() |>
  dplyr::rename("lng" = "X", "lat" = "Y")

leaflet::leaflet() |>
  # leaflet::addTiles() |>
  leaflet::addPolygons(data = nfi_data,
                       color = "#748802",
                       weight = 3,
                       fillOpacity = 0.75,
                       opacity = 1,
                       layerId = ~OBJECTID_1,
                       popup = paste("NFI ID: ", nfi_data$OBJECTID_1, "<br>",
                                     "Woodland Category: ", nfi_data$IFT_IOA, "<br>")) |>
  leaflet::addPolygons(data = user_woodland_sf,
                       color = "#3c5c3c",
                       weight = 3,
                       fillOpacity = 0.75,
                       opacity = 1)

# plot()

# Rasterise forest habitat network ----------------------------------------
nfi_data_3857 <- nfi_data  |>
  sf::st_transform(crs = sf::st_crs(3857))
nfi_data_SpatVector <- terra::vect(nfi_data_3857)
raster_template = terra::rast(terra::ext(nfi_data_SpatVector), 
                              resolution = 10,
                              crs = sf::st_crs(nfi_data_SpatVector)$wkt)
nfi_data_rast_SpatRaster <- terra::rasterize(x = nfi_data_SpatVector,
                                             y = raster_template)

nfi_data_rast_raster <- raster::raster(nfi_data_rast_SpatRaster)



# Rasterise user target woodland ------------------------------------------
user_woodland_sf_3857 <- user_woodland_sf |>
  sf::st_transform(crs = sf::st_crs(3857))

user_woodland_SpatRaster <- terra::rasterize(x = user_woodland_sf_3857,
                                             y = raster_template)
user_woodland_raster <- raster::raster(user_woodland_SpatRaster)

# Compile Forest Habitat Network ------------------------------------------

forHabNetwork <- raster::merge(nfi_data_rast_raster, user_woodland_raster)

plot(forHabNetwork)

# Find centroid of target woodland ----------------------------------------
user_woodland_3857_centroid_SP <- user_woodland_sf_3857 |>
  sf::st_centroid() |>
  sf::as_Spatial()


# Convert occs_sf to SP ---------------------------------------------------
occs_sp <- occs_sf |>
  sf::st_transform(crs = sf::st_crs(3857)) |>
  sf::as_Spatial()


# Determine passages ------------------------------------------------------
forHabNetwork_transLayer <- gdistance::transition(x = forHabNetwork, transitionFunction = mean, directions = 8)

passage_tl <- gdistance::passage(x = forHabNetwork_transLayer,
                                 origin = occs_sp,
                                 goal = user_woodland_3857_centroid_SP,
                                 theta = 15)
passage_tl <- raster::clamp(passage_tl, lower = 0.005, useValues = FALSE)


# Find shortest path based on forest habitat network ----------------------
shortPath_tl <- gdistance::shortestPath(x = forHabNetwork_transLayer,
                                        origin = occs_sp,
                                        goal = user_woodland_3857_centroid_SP, 
                                        output = "SpatialLines")



# Find shortest path based on passage raster ------------------------------
passage_tl_transLayer <- gdistance::transition(x = passage_tl, transitionFunction = mean, directions = 8)

shortPath_tl_pass <- gdistance::shortestPath(x = passage_tl_transLayer,
                                             origin = occs_sp,
                                             goal = user_woodland_3857_centroid_SP, 
                                             output = "SpatialLines")




# Plot gdistance outputs --------------------------------------------------

# Get origin coordinates
target <- sp::coordinates(user_woodland_3857_centroid_SP)
origin <- sp::coordinates(occs_sp)


plot(forHabNetwork)
plot(passage_tl, add = TRUE)
# lines(shortPath_tl)
lines(shortPath_tl_pass)
text(origin[1] - 50, origin[2] - 50, "Origin")
text(target[1] + 50, target[2] + 50, "Target")



# Convert to sf objects ---------------------------------------------------
passage_sf <- passage_tl |>
  sf::st_as_sf()

shortPath_tl_pass_sf <- shortPath_tl_pass |>
  sf::st_as_sf()


# Measure distance of shortest path ---------------------------------------
shortPath_tl_pass_sf_length <- sf::st_length(shortPath_tl_pass_sf)


# Plot leaflet map --------------------------------------------------------
leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addRasterImage(x = forHabNetwork, colors = landscape_raster_cols, opacity = 0.8) |>
  leaflet::addMarkers(lng = occs_df$lng, lat = occs_df$lat)
















