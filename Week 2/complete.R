# Week 2 Programming Assignment
# Part 2
complete <- function(directory, id = 1:332) {
    resultData <- data.frame("id" = id, "nobs" = vector(mode = "numeric", length = length(id)))
    for (i in id) {
        fileName <- sprintf("%03d.csv", i)
        fileFullyQualifiedName <- file.path(directory, fileName)
        monitorData <- read.csv(fileFullyQualifiedName)
        completeMonitorData <- monitorData[complete.cases(monitorData),]
        resultData$nobs[resultData$id == i] <- nrow(completeMonitorData)
    }
    resultData
}