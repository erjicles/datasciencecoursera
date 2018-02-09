library(data.table)
library(dplyr)
library(quanteda)
library(lubridate)

## @knitr utilityFunctionGetLinesFromFile

## This function takes a file name, a starting line, and a maximal number of
## lines to read, and returns a vector reading those lines from the file.
getLinesFromFile <- function (fileName, startLine, n) {
    
    result <- character()
    
    con <- file(fileName, "r")
    counter <- 0
    while ( TRUE ) {
        counter <- counter + 1
        l <- readLines(con, n = 1)
        if (length(l) == 0) {
            break
        }
        if (counter >= startLine && counter < startLine + n) {
            result <- c(result, l)
        } else if (counter >= startLine + n) {
            break
        }
    }
    close(con)
    
    result
}



## @knitr utilityFunctionGetDataSample

## This function takes a file name and optionally a probability.
## It returns a vector containing a selection of lines from the file chosen at
## random according to the given probability. If a probability is not given or
## is not between 0 and 1 (inclusive), then returns all lines.
getDataSample <- function (fileName, p = -1.0) {
    
    # Open the file connection
    con <- file(fileName, "r")
    
    # Initialize the vector
    result <- character()
    
    # Loop through each line in the file
    while(length(currentLine <- readLines(con, 1, warn = FALSE)) > 0) {
        
        # Get the next line
        currentLine <- readLines(con, 1)
        
        # Initialize the variable to include this line
        includeLine <- 1
        
        # Check if we are using a probability
        if (p >= 0 && p <= 1.0) {
            includeLine <- rbinom(1, 1, p)
            if (includeLine == 1) {
                result <- c(result, currentLine)
            }
        } else {
            result <- c(result, currentLine)
        }
        
    }
    
    # Close the file
    close(con)
    
    # Return the result
    result
    
}


## @knitr utilityFunctionGetCorpus

## This function takes a file name and optionally a probability.
## It returns a corpus object from the quanteda package representing the data in
## the file.
getCorpus <- function (fileName, p = -1.0) {
    corpus(getDataSample(fileName, p))
}


## @knitr utilityFunctionGenerateDataSample

## This function takes an input data file name, an output data file name, and
## optionall a probability. It outputs the sample data to the output data file
## and returns a corpus of the data.
generateDataSample <- function (inputFile, outputFile, p = -1.0) {
    s <- getDataSample(inputFile, p)
    
    con <- file(outputFile, "w")
    for (l in s) {
        writeLines(l, con)
    }
    close(con)
    
    corpus(s)
}


## @knitr utilityFunctionGetTokenizedData

## This function takes a file name and optionally a probability.
## It returns a document feature matrix containing a tokenized representation
## of the file.
getTokenizedData <- function (fileName, p = -1.0) {
    
    # Get the corpus
    c <- corpus(getDataSample(fileName, p))
    
    # Return the document feature matrix
    dfm(c)
    
}

## @knitr utilityFunctionGetDFM

## This function takes a corpus and an integer n and returns a dfm
## of n-grams.
getDFM <- function (c, n = 1) {
    
    t <- tokens(c, 
                remove_numbers = TRUE, 
                remove_punct = TRUE, 
                remove_symbols = TRUE)
    
    dfm(t, ngrams=n)
}


## @knitr utilityFunctionGetNGramFrequencies

## This function takes a DFM and returns a dataframe of the n-grams and their
## frequencies.
getNGramFrequencies <- function (d) {
    data.table(
        ngram = colnames(d),
        base = sapply(colnames(d), 
          function(t) {
              if (grepl("_", t) == TRUE) {
                  strsplit(t, "_(?=[^_]+$)", perl=TRUE)[[1]][1]
              } else {""}
          }),
        predicted = sapply(colnames(d),
           function(t) {
               if (grepl("_", t) == TRUE) {
                   strsplit(t, "_(?=[^_]+$)", perl=TRUE)[[1]][2]
               } else {t}
           }),
        freq = colSums(d))
}


## @knitr utilityFunctionAppendNGramFrequencies

## This function takes a dataframe of n-gram frequencies and another dataframe
## of n-gram frequencies and adds frequency counts and new n-grams to the former.
appendNGramFrequencies <- function (totalCounts, newCounts) {
    totalCounts %>%
        # Add rows
        rbind(newCounts) %>%
        # Group
        group_by(ngram, base, predicted) %>%
        # Summarize to get new totals
        summarize(freq = sum(freq))
}


## @knitr utilityFunctionLogProgress
library(lubridate)
## This function logs a message to a file
logProgress <- function (message, fileName) {
    write(
        paste(
            with_tz(Sys.time(), tz="America/Chicago"), 
            ":", 
            message), 
        file=fileName, 
        append=TRUE)
}

## @knitr utilityFunctionGetNGramFileName
## Type: Blogs, News, Twitter, All
getNGramFileName <- function (type, firstLetter, n, directory = "", isCompressed = FALSE) {
    fileName <- paste(directory, "nGrams",
          type,
          n, 
          "_", 
          firstLetter, 
          ".csv", sep="") 
    if (isCompressed == TRUE) {
        fileName <- paste(fileName, ".gz", sep="")
    }
    fileName
}

## @knitr utilityFunctionFilterProfanity
removeProfanity <- function (nGrams) {
    
    for (curRow in 1:nrow(nGrams)) {
        profanitySum <- sum(sapply(profanity_google, grepl, nGrams[curRow,"predicted"]))
        if (profanitySum > 0) {
            nGrams[curRow, "hasProfanity"] = TRUE
        } else {
            nGrams[curRow, "hasProfanity"] = FALSE
        }
    }
    
    nGrams %>% filter(hasProfanity == FALSE)
}