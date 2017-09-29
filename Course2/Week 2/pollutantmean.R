# Week 2 Programming Assignment

# Part 1
pollutantmean <- function(directory, pollutant, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'pollutant' is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the
    ## mean; either "sulfate" or "nitrate".
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return the mean of the pollutant across all monitors list
    ## in the 'id' vector (ignoring NA values)
    ## NOTE: Do not round the result!
    
    ## course link: https://www.coursera.org/learn/r-programming/supplement/amLgW/programming-assignment-1-instructions-air-pollution
    
    ## Test cases
    ## pollutantmean("specdata", "sulfate", 1:10)
    ## [1] 4.064128
    ## pollutantmean("specdata", "nitrate", 70:72)
    ## [1] 1.706047
    ## pollutantmean("specdata", "nitrate", 23)
    ## [1] 1.280833
    
    pollutantData <- vector("numeric")
    for (i in id) {
        fileName <- sprintf("%03d.csv", i)
        fileFullyQualifiedName <- file.path(directory, fileName)
        monitorData <- read.csv(fileFullyQualifiedName)
        pollutantData <- c(pollutantData, monitorData[[pollutant]])
    }
    pollutantMean <- mean(pollutantData, na.rm = TRUE)
    pollutantMean
}