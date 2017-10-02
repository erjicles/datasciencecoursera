## Introduction

This code book describes the variables, transformations, and steps taken to clean up and analyze the data for the assignment.

## Variables

The script in "run_analysis.R" will create two variables:
```
tidy_data
summarized_tidy_data
```
`summarized_tidy_data`: Represents the second, independent tidy data set asked for in step 5 of the assignment. It contains the average of each variable for each activity and each subject.

`tidy_data`: Represents the tidy, but unsummarized, data containing all observations and all mean/standard deviation variables, along with the subject and activity.

## Assumptions on files

The x, y, and subject files in the test and train folders do not contain numerical indexes that can be used to tie observations together across each file. However, since the test and train files all contain 2947 and 7352 observations, respectively, we assume that the observations are all ordered such that we can cbind them together. Essentially, they "line up" without needing to do any reordering.

We ignore the inertial subfolders, as they don't contain mean or standard deviation variables.

## Process

### Overview

The script performs the following actions:
0. Reads the data from the data files.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Result: Two tibbles, called "tidy_data" and "summarized_tidy_data".

The script uses the UCI HAR Dataset provided by the course here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
It assumes that this zip file has been extracted into a folder in the working directory called "UCI HAR Dataset".

### 0. Read in the data from the data files
File descriptions per README.txt in the dataset:
Descriptive data:
* 'features_info.txt': Shows information about the variables used on the feature vector.
    + We ignore this file, as it just contains descriptions about the variables
* 'features.txt': List of all features.
    + We load this into a table called: features. We use this to get the column names for the measurement variables.
    + Contains 2 columns: The feature id, and the feature name.
* 'activity_labels.txt': Links the class labels with their activity name.
    + We load this into a table called: activity_labels. We use this to provide descriptive factors for the activities.
    + Contains 2 columns: The activity id, and the activity name.
Train dataset:
* 'train/X_train.txt': Training set.
    + We load this into a table called: train_x_train. This contains the train data for the 561 measurement variables. Contains 7352 observations.
* 'train/y_train.txt': Training labels.
    + We load this into a table called: train_y_train. This contains the ActivityId for each observation of the train_x_train table.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
    + We load this into a table called: train_subject_train. This contains the Subject for each observation of the train_x_train table.
Test dataset:
* 'test/X_test.txt': Test set.
    + We load this into a table called: test_x_test. This is the test dataset analogue of the train_x_train table. Contains 2947 observations.
* 'test/y_test.txt': Test labels.
    + We load this into a table called: test_y_test. This is the test dataset analogue of the train_y_train table.
* 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
    + We load this into a table called: test_subject_test. This is the test dataset analogue of the train_subject_train table.

### 1. Merge the training and the test sets to create one data set.

1. Combine the test dataset tables into one table using cbind.
2. Combine the train dataset tables into one table using cbind.
3. Combine the test and train datasets into one dataset using rbind.

### 2. Appropriately label the data set with descriptive variable names.

Rename the columns of the resultant dataset from step 1:
* Column 1: Subject
* Column 2: ActivityId
* Columns 3-563: The measurement variable names provided in column 2 of the features variable.
    + Some features have duplicate names, so call make.unique to make them unique.

### 3. Use descriptive activity names to name the activities in the data set

Join the resultant dataset from step 2 on the activity_labels table by ActivityId to add a column containing the descriptive activity labels.

### 4. Extract only the measurements on the mean and standard deviation for each measurement.

Starting with the resultant dataset from step 3, select the relevant columns
* Column 1: Subject
* Column 2: Activity (descriptive activity name, not ActivityId)
* Column 3-81: All mean and standard deviation variables. Assumes they have "mean()" and "std()" in their names, as per the features dataset.

### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Starting with the resultant dataset from step 4, group on Activity and Subject.
2. Create a new dataset with the following columns:
    + Column 1: Activity
    + Column 2: Subject
    + Column 3-81: The average average of each measurement for each respective activity and subject.
    
This is the result dataset, called `summarized_tidy_data`.
