rm(list=ls())

library(sf)
library(dplyr)
library(cartography)
library(scales)
library(magick)


# Importa datos----
mapeocods <- read.csv("CUSTOM/Cods_ISO_ESP.csv",
                      fileEncoding = "UTF-8", 
                      stringsAsFactors = FALSE)

# ISCIII----
path <- "https://covid19.isciii.es/resources/serie_historica_acumulados.csv"

# Procesa
COVIDEsp <- read.csv(path,stringsAsFactors = F)
COVIDEsp$tmstamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S",tz = "UTC",
                           usetz = TRUE)
COVIDEsp[is.na(COVIDEsp)] <- 0
COVIDEsp[COVIDEsp$CCAA.Codigo.ISO=="ME",]$CCAA.Codigo.ISO<-"ML"
COVIDEsp<- COVIDEsp[COVIDEsp$Fecha != "",]
COVIDEsp$Fecha <- as.Date(COVIDEsp$Fecha,
                          format = "%d/%m/%Y")
COVIDEsp$ISO2 <- paste0("ES-",COVIDEsp$CCAA.Codigo.ISO)
write.csv(COVIDEsp,"CUSTOM/COVIDEsp.csv", fileEncoding = "UTF-8")

COVID_ID <- left_join(COVIDEsp,
                      mapeocods %>% 
                        select(NUTS2,
                               ISO2, ISO2_CCAA) %>%
                        unique()
)


# Importa mapas


map <- st_read("EUROSTAT/NUTS2_3857.geojson", stringsAsFactors = FALSE) %>%
  filter(CNTR_CODE == "ES")



# Buffer Ceuta y Melilla
CMEL <- map %>% 
  filter(NUTS_ID %in% c("ES63","ES64")) %>% 
  st_buffer(dist=20*1000)
par(mar=c(0,0,0,0))

#Fallecidos
fechas <- unique(COVIDEsp$Fecha)

#mapa fallecidos ----

pretty(COVID_ID$UCI)
max(COVID_ID$UCI)

brks <- c(0,50,200,500,1000,2500)

fig <- image_graph(width = 500, height = 500, res = 96)
opar <- par(no.readonly = TRUE )
for (i in 1:length(fechas)){
  par(opar)
  
  fecha <- fechas[i]
  plotmap <- left_join(map,COVID_ID %>% 
                         filter(Fecha == fecha ),
                       by = c("NUTS_ID" = "NUTS2"))
  
  totesp <- format(sum(plotmap$UCI, na.rm = TRUE),big.mark=",")
  
  #Map
  par(mar=c(0,0,1,0), cex =1)
  
  Penins <- plotmap %>% filter(NUTS_ID != "ES70")
  Can <- plotmap %>% filter(NUTS_ID == "ES70")
  
  plot(st_geometry(Penins), col ="grey85", xlim=c(-1033390, 600015))
  legend("topleft", format(fecha,"%d %b"), bty="n")
  if (sum(plotmap$UCI, na.rm = TRUE) > 0){
    propSymbolsLayer(Penins,
                     var = "UCI",
                     col = alpha("red", 0.5),
                     fixmax = 5000,
                     border=NA,
                     legend.pos = "n",
                     inches = 0.5)
  }
  
  legendCirclesSymbols(pos="topright",
                       title.txt = paste0("Total: ",totesp),
                       inches=0.4,
                       var = brks,
                       col = alpha("red",0.5))
  
  #Inset Canarias
  keepar <- par(no.readonly = TRUE)
  par(fig = c(0.70, 0.98, 0.01, 0.4),
      new = TRUE
  )
  
  plot(st_geometry(Can), col = "grey85")
  if (sum(Can$UCI, na.rm = TRUE) > 0){
    propSymbolsLayer(Can,
                     var = "UCI",
                     col = alpha("red", 0.5),
                     fixmax = 5000,
                     border=NA,
                     legend.pos = "n",
                     inches = 0.5)
    
  }
  par(keepar)
  par(cex=1.2)
  
  
  layoutLayer(title=paste0("COVID19: UCI en España a ", format(max(COVID_ID$Fecha),"%d %b")),
              scale=FALSE,
              frame = FALSE,
              sources = "Datos: ISCIII \n© EuroGeographics para límites administrativos \nby dieghernan.github.io"
  )
}
dev.off()

animation1 <- image_animate(fig, fps = 2, optimize = TRUE, loop=0 )
image_write(animation1,"gifs/UCI.gif")



