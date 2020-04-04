RatioHosp <- function(fecha) {
  library(dplyr)
  library(sf)
  library(cartography)
  library(colorspace)
  load("CUSTOM/Pop2019_Eurostat.RData")
  
  #Hextiles
  hextiles <- st_read("CUSTOM/esp_ccaa_hexgrid.gpkg",
                      stringsAsFactors = F) %>%
    st_transform(3857)
  
  Datos <- COVIDEsp %>% filter(Fecha == fecha)
  
  shape <- left_join(hextiles, Datos) %>%
    left_join(EspPop2019_EUROSTAT, by = c("NUTS2" = "geo"))
  
  shape$Hosp100000 <-
    round(100000 * shape$Hospitalizados / shape$values, 0)
  
  # finalshape
  finalshape <- shape %>% select(Label = ISO2_Label,
                                 Hosp100000)
  
  #A nivel nacional
  popESP <- EspPop2019_EUROSTAT %>%
    filter(geo == "ES") %>%
    select(values) %>% as.integer()
  Hosp100000 <- 100000 * sum(shape$Hospitalizados) / popESP
  
  df <- data.frame(Label = "ES",
                   Hosp100000 = Hosp100000)
  
  geom <- st_sfc(st_point(c(578006, 5255640)), crs = 3857) %>%
    st_buffer(150000, endCapStyle = "SQUARE")
  
  all <- st_sf(df, geom)
  #Añade datos ESP
  plotmap <- rbind(finalshape, all)
  
  plotmap[plotmap$Hosp100000 == 0, "Hosp100000"] <- NA
  
  #Plot
  brks <- c(1, 10, 25, 50, 100, 200, 250,500)
  palette <- divergingx_hcl(8, palette = "Geyser", alpha = 0.9)
  
  
  namepng <-
    paste0("pngs/RatioHosp_", format(unique(shape$Fecha), "%y%m%d"), ".png")
  png(namepng,
      width = 500,
      height = 500,
      res = 96)
  par(mar = c(0, 0, 1, 0))
  choroLayer(
    plotmap,
    var = "Hosp100000",
    border = "grey50",
    breaks = brks ,
    col = palette[-1],
    legend.pos = "n",
    colNA = palette[1]
  )
  
  legend("topleft", format(unique(shape$Fecha), "%d %b"), bty = "n")
  legendChoro(
    title.txt = "por 100,000 hab.",
    pos = "left",
    values.cex = 0.8,
    title.cex = 0.7,
    cex = 1.5,
    breaks = brks,
    nodata = TRUE,
    col = palette[-1],
    nodata.col = palette[1],
    nodata.txt = "0"
  )
  
  
  labelLayer(plotmap %>% filter(Label != "ES"), txt = "Label")
  labelLayer(plotmap %>% filter(Label == "ES"),
             txt = "Label",
             cex = 1)
  
  layoutLayer(
    title = paste0("COVID19 España: Hospitalizados por CCAA"),
    scale = FALSE,
    frame = FALSE,
    sources = "Datos: ISCIII, Eurostat (Poblacion a Ene2019)\n dieghernan.github.io/COVID19"
  )
  dev.off()
}