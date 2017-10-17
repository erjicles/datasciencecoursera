## Exploratory Data Analysis
## Course Project 2
## Question 5
## How have emissions from motor vehicle sources changed from 1999-2008 in 
## Baltimore City?

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Retrieve just the baltimore data for motor vehicles
## Assuming motor vehicle refers to onroad vehicles
baltimore_mv_data <- subset(summary_data, fips == "24510" & type == "ON-ROAD")

## Calculate the total emissions per year for Baltimore motor vehicles
baltimore_mv_yearly_totals <- 
    tapply(
        baltimore_mv_data$Emissions, 
        baltimore_mv_data$year, sum)

## Plot the Baltimore total PM2.5 emissions from all sources for each year
barplot(
    baltimore_mv_yearly_totals, 
    xlab="Year", 
    ylab="Total PM2.5 Emissions [tons]", 
    main="Baltimore Total PM2.5 Emissions (motor vehicles)")

## Save the plot to an image file
dev.copy(png, filename="question5_plot.png", width=480, height=480)
dev.off()