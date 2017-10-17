## Exploratory Data Analysis
## Course Project 2
## Question 4
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999-2008?

## Read in the data from the files
summary_data <- readRDS("data/summarySCC_PM25.rds")
source_data <- readRDS("data/Source_Classification_Code.rds")

## Filter the sources to only keep coal combustion-related sources
## Assume the source name has "Coal" and "Comb" or "Combustion" in the name
coal_comb_sources <-
    source_data %>%
    filter(grepl("Coal", Short.Name)) %>% 
    filter(grepl("Comb|Combustion", Short.Name))

## Filter the summary data to only keep coal combustion-related sources
coal_comb_data <- filter(summary_data, SCC %in% coal_comb_sources$SCC)

## Calculate the total emissions per year
yearly_totals <- tapply(coal_comb_data$Emissions, coal_comb_data$year, sum)

## Plot the total PM2.5 emissions from all sources for each year
barplot(
    yearly_totals, 
    xlab="Year", 
    ylab="Total PM2.5 Emissions [tons]", 
    main="Total PM2.5 Emissions (coal combustion-related sources)")

## Save the plot to an image file
dev.copy(png, filename="question4_plot.png", width=480, height=480)
dev.off()