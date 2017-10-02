## Introduction

This repository contains the script and result dataset for the Getting and Cleaning Data Course Project.

## Contents

* run_analysis.R: This file contains the script to perform the analyses for the assignment.

* CodeBook.md: This is the code book describing the variables, transformations, etc. performed by the script.

* README.md: This document, describes the repo contents.

* tidy_averaged_data.txt: The resultant dataset produced by the script.

## Running the script

0. Place the R script file "run_analysis.R" in your working directory.

1. Download and extract the dataset for the assigment to your working directory under the folder "UCI HAR Dataset". https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. Run the code:
```
source("run_analysis.R")
```
This will create two variables:
```
tidy_data
summarized_tidy_data
```
`summarized_tidy_data` represents the second, independent tidy data set asked for in step 5 of the assignment. It contains the average of each variable for each activity and each subject.

*Note:* This code assumes you have the data.table and dplyr packages installed.

3. Save the result data to a file:
```
write.table(summarized_tidy_data, file="summarized_tidy_data.txt", row.names=FALSE)
```

## What the script does

The script performs the following actions:

0. Reads the data from the data files.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Result: Two tibbles, called "tidy_data" and "summarized_tidy_data".

For more information, please see CodeBook.md
