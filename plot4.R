#read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))
SCC <- readRDS(file.path('pm25em', 'Source_Classification_Code.rds'))
##################
library(RColorBrewer)
#################
png('plot4.png',
    width = 500,
    height = 500,
    units = 'px')
combustVec <- grep('comb', SCC$SCC.Level.One, ignore.case = T)
coalVec <- grep('coal', SCC$SCC.Level.Four, ignore.case = T)
coalcomb <- c(combustVec, coalVec)
subdata <- SCC[coalcomb,]$SCC
CRdata <- NEI[NEI$SCC %in% subdata, c(4, 6)]
CRdata <- tapply(CRdata$Emissions, CRdata$year, sum, na.rm = T)
colvec <- brewer.pal(4, 'Purples')
mybar <-
      barplot(
            CRdata,
            col = colvec,
            main = 'emissions from coal combustion-related sources',
            ylab = ' Tons of gas ',
            xlab = 'year'
      )
text(mybar , CRdata / 2, round(CRdata, 3), cex = 1)
dev.off()