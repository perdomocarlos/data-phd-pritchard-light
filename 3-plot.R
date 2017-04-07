require("ggplot2")
require("reshape2")
require("dplyr")
require("stringr")

load(file="./output/light_data.Rdata")

## Plot - Raw Data
all_light_m <- melt(all_light[, c("Rdt", "deep_PAR", "shallow_PAR")], id.vars = "Rdt")
all_light_m$variableF <- factor(all_light_m$variable, levels = c("shallow_PAR", "deep_PAR"))

p1 <- ggplot(all_light_m, mapping = aes(x=Rdt, y=value))
p1 <- p1 + geom_line() + facet_grid(variableF~., scales="free_y")
p1 <- p1 + xlab("Date") + ylab("PAR (µmol / m2 / s)")
p1
ggsave(p1, filename="./figures/raw_data.png", height=10, width = 30, units="cm")


## Plot - Daily Summary
daily_summary_m <- melt(daily_summary[, c("Rdt", "deep_dose", "shal_dose")], id.vars = "Rdt")
daily_summary_m$variableF <- factor(daily_summary_m$variable, levels = c("shal_dose", "deep_dose"))

p2 <- ggplot(daily_summary_m, mapping = aes(x=Rdt, y=value))
p2 <- p2 + geom_line() + facet_grid(variableF~., scales="free_y")
p2 <- p2 + xlab("Date") + ylab("Daily Dose (mol / m2 / day)")
p2
ggsave(p2, filename="./figures/daily_dose.png", height=10, width = 30, units="cm")

