## Author: djahne
## Create Date: 4/26/2015
## Course: Getting and Cleaning Data
## Assignment: Course Project
## Purpose: Collects and cleans data from smartphone accelerometers into
##  a tidy data set that summarizes the observations. More details on the 
##  raw data can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

library(plyr)

## The main function of this script, this function performs the following 
##  steps:
##  1) Merges the training and the test sets to create one data set.
##  2) Extracts only the measurements on the mean and standard deviation for each 
##      measurement. 
##  3) Uses descriptive activity names to name the activities in the data set
##  4) Appropriately labels the data set with descriptive variable names. 
##  5) From the data set in step 4, creates a second, independent tidy data set 
#       with the average of each variable for each activity and each subject.
run_analysis <- function(){
    # first read the feature and activity codes into memory- these are the same
    #   for both the training and test data sets so only read them once
    featureNames <- read.table("UCI HAR Dataset\\features.txt", 
                           col.names=c("feature_id", "feature_name"))
    activityNames <- read.table("UCI HAR Dataset\\activity_labels.txt", 
                           col.names=c("activity_id", "activity_name"))
    
    # collect and clean training data
    trainingDataClean <- loadTrainingData(featureNames)
    
    # collect and clean test data
    testDataClean <- loadTestData(featureNames)
    
    # combine the two data sets
    fullData = rbind(trainingDataClean, testDataClean)
    
    # add descriptive activity_name column
    fullData <- merge(fullData, activityNames, by=c("activity_id"), all=TRUE)
    
    # remove the activity_id column (no longer needed, it has been replaced with activity_name)
    fullData <- subset(fullData, select = -c(activity_id))

    # now that the data is collected and clean, create a tidy data set that 
    #   only contains the average values for each subject/activity combination
    tidyData = getTidyData(fullData)
    
    # lastly, write the tidy data to disk
    write.table(tidyData, file="averageValuesBySubjectAndActivity.txt", row.name=FALSE)
}

## Loads the training data using the input feature and activity codes
## Input: 
##  featureNames: a data frame with two columns, "feature_id" and "feature_name"
##      that will be used to provide meaningful titles for variables
## Output: a data frame that contains all training data
loadTrainingData <- function(featureNames){
    loadData("UCI HAR Dataset\\train\\X_train.txt", 
             "UCI HAR Dataset\\train\\subject_train.txt", 
             "UCI HAR Dataset\\train\\y_train.txt",
             featureNames)
}

## Loads the test data using the input feature and activity codes
## Input: 
##  featureNames: a data frame with two columns, "feature_id" and "feature_name"
##      that will be used to provide meaningful titles for variables
## Output: a data frame that contains all test data
loadTestData <- function(featureNames){
    loadData("UCI HAR Dataset\\test\\X_test.txt", 
             "UCI HAR Dataset\\test\\subject_test.txt", 
             "UCI HAR Dataset\\test\\y_test.txt",
             featureNames)
}

## Collects and loads accelerometer data from the input files
## Input: 
##  dataFilePath: relative path to the raw data
##  subjectFilePath: relative path to the subject data
##  labelFilePath: relative path to the label data
##  featureNames: a data frame with two columns, "feature_id" and "feature_name"
##      that will be used to provide meaningful titles for variables
## Output: a data frame that contains all data
loadData <- function(dataFilePath, 
                     subjectFilePath, 
                     labelFilePath,
                     featureNames){
    # first load the raw data, subjects, and labels
    rawData = read.table(dataFilePath)
    subjects = read.table(subjectFilePath, col.names=c("subject_id"))
    labels = read.table(labelFilePath, col.names=c("activity_id"))
    
    # assign meaningful variable names to the data using the feature codes provided
    colnames(rawData) <- featureNames$feature_name
    
    # extract only the mean and std deviation data for each variable
    # build a regex that recognizes the column names we'd like to keep
    colNameRegex = "(mean\\(\\))|(std\\(\\))"
    # find the columns that match the regex
    colNumsToExtract = grep(colNameRegex, colnames(rawData))
    # extract those columns
    dataExtracted = rawData[,colNumsToExtract]
    
    # fnally, combine the data frames by adding the subject_id and activity_id 
    #   columns to the raw data
    dataAll <- cbind(subjects, labels, dataExtracted)
}

getTidyData <- function(fullData){
    tidyData <- aggregate(fullData[,!(colnames(fullData) %in% c("subject_id", "activity_name"))], 
              by=list(subject=fullData$subject_id, activity=fullData$activity_name), 
              FUN=mean)
    tidyData <- arrange(tidyData,subject,activity)
}

