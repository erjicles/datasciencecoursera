## Getting and Cleaning Data
## Course Project
## By erjicles 10/01/2017

## This script performs the following actions:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each
## measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.
## Result: Two tibbles, called "tidy_data" and "summarized_tidy_data"

## This script uses the UCI HAR Dataset provided by the course here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## It assumes that this zip file has been extracted into a folder in the working
## directory called "UCI HAR Dataset".
library(data.table)
library(dplyr)

#### 0. Read in the data from the data files
## File descriptions per README.txt in the dataset:
## Descriptive data:
## - 'features_info.txt': Shows information about the variables used on the feature vector.
##     - We ignore this file, as it just contains descriptions about the variables
## - 'features.txt': List of all features.
##     - We load this into a table called: features.
##       We use this to get the column names for the measurement variables.
## - 'activity_labels.txt': Links the class labels with their activity name.
##     - We load this into a table called: activity_labels.
##       We use this to provide descriptive factors for the activities.
## Train dataset:
## - 'train/X_train.txt': Training set.
##     - We load this into a table called: train_x_train
##       This contains the train data for the 561 measurement variables.
##       7352 observations.
## - 'train/y_train.txt': Training labels.
##     - We load this into a table called: train_y_train
##       This contains the ActivityId for each observation of the train_x_train table.
## - 'train/subject_train.txt': Each row identifies the subject who performed
##       the activity for each window sample. Its range is from 1 to 30. 
##     - We load this into a table called: train_subject_train
##       This contains the Subject for each observation of the train_x_train table.
## Test dataset:
## - 'test/X_test.txt': Test set.
##     - We load this into a table called: test_x_test
##       This is the test dataset analogue of the train_x_train table.
##       2947 observations.
## - 'test/y_test.txt': Test labels.
##     - We load this into a table called: test_y_test
##       This is the test dataset analogue of the train_y_train table.
## - 'test/subject_test.txt': Each row identifies the subject who performed
##       the activity for each window sample. Its range is from 1 to 30. 
##     - We load this into a table called: test_subject_test
##       This is the test dataset analogue of the train_subject_train table.
## Inertial subfolders:
## We ignore these, as they only contain raw data that's used to produce the
## rest of the dataset. They do not contain mean or standard deviation variables.

## Read activity and feature descriptive data from the files
features <- read.csv("UCI HAR Dataset/features.txt", header=F, sep="")
activity_labels <- read.csv(
    "UCI HAR Dataset/activity_labels.txt", 
    header=F, 
    sep="",
    col.names=c("ActivityId", "Activity"))

## Read the test dataset from the "test" subfolder
test_subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=F,sep="")
test_x_test <- read.csv("UCI HAR Dataset/test/X_test.txt",sep="",header=F)
test_y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", header=F,sep="")

## Read the train dataset from the "train" subfolder
train_subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=F,sep="")
train_x_train <- read.csv("UCI HAR Dataset/train/X_train.txt",sep="",header=F)
train_y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", header=F,sep="")


#### 1. Merges the training and the test sets to create one data set. 

## Combine the test dataset tables into one table
## Analogous to: test_data <- cbind(test_subject_test, test_y_test, test_x_test)
tidy_data <-
    test_subject_test %>%
    cbind(test_y_test) %>%
    cbind(test_x_test) %>%

    ## Merge the combined test and train datasets to form one dataset
    ## Analogous to: all_data <- rbind(test_data, train_data)
    rbind(
        ## Combine the train dataset tables into one table
        ## Analogous to: train_data <- cbind(train_subject_train, train_y_train, train_x_train)
        train_subject_train %>%
            cbind(train_y_train) %>%
            cbind(train_x_train)
    ) %>%


## 4. Appropriately labels the data set with descriptive variable names.

    ## Rename the columns to provide descriptive variable names
    ##  Column 1: Subject
    ##  Column 2: ActivityId
    ##  Columns 3-563: The measurement variable names provided in the features 
    ##                 table.
    ##                 Some features have duplicate names, so call make.unique 
    ##                 to make them unique.
    setNames(
        c(
            "Subject", 
            "ActivityId", 
            make.unique(as.character(features[[2]]))
            )
        ) %>%


#### 3. Uses descriptive activity names to name the activities in the data set

    ## Join on the activity_labels table by ActivityId to add a column containing
    ## the descriptive activity labels
    merge(
        activity_labels, 
        by.x="ActivityId", 
        by.y="ActivityId",
        sort=FALSE) %>%

#### 2. Extracts only the measurements on the mean and standard deviation for each
####    measurement.
    
    ## Convert into a table dataframe
    tbl_df %>%
    
    ## Select the relevant columns
    ## Column 1: Subject
    ## Column 2: Activity (descriptive activity name, not ActivityId)
    ## Column 3-81: All mean and standard deviation variables
    select(Subject, Activity, grep("mean()|std()", names(.)))

## 4b. Remove file datasets no longer needed
rm(list=c(
    "features", 
    "activity_labels", 
    "test_subject_test", 
    "test_x_test", 
    "test_y_test", 
    "train_subject_train", 
    "train_x_train", 
    "train_y_train")
   )

## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

## Create a new dataset, grouped on Activity and Subject of the tidy dataset
summarized_tidy_data <-
    group_by(tidy_data, Activity, Subject) %>%
    
    ## Compute the average of each measurement for each activity and subject
    summarize_all(mean)

## Code used to save the summarized tidy data to a file:
# write.table(summarized_tidy_data, file="summarized_tidy_data.txt", row.names=FALSE)