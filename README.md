# Exploratory Data Analysis for air pollutants 1999-2008
## Coursera course project
### [Exploratory Data Analysis by Jons Hopkins University](https://www.coursera.org/learn/exploratory-data-analysis)

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National Emissions Inventory web site.

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

You can download the data here : [link](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

The zip file contains two files:

PM2.5 Emissions Data (summarySCC_PM25.rds) This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.
```
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```
* **fips** : A five-digit number (represented as a string) indicating the U.S. county
* **SCC** : The name of the source as indicated by a digit string (see source code classification table)
* **Pollutant** : A string indicating the pollutant
* **Emissions** : Amount of PM2.5 emitted, in tons
* **type** : The type of source (point, non-point, on-road, or non-road)
* **year** : The year of emissions recorded

Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

You can read each of the two files using the readRDS() function in R. For example, reading in each file can be done with the following code:
```R
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

## Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

### code for Question 1
```R

#read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))

### libs
library(RColorBrewer)

###Data Prep

SummedByYear <-
      tapply(NEI$Emissions, factor(NEI$year), sum, na.rm = T) / 10 ^ 6 #let's show with millions
colorVector1 <- brewer.pal(length(SummedByYear), 'GnBu')

### Plot
png('plot1.png',
    width = 500,
    height = 500,
    units = 'px')
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


```
### Plot for Qestion 1

<p align="center">
<img  src="https://raw.githubusercontent.com/rooholaminr/EPADataAnalysis1999to2012/master/plot1.png">
  </p>
  
  ## Question 2
  
  2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
  
  ### R code for question 2
  
  ```R
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
  
  ```
  
  ### Plot for Question 2
  
  <p align = 'center'>
  <img src ='https://raw.githubusercontent.com/rooholaminr/EPADataAnalysis1999to2012/master/plot2.png'>
  </p>
  
  ## Question 3
  
  3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
  
  
  ### R code for question 3
  
 ```R
 #read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))


### libs
library(tidyr)
library(dplyr)
library(ggplot2)

### Prep data
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
 
 
 ```
 
 ### Plot for question 3
 
 <p align = 'center'>
  <img src = 'https://raw.githubusercontent.com/rooholaminr/EPADataAnalysis1999to2012/master/plot3.png'>
 </p>
 
 
 ## Question 4
 
 4.Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

### R code for question 4

```R
#read main data :
NEI <- readRDS(file.path('pm25em', 'summarySCC_PM25.rds'))
SCC <- readRDS(file.path('pm25em', 'Source_Classification_Code.rds'))
### libs
library(RColorBrewer)
### Data Prep
combustVec <- grep('comb', SCC$SCC.Level.One, ignore.case = T)
coalVec <- grep('coal', SCC$SCC.Level.Four, ignore.case = T)
coalcomb <- c(combustVec, coalVec)
subdata <- SCC[coalcomb,]$SCC
CRdata <- NEI[NEI$SCC %in% subdata, c(4, 6)]
CRdata <- tapply(CRdata$Emissions, CRdata$year, sum, na.rm = T)

### Plot
png('plot4.png',
    width = 500,
    height = 500,
    units = 'px')
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
```

### Plot for question 4

<p align = 'center'>
  <img src = 'https://raw.githubusercontent.com/rooholaminr/EPADataAnalysis1999to2012/master/plot4.png'
</p>
  
 ## Question 5
 
 5.How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## R code for question 5

**since this plot had to be repeated in next question I decided to do it in a different way, I know that *year* parameter is not continuous.**

```R
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
```

### plot for question 5
<p align = 'center'>
  <img src = 'https://raw.githubusercontent.com/rooholaminr/EPADataAnalysis1999to2012/master/plot5.png'>
</p>

## Question 6

6.Compare emissions from motor vehicle sources in **Baltimore** City with emissions from motor vehicle sources in **Los Angeles** County, California (fips=="06037"). Which city has seen greater changes over time in motor vehicle emissions?

### R code for question 6

```R
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
```

### plot for question 6

<p align = 'center'>
 <img src = 'https://raw.githubusercontent.com/rooholaminr/EPADataAnalysis1999to2012/master/plot6.png'>
</p>

