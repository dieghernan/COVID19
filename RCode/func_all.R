



AllCases <- function(fecha) {
  library(dplyr)
  library(sf)
  library(cartography)
  library(colorspace)
  
  load("CUSTOM/COVIDEsp.RData")
  
  
  #shp
  map <- st_read("CUSTOM/esp_ccaa.gpkg", stringsAsFactors = FALSE)
  Datos <- COVIDEsp %>% filter(Fecha == fecha)
  Datos$Activos <- Datos$Casos - Datos$Fallecidos-Datos$Recuperados 
  shape <- left_join(map, Datos)
  variables <-
    c("Fallecidos",
      "Activos",
      "Recuperados")
  labs <- c("Fallecidos",
            "Casos activos",
            "Recuperados")
  
  # See if no 0
  zeros <- c(
    sum(Datos$Fallecidos),
    sum(Datos$Activos),
    sum(Datos$Recuperados)
  )
  
  if (length(zeros[zeros > 0]) > 1) {
    namepng <-
      paste0("pngs/Casos_", format(unique(shape$Fecha), "%y%m%d"), ".png")
    png(namepng,
        width = 500,
        height = 500,
        res = 96)
    par(mar = c(0, 0, 1, 0))
    plot(
      st_geometry(shape),
      col = "grey90",
      border = "grey35",
      ylim = c(4123470, 5750000)
    )

    pal <-
      c("black",
        "indianred2",
        "limegreen"
      ) 
    pal <- scales::alpha(pal,0.8)

    waffleLayer(
      shape,
      var = variables[zeros > 0],
      cellvalue = 500,
      cellsize = 18000,
      add = TRUE,
      border = NA,
      ncols = 4,
      col = pal[zeros > 0],
      legend.pos = "topright",
      legend.values.cex = 0.7,
      legend.title.cex = 0.1,
      labels = labs[zeros > 0],
      legend.title.txt = "",
      celltxt = "1 celda = 500 personas"
    )
    AllEsp <- sum(shape$Casos)
    legend("topleft",
           legend = c(format(unique(shape$Fecha), "%d %b"),
                      paste0(
                        "Total Casos: ", format(AllEsp, big.mark = ",")
                      )),
           bty = "n")
    
    
    layoutLayer(
      title = paste0("COVID19 España: Casos por CCAA"),
      scale = FALSE,
      frame = FALSE,
      sources = "Datos: ISCIII, © Eurostat (Límites geográficos)\n dieghernan.github.io/COVID19"
    )
    dev.off()
  }
}



