# Map types for Leaflet ---------------------------------------------------

# leaflet::providers
map_types <- c("OpenStreetMap",
               "Esri.WorldImagery")



# WMS Constants -----------------------------------------------------------

wms_url <- "http://www.forestdss.org.uk/geoserver/esc4/wms?"

wms_legend_url <- "http://www.forestdss.org.uk:8080/geoserver/esc4/ows?service=WMS&request=GetLegendGraphic&format=image%2Fpng&width=20&height=20&layer="

wms_layers <- c(
  "None" = "none",
  "Absolute minimum temperature" = "absmintempbaseline",
  "Accumlated Temperature (AT)" = "at",
  "Annual rainfall" = "annualrainfall",
  "Continentality (CT)" = "ct",
  "Detailed aspect method scoring (DAMS)" = "dams",
  # "Elevation" = "elevation",
  "Moisture deficit (MD)" = "md",
  "Modelled soil moisture regime (SMR)" = "smr250",
  "Modelled soil nutrient regime (SNR)" = "snr250"
)


# Species Names Constants -------------------------------------------------


species.options <- c(
  "None Selected" = "",
  "Erica cinerea (Bell Heather)" = "Erica cinerea",
  "Vaccinium myrtillus (Bilberry)" = "Vaccinium myrtillus",
  "Hyacinthoides non-scripta (Bluebell)" = "Hyacinthoides non-scripta",
  "Myrica gale (Bog Myrtle)" = "Myrica gale")

surveyData_df_init <- tibble::tribble(~Site, ~Species, ~Const, ~Cover,
                                      "Default", "Erica cinerea (Bell Heather)", "5", "6",
                                      "Default", "Vaccinium myrtillus (Bilberry)", "5", "4",
                                      "Default", "Hyacinthoides non-scripta (Bluebell)", "5", "5",
                                      "Default", "Myrica gale (Bog Myrtle)", "5", "5")