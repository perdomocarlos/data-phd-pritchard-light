require("ggplot2")
require("reshape2")
require("dplyr")
require("stringr")

source("./R/aux.R")

ddat <- read.csv("./input/Deep_Light_NZST.csv", stringsAsFactors = FALSE)
sdat <- read.csv("./input/Shallow_Light_NZST.csv", stringsAsFactors = FALSE)

names(ddat)[names(ddat)=="Deep.Light"] <- "PAR"
names(sdat)[names(sdat)=="Shallow.Light"] <- "PAR"

deep_light <- tidy(ddat)
shallow_light <- tidy(sdat)

names(deep_light)[names(deep_light)=="PAR"] <- "Deep"
names(shallow_light)[names(shallow_light)=="PAR"] <- "Shallow"

all_light <- full_join(deep_light, shallow_light, by = 'Sdt')
head(all_light)

keep_cols <- c("Sdt", "Rdt.x", "Deep", "Shallow")
all_light <- all_light[, keep_cols]
head(all_light)
names(all_light) <- c("Sdt", "Rdt", "deep_PAR", "shallow_PAR")
all_light <- tidy_rediff(all_light)
head(all_light)
table(all_light$diff_secs) # Yep!

save(deep_light, shallow_light, all_light, file="./output/light_data.Rdata")