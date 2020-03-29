rm(list=ls())
library(dplyr)

# Datadista

# Fallecidos
path <- "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos_long.csv"

fallecidos <- read.csv(path,
                       encoding = "UTF-8",
                       stringsAsFactors = F)
fallecidos$TMSTAMP <- format(Sys.time(), "%Y-%m-%d %H:%M:%S",tz = "UTC", usetz = TRUE)

#NUTS
mapeo <- read.csv("CUSTOM/mapeonuts.csv", stringsAsFactors = FALSE)

fallecidos <- left_join(fallecidos, mapeo, by = "cod_ine")


CCAAs <- fallecidos %>% select(CCAA, cod_ine) %>% unique()
NUTS2 <- st_read("EUROSTAT/NUTS2_3857.geojson", stringsAsFactors = FALSE) %>% 
  st_drop_geometry() %>% filter(CNTR_CODE == "ES")

join <- distance_left_join(CCAAs,NUTS2, by= c("CCAA" = "NUTS_NAME"))

CCAAs$index <- unlist(lapply(1:nrow(CCAAs), function(x)
  max(0,grep(CCAAs[x,]$CCAA, NUTS2$NUTS_NAME))
  ))

grepl(CCAAs[1,]$CCAA, NUTS2$NUTS_NAME)

write.csv(fallecidos,"DATADISTA/fallecidos.csv", row.names = F)

