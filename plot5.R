# read data
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))
### libs
library(ggplot2)
### Prep Data
baltimoreVehicle <- NEI[NEI$fips == "24510",]
baltimoreVehicle <-
      baltimoreVehicle[baltimoreVehicle$type == "ON-ROAD",]
bv <- aggregate(Emissions ~ year, baltimoreVehicle, FUN = sum)
### plot
png("plot5.png",
    width = 500,
    height = 500,
    unit = "px")
ggplot(data = bv, aes(x = year, y = Emissions, size = 1)) +
      geom_line(aes(color = "orchid4")) +
      geom_point(aes(color = "orchid2")) +
      xlab("year") + ylab("Tons of Gas") +
      ggtitle(label = "Gas Emision by vehicles from 1999 to 2008") +
      theme(legend.position = "none")
dev.off()
