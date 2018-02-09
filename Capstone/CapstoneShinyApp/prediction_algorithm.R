library(quanteda)
library(data.table)
library(dplyr)
library(lexicon)

# Load utility functions
source("utilities.R")
data_directory <- "data/"

predictNext <- function (input, filterProfanity = TRUE) {
    nMin <- 1
    nMax <- 5
    
    # Initialize the return value
    result <- character()
    
    # Convert the input into a corpus
    c <- corpus(input)
    
    for (n in nMax:nMin) {
        
        # Get last i-gram from the input
        lastNGram <- tail(colnames(getDFM(c, n)), n=1)
        
        if (is.null(lastNGram)) {
            next
        }
        
        # Get the first character of the ngram
        firstChar <- substring(lastNGram, 1, 1)
        
        # Open the ngrams
        nGrams <- fread(paste("gzip -dc ", getNGramFileName("All", firstChar, n+1, directory=data_directory, isCompressed = TRUE), sep="")) %>%
            # Keep only the ngrams with the last n-gram as the base
            filter(base == lastNGram) %>%
            # Order by the frequency
            arrange(desc(freq))
        
        # Filter profanity if required
        if (filterProfanity == TRUE) {
            nGrams <- removeProfanity(nGrams)
        }
        
        # Check if there are any rows
        if (nrow(nGrams) > 0) {
            nToTake <- min(3, nrow(nGrams))
            result <- nGrams[1:nToTake, "predicted"]
            break
        }
        
    }
    
    # If there is no result, pick one at random
    if (length(result) == 0) {
        # Open the 1-grams
        nGrams <- fread(paste("gzip -dc ", getNGramFileName("All", "All", 1, directory=data_directory, isCompressed=TRUE), sep="")) %>%
            arrange(desc(freq))
        # Filter profanity if required
        if (filterProfanity == TRUE) {
            nGrams <- removeProfanity(nGrams)
        }
        result <- nGrams[1:3, "predicted"]
    }
    
    # Return the result
    result
}

predictLikeliest <- function (input, options) {
    nMin <- 1
    nMax <- 5
    
    # Initialize the return value
    result <- character()
    
    # Convert the input into a corpus
    c <- corpus(input)
    
    for (n in nMax:nMin) {
        
        # Get last i-gram from the input
        lastNGram <- tail(colnames(getDFM(c, n)), n=1)
        
        if (is.null(lastNGram)) {
            next
        }
        
        # Get the first character of the ngram
        firstChar <- substring(lastNGram, 1, 1)
        
        # Open the ngrams
        nGrams <- fread(getNGramFileName("All", firstChar, n+1, directory=data_directory, isCompressed = TRUE)) %>%
            # Keep only the ngrams with the last n-gram as the base
            filter(base == lastNGram, predicted %in% options) %>%
            # Order by the frequency
            arrange(desc(freq))
        
        # Check if there are any rows
        if (nrow(nGrams) > 0) {
            nToTake <- min(3, nrow(nGrams))
            result <- nGrams[1:nToTake, "predicted"]
            break
        }
        
    }
    
    # Check if there aren't any results
    if (length(result) == 0) {
        nGrams <- fread(getNGramFileName("All", "All", 1, directory=data_directory, isCompressed = TRUE)) %>%
            arrange(desc(freq))
        result <- nGrams[1:3, "predicted"]
    }
    
    # Return the result
    result
}

getTestData <- function () {
    testDataFrequencies <- data.table(ngram = character(),
                                      base = character(),
                                      predicted = character(),
                                      freq = integer())
    for (i in 2:6) {
        testDataFrequencies <- testDataFrequencies %>%
            rbind(getNGramFrequencies(getDFM(data_corpus_inaugural, i)))
    }
    testDataFrequencies
}

# 1. give       x die
# 2. marital    
# 3. weekend    
# 4. stress
# 5. look       x minute    x walk      x
# 6. case       x matter
# 7. hand
# 8. top
# 9. outside
# 10. movies