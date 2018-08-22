## Course Project 1

## Read the relevant data from the file
## Read only data for 2/1/2007 - 2/2/2007
## Fields are delimited with ";"
## Empty fields are coded with "?"
## The date range starts on row 66638
## The date range ends on row 69517
pow_data <- read.csv(
    "household_power_consumption.txt", 
    sep=";", 
    na.strings="?", 
    skip=66637, 
    nrows=69517-66638+1, 
    header=F)

## Get the header
header_row <- read.csv(
    "household_power_consumption.txt", 
    sep=";", 
    na.strings="?", 
    header=T, 
    skip=0, 
    nrows=1)
names(pow_data) <- names(header_row)

## Add a date column
pow_data$DateAsDate <- as.Date(pow_data$Date, "%d/%m/%Y")

## Add a datetime column
pow_data$DateTime <- strptime(
    paste(pow_data$Date, pow_data$Time), 
    "%d/%m/%Y %H:%M:%S")

