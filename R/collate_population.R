rm(list=ls())
library(eurostat)


#df <- search_eurostat("Population", type = "dataset", fixed = TRUE)

population<- get_eurostat("demo_r_d2jan", filters = list(age = "TOTAL",
                                                         sex = "T",
                                                         time = "2019"))
EspPop2019_EUROSTAT <- population[grep("ES", population$geo),]

save(EspPop2019_EUROSTAT,file="CUSTOM/Pop2019_Eurostat.RData")
