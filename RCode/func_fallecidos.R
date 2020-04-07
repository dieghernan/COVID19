

Fallecidos <- function(fecha) {
  library(dplyr)
  library(sf)
  library(cartography)
  library(colorspace)
  
  
  #shp
  map <- st_read("CUSTOM/esp_ccaa.gpkg", stringsAsFactors = FALSE)
  
  COVIDEsp <- read.csv("CUSTOM/COVIDEsp_actual.csv",
                       stringsAsFactors = FALSE,
                       fileEncoding = "UTF-8")
  
  COVIDEsp$Fecha <- as.Date(COVIDEsp$Fecha)
  
  Datos <- COVIDEsp %>% filter(Fecha == fecha)
  shape <- left_join(map, Datos)
  brks <- c(0, 200, 500, 1000, 2000, 5000)
  col <- scales::alpha("red2", 0.8)
  
  namepng <-
    paste0("pngs/Fallecidos_", format(unique(shape$Fecha), "%y%m%d"), ".png")
  png(
    namepng,
    width = 500,
    height = 500,
    res = 96,
    bg = "grey90"
  )
  par(mar = c(0, 0, 1, 0))
  
  plot(
    st_geometry(shape),
    col = "grey20",
    border = "grey35",
    ylim = c(4123470, 5700000)
  )
  AllEsp <- sum(shape$Fallecidos)
  legend("topleft",
         legend = c(format(unique(shape$Fecha), "%d %b"),
                    paste0("Total: ", format(AllEsp, big.mark = ","))),
         bty = "n")
  
  legend(
    "topright",
    "5 fallecidos",
    bty = "n",
    pch = 20,
    cex = 0.7,
    pt.cex = 1,
    col = col
  )
  
  
  
  if (AllEsp > 0) {
    set.seed(1234)
    dotDensityLayer(
      shape,
      var = "Fallecidos",
      col = col,
      n = 5,
      pch = 20,
      cex = 0.1,
      legend.pos = "n",
    )
    
  }
  
  layoutLayer(
    title = paste0("COVID19 España: Fallecidos por CCAA"),
    scale = FALSE,
    frame = FALSE,
    sources = "Datos: ISCIII, © Eurostat (Límites geográficos)\n dieghernan.github.io/COVID19"
  )
  dev.off()
}
