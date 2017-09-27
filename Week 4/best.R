## Week 4 Programming Assignment

## Takes two arguments: the 2-character abbreviated name of a state
## and an outcome name.
## Reads the outcome-of-care-measures.csv file and returns a character
## vector with the name of the hospital that has the best (i.e. lowest)
## 30-day mortality for the specified outcome in that state.
## The outcomes can be one of "heart attack", "heart failure", or "pneumonia".

## Test cases:
## best("TX", "heart attack")
## "CYPRESS FAIRBANKS MEDICAL CENTER"
## best("TX", "heart failure")
## "FORT DUNCAN MEDICAL CENTER"
## best("MD", "heart attack")
## "JOHNS HOPKINS HOSPITAL, THE"
## best("MD", "pneumonia")
## "GREATER BALTIMORE MEDICAL CENTER"
## best("BB", "heart attack")
## Error in best("BB", "heart attack") : invalid state
## best("NY", "hert attack")
## Error in best("NY", "hert attack") : invalid outcome

best <- function(state, outcome) {
    ## Put the provided outcome into lower case
    outcome_lower <- tolower(outcome)
    state_lower <- tolower(state)
    
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
    
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    best_hospital <- state_outcome_data[1,1]
    best_hospital
}