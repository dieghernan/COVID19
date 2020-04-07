

Contagios <- function(fecha) {
  library(dplyr)
  library(sf)
  library(cartography)
  library(colorspace)
  
  load("CUSTOM/COVIDEsp.Rdata")
  
  #shp
  map <- st_read("CUSTOM/esp_ccaa.gpkg", stringsAsFactors = FALSE)
  Datos <- COVIDEsp %>% filter(Fecha == fecha)
  shape <- left_join(map, Datos)


  col <- scales::alpha("limegreen", 0.8)

  
  namepng <-
    paste0("pngs/Contagios_", format(unique(shape$Fecha), "%y%m%d"), ".png")
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
  AllEsp <- sum(shape$Casos)
  legend("topleft",
         legend = c(format(unique(shape$Fecha), "%d %b"),
                    paste0("Total: ", format(AllEsp, big.mark = ","))),
         bty = "n")
  
  legend(
    "topright",
    "25 casos",
    bty = "n",
    pch = 20,
    cex = 0.7,
    pt.cex = 1,
    col = col
  )
  
  
  
  if ( max(shape$Casos) > 25) {
    set.seed(1234)
    dotDensityLayer(
      shape,
      var = "Casos",
      col = col,
      n = 25,
      pch = 20,
      cex = 0.025,
      legend.pos = "n",
    )
    
  }
  
  layoutLayer(
    title = paste0("COVID19 España: Contagios por CCAA"),
    scale = FALSE,
    frame = FALSE,
    sources = "Datos: ISCIII, © Eurostat (Límites geográficos)\n dieghernan.github.io/COVID19"
  )
  dev.off()
}


