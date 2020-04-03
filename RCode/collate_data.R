rm(list=ls())

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
out <- paste0("CUSTOM/COVIDEsp_",format(max(COVIDEsp$Fecha),"%Y%m%d"),".csv")
write.csv(COVIDEsp,out, fileEncoding = "UTF-8")
save(COVIDEsp, file = "CUSTOM/COVIDEsp.RData")
print(max(COVIDEsp$Fecha))



