---
title: "README"
output: html_document
---

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
