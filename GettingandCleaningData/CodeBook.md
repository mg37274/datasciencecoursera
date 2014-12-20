---
title: "Codebook"
author: "Mandara Gabriel"
date: "December 20, 2014"
output: html_document
---

## Data origin
This data was obtained from the SmartLab Non Linear Complex Systems Laboratory. It was published in the following paper:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Disclaimer from the authors:
"This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited."

## Information about original data from the authors:
* The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
* Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
* Features are normalized and bounded within [+1,1].
* Each feature vector is a row on the text file."
* For each record it is provided:
    * Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
    * Triaxial Angular velocity from the gyroscope. 
    * A 561-feature vector with time and frequency domain variables. 
    * Its activity label. 
    * An identifier of the subject who carried out the experiment.

For more information about the original dataset contact: activityrecognition@smartlab.ws


## Data Transformations from original
###  Downloading and importing data 
1. Original zip file of data downloaded from http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Data was unzipped. The following files were then imported into R as data tables:

File Name | Description
---|---
 /UCI HAR Dataset/test/X_test.txt | Test data
 /UCI HAR Dataset/test/y_test.txt | Test data labels
 /UCI HAR Dataset/test/subject_test.txt | Numbers in range 1-30 idenftifying excercising subjects for test data.
 /UCI HAR Dataset/train/X_train.txt | Training data
 /UCI HAR Dataset/train/y_train.txt | Training data labels
 /UCI HAR Dataset/train/subject_train.txt | Numbers in range 1-30 idenftifying excercising subjects for training data.
 /UCI HAR Dataset/features.txt | Column labels for features.
 /UCI HAR Dataset/activity_labels.txt | Key linking activity numbers with labels.

 
### Renaming and Selecting
1. Fixed a typo in "features.txt" table to change "BodyBody" to "Body"
2. Labeled column name for testY and trainY as 'activityType'
3. Labeled column name for trainSubj and testSubj as 'subject'
4. Gave testX and trainX the names from colLabels.
5. Clipped together the testX,testY and testSubj together columnwise, trainX,trainY and trainSubj together columnwise, and clipped these together rowwise.
6. Selected columns that contained "mean" or "std" but do not start with "angle" or contain "meanFreq". The angles were excluded because according to the parentheses, they are angles of means/std rather than being means/std of angles. Also kept columns for activityType and subject.
7. Used activity_labels.txt to replace numbers 1-6 with activity labels.

### Making Tidy Data
1. Turn horizontal column headers for factors into one vertical column called "factor_measure_dim".
2. Add N/A to the end of measures without dimensions
3. Separate factor_measure_dim column into 'factor','measure' and 'dimension'. Use one or more '.' as the separator.
4. Group by tidyDataset,activityType,factor,measure,dimension and subject. Take mean of each combination of variables.
5. Make standard deviation and mean into seperate columns instead of column values.
6. Separate frequency/time into it's own column, 'factor'.
7. Change value "f" to "freq"
8. Change value "t" to "time"
9. Put columns in the following order: subject,factor,signal,activityType,dimension,mean,std)
10. Sorted rows by subject, then factor, then activityType.

## Tidy Data Details
The following are the columns in the tidy dataset:

### subject
 [1] 1:30 Number representing the person excercising.

### variable
 [1] "BodyAcc" Body Acceleration, Triaxial  
 [2] "BodyAccJerk" Body Acceleration Jerk, Triaxial  
 [3] "BodyAccJerkMag" Body Acceleration Jerk, Magnitude  
 [4] "BodyAccMag" Body Acceleration, Magnitude  
 [5] "BodyGyro" Body Angular Jerk, Triaxial  
 [6] "BodyGyroJerk" Body Angular Jerk, Triaxial  
 [7] "BodyGyroJerkMag" Body Angular Jerk, Magnitide  
 [8] "BodyGyroMag" Body Angular Velocity, Magnitide  
 [9] "GravityAcc" - Gravitational Linear Acceleration, Triaxial  
 [10] "GravityAccMag" - Gravitational Linear Acceleration, Magnitude  

### signal
 [1] "freq" - Frequency (Fourier Transform taken)  
 [2] "time" - Time (original measurement)  

### activityType
 [1] "LAYING" - if subject was lying down  
 [2] "SITTING" - if subject was sitting  
 [3] "STANDING" - if subject was standing  
 [4] "WALKING" - if subject was walking  
 [5] "WALKING_DOWNSTAIRS" - if subject was walking downstairs  
 [6] "WALKING_UPSTAIRS" - if subject was walking upstairs  

### dimension
 [1-3] X, Y, Z - Axis of measurement  
 [4] N/A - Magnitude measurement, no axis  

### mean
 [1] -0.9976174:0.9745087 - Average

### std
 [1] -0.9976661:0.6871242 - Standard deviation