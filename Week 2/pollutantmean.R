# Week 2 Programming Assignment

# Part 1
pollutantmean <- function(directory, pollutant, id = 1:332) {
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