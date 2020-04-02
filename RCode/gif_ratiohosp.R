rm(list=ls())

library(dplyr)
library(sf)
library(cartography)
library(magick)
library(colorspace)



# Input
load("CUSTOM/COVIDEsp.RData")
load("CUSTOM/Pop2019_Eurostat.RData")

#Hextiles
hextiles <- st_read("CUSTOM/esp_ccaa_hexgrid.gpkg",
                    stringsAsFactors =F) %>%
  st_transform(3857)



#Paste Pop and create ratios
COVID <- left_join(COVIDEsp, st_drop_geometry(hextiles))
COVID <- left_join(COVID, EspPop2019_EUROSTAT %>% 
                     select(population=values,
                            geo),
                   by =c("NUTS2"="geo"))

COVID <- COVID[,c(names(COVIDEsp),"population")]


COVID$Hosp100000 <- round(100000*COVID$Hospitalizados/COVID$population,0)
COVID[COVID$Hosp100000 == 0, "Hosp100000" ] <- NA


#mapa fallecidos ----
brks <- pretty(COVID$Hosp10000)
brks <- c(0,10,25,50,100,200,250)
fechas <- unique(COVIDEsp$Fecha)
i=42
hist(COVID$Hosp10000)
length(brks)

palette <- divergingx_hcl("RdYlGn", n=7, rev=TRUE, alpha=0.6)
palette <- scales::alpha(rcartocolor::carto_pal(7,"Temps"),1)


# iter----
i=1


for (i in 1:length(fechas)){
fecha <- fechas[i]
namepng <- paste0("pngs/RatioHosp_",format(fecha, "%y%m%d"),".png")
namepng
png(namepng, width = 500, height = 500, res = 96 )

  
plotmap <- left_join(hextiles,COVID 
                     %>% 
                       filter(Fecha == fecha ), "ISO2") 
par(mar=c(0,0,1,0), cex =1)
choroLayer(plotmap,var="Hosp100000", breaks = brks , col = palette[2:7], legend.pos = "n",
           colNA = palette[1] )

legend("topright", format(fecha,"%d %b"), bty="n")
legendChoro(title.txt ="por 100,000 hab.",
            pos = "left",
            values.cex = 0.8, 
            title.cex = 0.7,
            cex=1.5,
  breaks = brks, nodata=TRUE, col=palette[2:7], nodata.col = palette[1],
            nodata.txt = "Sin casos")


labelLayer(plotmap,txt="ISO2_Label", halo=FALSE)
layoutLayer(title=paste0("COVID19: Ratio Hospitalizados en España"),
            scale=FALSE,
            frame = FALSE,
            sources = "Datos: ISCIII, © Eurostat\n dieghernan.github.io/COVID"
)
dev.off()
}

rm(list=ls())
# Create gif
library(magick)
pngs<-list.files("pngs/")
RatioHosp<-pngs[grep("RatioHosp",pngs)]

 f<- image_read(paste0("pngs/",RatioHosp))
 animation1 <- image_animate(f, fps = 2, optimize = TRUE, loop=0 )
 image_write(animation1,"gifs/RatioHosp.gif")


