## Exploratory Data Analysis
## Course Project 2
## Question 3
## Of the four types of sources indicated by the type (point, nonpoint, onroad, 
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999-2008 for Baltimore City? 
## Which have seen increases in emissions from 1999-2008? 
## Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Retrieve just the 1999 baltimore data
baltimore_data1999 <- subset(summary_data, fips == "24510" & year == 1999)
baltimore_data2008 <- subset(summary_data, fips == "24510" & year == 2008)

## Calculate the total emissions per source for each year
baltimore_emissions_by_source1999 <- tapply(baltimore_data1999$Emissions, baltimore_data1999$type, sum)
baltimore_emissions_by_source2008 <- tapply(baltimore_data2008$Emissions, baltimore_data2008$type, sum)

## Plot the Baltimore total PM2.5 emissions from all sources for each year
barplot(baltimore_yearly_totals, xlab="Year", ylab="Baltimore Total PM2.5 Emission [tons]")

## Save the plot to an image file
dev.copy(png, filename="question2_plot.png", width=480, height=480)
dev.off()