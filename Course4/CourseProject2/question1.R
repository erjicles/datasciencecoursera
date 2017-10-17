## Exploratory Data Analysis
## Course Project 2
## Question 1
## Have total emissions from PM2.5 decreased in the United States from 1999 to 
## 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission 
## from all sources for each of the years 1999, 2002, 2005, and 2008

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Calculate the total emissions per year
yearly_totals <- tapply(summary_data$Emissions, summary_data$year, sum)

## Plot the total PM2.5 emissions from all sources for each year
barplot(
    yearly_totals, 
    xlab="Year", 
    ylab="Total PM2.5 Emissions [tons]", 
    main="Total PM2.5 Emissions (all sources)")

## Save the plot to an image file
dev.copy(png, filename="question1_plot.png", width=480, height=480)
dev.off()