## Week 4 Programming Assignment

## Takes three arguments: the 2-character abbreviated name of a state (state),
## an outcome (outcome), and the ranking of a hospital in that state for that
## outcome (num).
## Reads the outcome-of-care-measures.csv file and returns a character vector
## with the name of the hospital that has the ranking specified by the num
## argument.

## Test cases:
## rankhospital("TX", "heart failure", 4)
## "DETAR HOSPITAL NAVARRO"
## rankhospital("MD", "heart attack", "worst")
## "HARFORD MEMORIAL HOSPITAL"
## rankhospital("MN", "heart attack", 5000)
## NA

rankhospital <- function(state, outcome, num = "best") {
    ## Put the arguments into lower case
    outcome_lower <- tolower(outcome)
    state_lower <- tolower(state)
    num_lower <- tolower(num)
    
    ## Read outcome data from the file
    outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    ## Select only the rows for the given state
    state_outcome_data <- outcome_data[tolower(outcome_data[,7]) == state_lower,]
    
    ## Check if there are any hospitals with this state
    ## If not, then the state is invalid and throw an error
    if (nrow(state_outcome_data) == 0) {
        stop("invalid state")
    }
    
    ## Check if the outcome provided is valid
    if (outcome_lower != "heart attack" 
        && outcome_lower != "heart failure" 
        && outcome_lower != "pneumonia") {
        stop("invalid outcome")
    }
    
    ## Keep only the hospital name and the relevant outcome column
    if (outcome_lower == "heart attack") {
        state_outcome_data <- state_outcome_data[,c(2,11)]
    } else if (outcome_lower == "heart failure") {
        state_outcome_data <- state_outcome_data[,c(2,17)]
    } else { ## pneumonia
        state_outcome_data <- state_outcome_data[,c(2,23)]
    }
    
    ## Remove "Not Available" from data column
    state_outcome_data <- state_outcome_data[state_outcome_data[,2] != "Not Available",]
    
    ## Coerce the data column to numeric
    state_outcome_data[,2] <- as.numeric(state_outcome_data[,2])
    
    ## Remove NA
    state_outcome_data <- state_outcome_data[!is.na(state_outcome_data[,2]),]
    
    ## Order by mortality rate, then by hospital name
    state_outcome_data <- 
        state_outcome_data[
            order(
                state_outcome_data[,2]
                , state_outcome_data[,1]
            ),
        ]
    
    ## Convert the num parameter into an integer
    rank_to_check <- 1
    if (num_lower == "best") {
        rank_to_check <- 1
    } else if (num_lower == "worst") {
        rank_to_check <- nrow(state_outcome_data)
    } else if (!is.integer(as.integer(num_lower))) {
        stop("invalid num")
    } else {
        rank_to_check <- as.integer(num_lower)
    }
    if (rank_to_check < 1) {
        stop("invalid num")
    }
    
    if (rank_to_check > nrow(state_outcome_data)) {
        return(NA)
    }
    
    ## Return the nth ranked hospital in the state for the given outcome
    nth_hospital <- state_outcome_data[rank_to_check,1]
    nth_hospital
}