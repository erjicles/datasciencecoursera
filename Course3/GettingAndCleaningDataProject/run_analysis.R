## Programming Assignment
library(dplyr)

## Read the test data from the files
test_subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=F,sep="")
test_x_test <- read.csv("UCI HAR Dataset/test/X_test.txt",sep="",header=F)
test_y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", header=F,sep="")

## Read the train data from the files
train_subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=F,sep="")
train_x_train <- read.csv("UCI HAR Dataset/train/X_train.txt",sep="",header=F)
train_y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", header=F,sep="")

## Read activity and feature data from the files
features <- read.csv("UCI HAR Dataset/features.txt", header=F, sep="")
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", header=F, sep="")

## Set column names for the subject and activity data sets
colnames(test_subject_test) <- c("Subject")
colnames(test_y_test) <- c("ActivityId")
colnames(train_subject_train) <- c("Subject")
colnames(train_y_train) <- c("ActivityId")
colnames(activity_labels) <- c("ActivityId", "Activity")

## Combine the test data into one data set
test_data <- cbind(test_subject_test, test_y_test, test_x_test)

## Combine the train data into one data set
train_data <- cbind(train_subject_train, train_y_train, train_x_train)

## Set the column names for the measurement variables
## in the test and train data sets
colnames(test_data)[3:563] <- as.character(features[[2]])
colnames(train_data)[3:563] <- as.character(features[[2]])

## Replace the activity codes with the respective labels


## Merge the test and train data sets into one
all_data <- rbind(test_data, train_data)

## Add the activity labels to the data
all_data <- join(all_data, activity_labels, by="ActivityId")

## Keep only mean and standard deviation columns of measurements
relevant_data <- all_data[, grepl("^Subject$|^Activity$|mean()|std()", names(all_data))]

## Reorder columns to keep Subject and Activity together
relevant_data <- select(relevant_data, 1, 81, 2:80)

## Computes the average of each measurement
## for each activity and subject
averaged_data <- group_by(relevant_data, Activity, Subject)
summarized_data <- summarize_all(averaged_data, mean)

## Save the tidy averaged data as a file
write.table(summarized_data, file="tidy_averaged_data.txt", row.names=FALSE)
