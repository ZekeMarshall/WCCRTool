# Site Statuses -----------------------------------------------------------

site_statuses <- c(
  "Newly Planted Woodland" = "new.woodland",
  "Developing Woodland (Open Canopy)" = "developing.woodland",
  "Mature Woodland (Closed Canopy)" = "mature.woodland",
  "Ancient Woodland" = "ancient.woodland"
)

# NVC Woodlands -----------------------------------------------------------

nvc_woodlands <- c(
  "W1 Salix cinerea - Galium palustre" = "W1",
  "W2 Salix cinerea - Betula pubescens - Phragmites australis" = "W2",
  "W2a Alnus glutinosa - Filipendula ulmaria sub-community" = "W2a",
  "W2b Sphagnum sub-community" = "W2b",
  "W3 Salix pentandra - Carex rostrata" = "W3",
  "W4 Betula pubescens - Molinia caerulea" = "W4",
  "W4a Dryopteris dilatata - Rubus fruticosus sub-community" = "W4a",
  "W4b Juncus effusus sub-community" = "W4b",
  "W4c Sphagnum sub-community" = "W4c",
  "W5 Alnus glutinosa - Carex paniculata" = "W5",
  "W5a Phragmites australis sub-community" = "W5a",
  "W5b Lysimachia vulgaris sub-community" = "W5b",
  "W5c Chrysosplenium oppositifolium sub-community" = "W5c",
  "W6 Alnus glutinosa - Urtica dioica" = "W6",
  "W6a Typical sub-community" = "W6a",
  "W6b Salix fragilis sub-community" = "W6b",
  "W6c Salix viminalis - Salix triandra sub-community" = "W6c",
  "W6d Sambucus nigra sub-community" = "W6d",
  "W6e Betula pubescens sub-community" = "W6e",
  "W7 Alnus glutinosa - Fraxinus excelsior - Lysimachia nemorum" = "W7",
  "W7a Urtica dioica sub-community" = "W7a",
  "W7b Carex remota- Cirsium palustre sub-community" = "W7b",
  "W7c Deschampsia cespitosa sub-community" = "W7c",
  "W8 Fraxinus excelsior - Acer campestre - Mercurialis perennis" = "W8",
  "W8a Primula vulgaris - Glechoma hederacea sub-community" = "W8a",
  "W8b Anemone nemorosa sub-community" = "W8b",
  "W8c Deschampsia cespitosa sub-community" = "W8c",
  "W8d Hedera helix sub-community" = "W8d",
  "W8e Geranium robertianum sub-community" = "W8e",
  "W8f Allium ursinum sub-community" = "W8f",
  "W8g Teucrium scorodonia sub-community" = "W8g",
  "W9 Fraxinus excelsior - Sorbus aucuparia - Mercurialis perennis" = "W9",
  "W9a Typical sub-community" = "W9a",
  "W9b Crepis paludosa sub-community" = "W9b",
  "W10 Quercus robur - Pteridum aquiliunum - Rubus fruticosus" = "W10",
  "W10a Typical sub-community" = "W10a",
  "W10b Anemone nemorosa sub-community" = "W10b",
  "W10c Hedera helix sub-community" = "W10c",
  "W10d Holcus lanatus sub-community" = "W10d",
  "W10e Acer pseudoplatanus - Oxalis acetosella sub-community" = "W10e",
  "W11 Quercus petraea - Betula pubescens - Oxalis acetosella" = "W11",
  "W11a Dryopteris dilatata sub-community" = "W11a",
  "W11b Blechnum spicant sub-community" = "W11b",
  "W11c Anemone nemorosa sub-community" = "W11c",
  "W11d Stellaria holostea - Hypericium pulchrum sub-community" = "W11d",
  "W12 Fagus sylvatica - Mercurialis perennis" = "W12",
  "W12a Mercurialis perennis sub-community" = "W12a",
  "W12b Sanicula europaea sub-community" = "W12b",
  "W12c Taxus baccata sub-community" = "W12c",
  "W13 Taxus baccata" = "W13",
  "W13a Sorbus aria sub-community" = "W13a",
  "W13b Mercurialis perennis sub-community" = "W13b",
  "W14 Fagus sylvatica - Rubus fruticosus" = "W14",
  "W15 Fagus sylvatica - Deschampsia flexuosa" = "W15",
  "W16 Quercus spp. - Betula spp. - Deschampsia flexuosa" = "W16",
  "W16a Quercus robur sub-community" = "W16a",
  "W16b Vaccinium myrtillus - Dryopteris dilatata sub-community" = "W16b",
  "W17 Quercus petraea - Betula pubescens - Dicranum majus" = "W17",
  "W17a Isothecium myosuroides - Diplophyllum albicans sub-community" = "W17a",
  "W17b Typical sub-community" = "W17b",
  "W17c Anthoxanthum odoratum - Agrostis capillaris sub-community" = "W17c",
  "W17d Rhytidiadelphus triquetrus sub-community" = "W17d",
  "W18 Pinus sylvestris - Hylocomium splendens" = "W18",
  "W18a Erica cinerea - Goodyera repens sub-community" = "W18a",
  "W18b Vaccinium myrtillus - Vaccinium vitis-idaea sub-community" = "W18b",
  "W18c Luzula pilosa sub-community" = "W18c",
  "W18d Sphagnum capillifolium - Erica tetralix sub-community" = "W18d",
  "W18e Scapania gracilis sub-community" = "W18e"
)



# Map types for Leaflet ---------------------------------------------------

# leaflet::providers
map_types <- c("OpenStreetMap",
               "Esri.WorldImagery")


# Map color scheme --------------------------------------------------------

AW_color <- "#627193"
OW_color <- "#ad4c48"
road_color <- "#7a7a7a"
railways_color <- "#000000"
rivers_color <- "#627193"
urban_color <- "#7a7a7a"
site_color <- "#ad9f48"
searchArea_color <- "#000000"


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