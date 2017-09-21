# Week 2 Programming Assignment
# Part 3
corr <- function(directory, threshold = 0) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    ## NOTE: Do not round the result!
    
    ## course link: https://www.coursera.org/learn/r-programming/supplement/amLgW/programming-assignment-1-instructions-air-pollution
    
    ## Test cases
    ## cr <- corr("specdata", 150)
    ## head(cr)
    ## [1] -0.01895754 -0.14051254 -0.04389737 -0.06815956 -0.12350667 -0.07588814
    ## summary(cr)
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -0.21057 -0.04999  0.09463  0.12525  0.26844  0.76313
    ## cr <- corr("specdata", 400)
    ## head(cr)
    ## [1] -0.01895754 -0.04389737 -0.06815956 -0.07588814  0.76312884 -0.15782860
    ## summary(cr)
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -0.17623 -0.03109  0.10021  0.13969  0.26849  0.76313
    ## cr <- corr("specdata", 5000)
    ## summary(cr)
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ## 
    ## length(cr)
    ## [1] 0
    ## cr <- corr("specdata")
    ## summary(cr)
    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ## -1.00000 -0.05282  0.10718  0.13684  0.27831  1.00000
    ## length(cr)
    ## [1] 323
    
    resultData <- vector("numeric")
    
    for (fileName in list.files(directory)) {
        fileFullyQualifiedName <- file.path(directory, fileName)
        monitorData <- read.csv(fileFullyQualifiedName)
        completeMonitorData <- monitorData[complete.cases(monitorData),]
        if (nrow(completeMonitorData) > threshold) {
            sulfateData <- completeMonitorData[["sulfate"]]
            nitrateData <- completeMonitorData[["nitrate"]]
            resultData <- c(resultData, cor(sulfateData, nitrateData))
        }
    }
    
    resultData
}