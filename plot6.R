
### read main data
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))
###libs
library(ggplot2)
library(tidyr)
### Prep data
baltimoreVehicle <- NEI[NEI$fips == "24510",]
baltimoreVehicle <-
      baltimoreVehicle[baltimoreVehicle$type == "ON-ROAD",]
bv <- aggregate(Emissions ~ year, baltimoreVehicle, FUN = sum)

LAVehicle <- NEI[NEI$fips == "06037",]
LAVehicle <- LAVehicle[LAVehicle$type == "ON-ROAD", ]
LAV <- aggregate(Emissions ~ year, LAVehicle, FUN = sum)
df <- merge(bv, LAV, by = 'year')
names(df) <- c('year', 'Baltimore', 'Los Angeles')
df <-
      gather(
            data = df,
            key = city,
            value = value,
            'Baltimore':'Los Angeles'
      )
df$year <- factor(as.character(df$year))
### Plot
png('plot6.png',width = 500,height = 500,unit= 'px')

ggplot(df, aes(x = year, y = value, group = city)) +
      geom_bar(stat = 'identity', aes(fill = city)) +
      facet_grid(. ~ city) +
      ggtitle(label = 'comparing' ~ pm[25] ~ 'gas emissions of two below cities between 1999 to 2008 ') +
      ylab('Tons of gas')

dev.off()
