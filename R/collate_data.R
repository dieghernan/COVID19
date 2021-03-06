rm(list = ls())
library(dplyr)
library(stringr)

# ISCIII----
path <-
  "https://covid19.isciii.es/resources/serie_historica_acumulados.csv"


# Procesa
COVIDEsp <- read.csv(path, stringsAsFactors = F)
names(COVIDEsp) <- c("CCAA.Codigo.ISO","Fecha","Casos","PCR","TestAc",
                     "Hospitalizados","UCI","Fallecidos")

COVIDEsp <- COVIDEsp[COVIDEsp$Fecha != "",]
COVIDEsp$Fecha <- as.Date(COVIDEsp$Fecha,
                          format = "%d/%m/%Y")

COVIDEsp$Fecha <- COVIDEsp[COVIDEsp$Fecha > "01Jan2020"d)

# Backup
out <-
  paste0("CUSTOM/COVIDEsp_", format(max(COVIDEsp$Fecha), "%Y%m%d"), ".csv")
write.csv(COVIDEsp, out, fileEncoding = "UTF-8", row.names = F)

COVIDEsp$Fecha <- as.Date(COVIDEsp$Fecha,
                          format = "%d/%m/%Y")
COVIDEsp[is.na(COVIDEsp)] <- 0
COVIDEsp$Casos_Activos <-
  COVIDEsp$Casos - COVIDEsp$Fallecidos - COVIDEsp$Recuperados

#COVIDEsp[COVIDEsp$CCAA.Codigo.ISO == "ME",]$CCAA.Codigo.ISO <- "ML"
COVIDEsp$ISO2 <- paste0("ES-", COVIDEsp$CCAA.Codigo.ISO)

COVIDEsp <- COVIDEsp %>% mutate(CCAA.Codigo.ISO = "ES",
                                ISO2 = "ES") %>%
  group_by(CCAA.Codigo.ISO,
           ISO2,
           Fecha) %>%
  summarise_all(sum) %>% as.data.frame() %>%
  bind_rows(COVIDEsp) %>% arrange(ISO2, Fecha)

evoluciones <- function(var, tabla) {
  newvar <- paste0(var, "_24h")
  newvar2 <- paste0(var, "_Porc24h")
  newvar3 <- paste0(var, "_Porcvar")
  oldnames <- names(tabla)
  try <- tabla[order(tabla$ISO2, tabla$Fecha), ]
  
  try$var1 <- unlist(tapply(
    try[, c(var)],
    INDEX = try$ISO2,
    FUN = function(x)
      c(0, diff(as.numeric(x)))
  ))
  
  try$var2 <- try$var1 / (try[, c(var)] - try$var1)
  
  try$var2 <- unlist(tapply(
    try[, c(var)],
    INDEX = try$ISO2,
    FUN = function(x)
      c(0, diff(as.numeric(x)))
  ))
  
  try$var2 <- try$var2 / (try[, c(var)] - try$var2)
  
  try[!is.finite(try$var2), ]$var2 <- NA
  try$var3 <- unlist(tapply(
    try$var2,
    INDEX = try$ISO2,
    FUN = function(x)
      c(0, diff(as.numeric(x)))
  ))
  try$var3 <- round(try$var3 / (try$var2 - try$var3), 6)
  try[!is.finite(try$var3), ]$var3 <- NA
  names(try) <- c(oldnames, newvar, newvar2, newvar3)
  return(try)
}



COVIDEsp <- evoluciones("Casos", COVIDEsp)
COVIDEsp <- evoluciones("Hospitalizados", COVIDEsp)
COVIDEsp <- evoluciones("UCI", COVIDEsp)
COVIDEsp <- evoluciones("Fallecidos", COVIDEsp)
COVIDEsp <- evoluciones("Recuperados", COVIDEsp)
COVIDEsp <- evoluciones("Casos_Activos", COVIDEsp)
COVIDEsp$tmstamp <-
  format(Sys.time(),
         "%Y-%m-%d %H:%M:%S",
         tz = "UTC",
         usetz = TRUE)

COVIDEsp <- COVIDEsp[, !(names(COVIDEsp) %in% c("X", "Y"))]

write.csv(
  COVIDEsp,
  "CUSTOM/COVIDEsp_actual.csv",
  fileEncoding = "UTF-8",
  row.names = F
)
save(COVIDEsp, file = "CUSTOM/COVIDEsp.Rdata")
rm(list = ls())
