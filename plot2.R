#read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))
###libs
library(RColorBrewer)
### Data Prep
NEI.BAl <- NEI[NEI$fips == "24510",]
SummedByYear.Bal <-
      tapply(NEI.BAl$Emissions, factor(NEI.BAl$year), sum, na.rm = T)  #let's show with millions
colorVector2 <- brewer.pal(length(SummedByYear.Bal), 'OrRd')
### Plot
png('plot2.png',
    width = 500,
    height = 500,
    units = 'px')
bp <-
      barplot(
            SummedByYear.Bal,
            col = colorVector2,
            main = 'Baltimore city pm25 Emissions by year',
            xlab = 'year',
            ylab = 'Tons of Emmission'
      )
text(
      bp,
      SummedByYear.Bal + 100 * sign(SummedByYear.Bal),
      labels = round(SummedByYear.Bal, 4),
      xpd = TRUE
)

dev.off()
