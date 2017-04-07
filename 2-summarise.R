require("ggplot2")
require("reshape2")
require("dplyr")
require("stringr")

source("./R/aux.R")
load("./output/light_data.Rdata")

str(all_light)
summary(all_light$deep_PAR)
summary(all_light$shallow_PAR)

## Summary
all_light$Date <- format(all_light$Rdt, "%Y-%m-%d")
all_light_g <- group_by(all_light, Date)
all_light_s <- summarise(all_light_g, deep_mean = mean(deep_PAR, na.rm = T),
                          shal_mean = mean(shallow_PAR, na.rm = T), 
                          deep_n = length(na.omit(deep_PAR)),
                          shal_n = length(na.omit(shallow_PAR)),
                          deep_dose = sum(deep_PAR*diff_secs, na.rm = T)/1000000,
                          shal_dose = sum(shallow_PAR*diff_secs, na.rm = T)/1000000)

table(all_light_s$deep_n)
table(all_light_s$shal_n)
# 288 represents a full day
# Set anything with less than 250 to NA (about 3 hours missing)
deep_indx <- all_light_s$deep_n < 250
all_light_s[deep_indx, c("deep_mean", "deep_dose")] <- NA
shal_indx <- all_light_s$shal_n < 250
all_light_s[shal_indx, c("shal_mean", "shal_dose")] <- NA
all_light_s <- data.frame(all_light_s)

all_light_s$Rdt <- as.POSIXct(strptime(all_light_s$Date, "%Y-%m-%d"))

## Write some CSVs
write.csv(all_light, file = "./output/raw_data.csv", row.names = FALSE)
write.csv(all_light_s, file = "./output/daily_dose.csv", row.names = FALSE)

## Save Data
daily_summary <- all_light_s
save(all_light, daily_summary, file="./output/light_data.Rdata")
