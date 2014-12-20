require(dplyr)
require(tidyr)

# Download the file
zip_url <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(zip_url, basename(zip_url))
unzip(basename(zip_url))

# Read Test Data
testX    <- read.table('./UCI HAR Dataset/test/X_test.txt')
testY    <- read.table('./UCI HAR Dataset/test/y_test.txt')
testSubj <- read.table('./UCI HAR Dataset/test/subject_test.txt')

# Read Training Data
trainX    <- read.table('./UCI HAR Dataset/train/X_train.txt')
trainY    <- read.table('./UCI HAR Dataset/train/y_train.txt')
trainSubj <- read.table('./UCI HAR Dataset/train/subject_train.txt')

# Read Labels
colLabels <- read.table('./UCI HAR Dataset/features.txt',stringsAsFactors = FALSE)
colLabels$V2 <- gsub("BodyBody","Body",colLabels$V2) # fixes error in column label
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt',stringsAsFactors = FALSE)

# Give Labels
colnames(testY)  <- 'activityType'
colnames(trainY) <- 'activityType'
colnames(trainSubj) <- 'subject'
colnames(testSubj) <- 'subject'
colnames(testX)  <- make.names(colLabels$V2,unique = TRUE) # Give column names to data
colnames(trainX) <- make.names(colLabels$V2,unique = TRUE) # (step 4, had to be done now in order to do step 2)

# Put test and training sets together (step 1).
bothXY <- data.frame(rbind(cbind(testX,testY,testSubj),cbind(trainX,trainY,trainSubj)))

bothXY <- bothXY %>% 
  select(contains("mean"), # Select columns that contain mean
         contains("std"), # or standard deviation
         -starts_with("angle"), # but aren't angles
         -contains("meanFreq"), # or measures of mean frequency (step 2).
         activityType, subject) %>% # Also select activityType and subject columns.
  mutate(activityType=activityLabels[as.numeric(activityType),2]) # Replace numbers 1-6 with activity labels (step 3).
tidyDataset <- gather(bothXY,factor_measure_dim,values, 
         tBodyAcc.mean...X:fBodyGyroJerkMag.std.., # turn column headers for factors into one column
         convert=TRUE)
tidyDataset$factor_measure_dim <- gsub("\\.$","\\.N/A",tidyDataset$factor_measure_dim) # Add 'N/A' to measures without di?stmensions

tidyDataset <- separate(tidyDataset,factor_measure_dim, # separate measurement names into
           c('factor','measure','dimension'), sep="[\\.]+") # factor, measure and dimension

tidyDataset <- summarise_each(group_by(tidyDataset,activityType,factor,measure,dimension,subject),funs(mean(values))) # group by many columns, take mean of each group
tidyDataset <- spread(data.frame(tidyDataset),measure,values) # make standard deviation and mean seperate columns
tidyDataset <- mutate(tidyDataset,factor,signal=substring(factor,1,1),factor=substring(factor,2)) # separate frequency/time column
tidyDataset$signal <- gsub("f","freq",tidyDataset$signal) # change f to freq
tidyDataset$signal <- gsub("t","time",tidyDataset$signal) # change t to time

tidyDataset <- tidyDataset %>% 
           select(subject,factor,signal,activityType,dimension,mean,std) %>% # choose column order
           arrange(subject,factor,activityType) # and row order