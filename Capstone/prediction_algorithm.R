library(quanteda)
library(data.table)
library(dplyr)

# Load utility functions
source("utilities.R")

predictNext <- function (input) {
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
        nGrams <- fread(getNGramFileName("All", firstChar, n+1)) %>%
            # Keep only the ngrams with the last n-gram as the base
            filter(base == lastNGram) %>%
            # Order by the frequency
            arrange(desc(freq))
        
        # Check if there are any rows
        if (nrow(nGrams) > 0) {
            nToTake <- min(3, nrow(nGrams))
            result <- nGrams[1:nToTake, "predicted"]
            break
        }
        
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
        nGrams <- fread(getNGramFileName("All", firstChar, n+1)) %>%
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
    
    # Return the result
    result
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