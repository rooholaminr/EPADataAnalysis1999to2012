# National Emissions Inventory database
#fine particulate matter pollution in the United states over the 10-year period 1999-2008
#read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))

################# ggplot2 plot of em over type regarding types

### libraries
library(tidyr)
library(dplyr)
library(ggplot2)

############## forming data
NEI.BAl <- NEI[NEI$fips == "24510",]
NEI.BAl <- NEI.BAl[, 4:6]
row.names(NEI.BAl) <- NULL

NB.df <-
      group_by(NEI.BAl, type , year) %>%  summarise(value = sum(Emissions))
NB.df$year <-
      factor(NB.df$year, levels = c('1999', '2002', '2005', '2008'))


###plot
png('plot3.png',
    width = 500,
    height = 500,
    units = 'px')

p <- ggplot(NB.df, aes(x = year, y = value, group = factor(type)))
#I could not a find a better way for labeling the increasing one
annot <-
      data.frame(
            year = '2002',
            value = 1800,
            type = factor('POINT', levels = c(
                  "NON.ROAD", "NONPOINT", "ON.ROAD", "POINT"
            )),
            lab = 'TEXT'
      )
p + geom_bar(stat = 'identity', aes(fill = type)) + facet_grid(. ~ type) + geom_text(data = annot, label = 'incresing pattern') + coord_cartesian(ylim = c(0, 2200))

dev.off()