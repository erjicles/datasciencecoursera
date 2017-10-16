## Exploratory Data Analysis
## Course Project 2
## Question 2
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? 
## Use the base plotting system to make a plot answering this question.

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Retrieve just the baltimore data
baltimore_data <- subset(summary_data, fips == "24510")

## Calculate the total emissions per year for Baltimore
baltimore_yearly_totals <- tapply(baltimore_data$Emissions, baltimore_data$year, sum)

## Plot the Baltimore total PM2.5 emissions from all sources for each year
barplot(baltimore_yearly_totals, xlab="Year", ylab="Baltimore Total PM2.5 Emission [tons]")

## Save the plot to an image file
dev.copy(png, filename="question2_plot.png", width=480, height=480)
dev.off()