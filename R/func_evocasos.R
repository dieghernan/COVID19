Evocasos <- function(fecha) {
  library(dplyr)
  library(sf)
  library(cartography)
  library(colorspace)

  #Hextiles
  hextiles <- st_read("assets/data/esp_ccaa_hexgrid.gpkg",
                      stringsAsFactors = F) %>%
    st_transform(3857)
  #tileEsp
  geom <- st_sfc(st_point(c(578006, 5255640)), crs = st_crs(hextiles)) %>%
    st_buffer(150000, endCapStyle = "SQUARE")
  
  ES <- st_sf(ISO2="ES",
              ISO2_Label="ES", geom, stringsAsFactors = F)
  
  hextiles <- rbind(hextiles %>% select(ISO2, ISO2_Label),ES)
  
  Datos <- COVIDEsp %>% filter(Fecha == fecha)
  
  shape <- left_join(hextiles, Datos)
  
  
  brks <- c(-Inf,-.2,-.05, 0,.05,.2,Inf)
  palette <- divergingx_hcl(7, palette = "Geyser", alpha = 0.9)
  
  
  
  namepng <-
    paste0("assets/png/RatioNuevosCasos/RatioNuevosCasos_", format(unique(shape$Fecha), "%y%m%d"), ".png")
  png(namepng,
      width = 500,
      height = 500,
      res = 96)
  par(mar = c(0, 0, 1, 0))
  plot(st_geometry(shape), col="grey80", border=NA)
  choroLayer(
    shape,
    var = "Casos_Porcvar",
    border = "grey50",
    legend.values.rnd = 4,
    breaks = brks ,
    col = palette,
    legend.pos = "n",
    colNA = "grey80",
    add=T
  )
  
  legend("topleft", format(unique(shape$Fecha), "%d %b"), bty = "n")
  legendChoro(
    title.txt = "% nuevos casos dia\nvs. % dia anterior",
    pos = "left",
    values.cex = 0.8,
    title.cex = 0.7,
    cex = 1.5,
    col = palette,
    breaks = c("min","-20%","-10%","-","10%","20%","max"),
    nodata = FALSE,
  )
  
  
  labelLayer(shape , txt = "ISO2_Label")
  
  
  layoutLayer(
    title = paste0("COVID19 España: Evolución variación diaria de casos"),
    scale = FALSE,
    frame = FALSE,
    sources = "Datos: ISCIII, Eurostat (Poblacion a Ene2019)\n dieghernan.github.io/COVID19"
  )
  dev.off()
}