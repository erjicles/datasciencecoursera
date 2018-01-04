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

