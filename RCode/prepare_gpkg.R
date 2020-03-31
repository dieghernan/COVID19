rm(list=ls())

library(sf)
library(dplyr)

#https://dieghernan.github.io/201906_Beautiful2/

SPAIN <- st_read(
  "EUROSTAT/NUTS2_3857.geojson",
  stringsAsFactors = FALSE
) %>%
  subset(CNTR_CODE == "ES")


# Move Canary Islands
CAN <- SPAIN %>% subset(NUTS_ID == "ES70")
CANNEW <- st_sf(st_drop_geometry(CAN),
                geometry = st_geometry(CAN) + c(550000*3.7, 920000)
)
st_crs(CANNEW) <- st_crs(SPAIN)
# New version of Spain
SPAINV2 <- rbind(
  SPAIN %>%
    subset(NUTS_ID != "ES70"),
  CANNEW
)

mapeocods <- read.csv("CUSTOM/Cods_ISO_ESP.csv",
                      fileEncoding = "UTF-8", 
                      stringsAsFactors = FALSE)

CCAA <- mapeocods %>% 
  select(NUTS2_Label,NUTS2,ISO2, ISO2_CCAA) %>%
  unique()

SPAINV3 <- left_join(SPAINV2 %>% select(NUTS_ID), CCAA, by =c("NUTS_ID"="NUTS2"))


st_write(SPAINV3,"CUSTOM/esp_ccaa.gpkg")
