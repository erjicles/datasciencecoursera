## Exploratory Data Analysis
## Course Project 2
## Question 3
## Of the four types of sources indicated by the type (point, nonpoint, onroad, 
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999-2008 for Baltimore City? 
## Which have seen increases in emissions from 1999-2008? 
## Use the ggplot2 plotting system to make a plot answer this question.
library(dplyr)
library(ggplot2)

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Get the summarized baltimore data by a series of dplyr operations
summarized_baltimore_data <- 
    
    # Start with the summary data
    summary_data %>% 
    
    # Keep only baltimore data for 1999 and 2008
    filter(fips == "24510" & (year == 1999 | year == 2008)) %>% 
    
    # Group on the type and year
    group_by(type, year) %>%
    
    # Get the total emissions per type for each year 
    summarize(total_emissions = sum(Emissions))

## Plot the Baltimore total PM2.5 emissions from 1999 to 2008 by type
g <- ggplot(
    summarized_baltimore_data, 
    aes(
        year, 
        total_emissions, 
        group=type, 
        color=type)) 
g <- g + geom_point() + geom_line() + xlab("Year")
g <- g + ylab("Total PM2.5 Emissions [tons]") 
g <- g + ggtitle("Baltimore Total PM2.5 Emissions By Type")
print(g)

## Save the plot to an image file
dev.copy(png, filename="question3_plot.png", width=480, height=480)
dev.off()