## Exploratory Data Analysis
## Course Project 2
## Question 6
## Compare emissions from motor vehicle sources in Baltimore City with emissions 
## from motor vehicle sources in Los Angeles County, California 
## (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?
library(dplyr)

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Summarize the data for Baltimore and LA County
summarized_mv_data <- 
    summary_data %>%
    
    # Filter to only keep Baltimore and LA County motor vehicle data
    filter((fips == "24510" | fips == "06037") & type == "ON-ROAD") %>%
    
    # Group the data by the region and then by the year
    group_by(fips, year) %>%
    
    # Summarize the data
    summarize(total_emissions = sum(Emissions)) %>%
    
    # Add columns to help summarize the changes
    mutate(
        # Add a column for the region name
        locale = ifelse(fips == "24510", "Baltimore City", "LA County"),
        # Add column for gross change over previous year
        gross_change = 
            total_emissions - lag(total_emissions, default=total_emissions[year=1999], order_by=year),
        # Add column for gross change since the start
        total_gross_change = 
            total_emissions - total_emissions[year==1999],
        # Add column for percent change over previous year
        year_percent_change =
            (total_emissions - lag(total_emissions, default=total_emissions[year==1999], order_by=year)) 
                / lag(total_emissions, default=total_emissions[year==1999], order_by=year),
        # Add column for percent change since the start
        percent_change =
            (total_emissions - total_emissions[year==1999]) 
                / total_emissions[year==1999]
        )

## Plot the percent changes in emissions from 1999 to 2008 by region
g <- ggplot(
    summarized_mv_data,
    aes(x = year))
g <- g + geom_point(aes(y = percent_change, group=locale, color=locale))
g <- g + geom_line(aes(y = percent_change, group=locale, color=locale))
g <- g + geom_col(
    aes(y = year_percent_change, group=locale, color=locale, fill=locale), 
    position="dodge", 
    width=0.75)
g <- g + annotate("text", x=2005, y=-0.05, label="Annual Percent Change")
g <- g + annotate("text", x=2003, y=0.2, label="Total Percent Change")
g <- g + labs(
    y = "Percent Change",
    x = "Year",
    title = "Change In PM2.5 Emissions (motor vehicles)"
)
print(g)

## Save the plot to an image file
dev.copy(png, filename="plot6.png", width=480, height=480)
dev.off()