# Week 4 Programming Assignment

## Takes two arguments: an outcome name (outcome) and a hispital ranking (num).
## Reads the outcome-of-care-measures.csv file and returns a 2-column data frame
## containing the hospital in each state that has the ranking specified in num.

rankall <- function(outcome, num = "best") {
    ## Put the arguments into lower case
    outcome_lower <- tolower(outcome)
    num_lower <- tolower(num)
    
    ## Read outcome data from the file
    outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    ## Get all the states in the data
    states_in_data <- unique(outcome_data[,7])
    
    ## Initialize the result
    result_data <- data.frame(states_in_data, vector(mode="integer", length=length(states_in_data)))
    
    ## For each state, find the hospital of the given rank
    result_data[,2] <- sapply(result_data[,1], rankhospital, outcome = outcome, num = num)
    
    ## Order by state
    result_data <- result_data[order(result_data[,1]),]
    
    result_data
}

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