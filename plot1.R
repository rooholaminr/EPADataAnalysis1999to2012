# National Emissions Inventory database
#fine particulate matter pollution in the United states over the 10-year period 1999-2008
#read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))

##################
library(RColorBrewer)
png('plot1.png',
    width = 500,
    height = 500,
    units = 'px')
SummedByYear <-
      tapply(NEI$Emissions, factor(NEI$year), sum, na.rm = T) / 10 ^ 6 #let's show with millions
colorVector1 <- brewer.pal(length(SummedByYear), 'GnBu')
bp <-
      barplot(
            SummedByYear,
            col = colorVector1,
            main = 'Total pm25 Emissions by year',
            xlab = 'year',
            ylab = 'million Tons of Emmission'
      )
text(
      bp,
      SummedByYear + 0.4 * sign(SummedByYear),
      labels = round(SummedByYear, 4),
      xpd = TRUE
)
dev.off()
