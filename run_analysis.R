# Data from the project
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# This script does the following:
# 
# 1.- Merges the training and the test sets to create one data set.
# 2.- Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.- Uses descriptive activity names to name the activities in the data set
# 4.- Appropriately labels the data set with descriptive variable names. 
# 5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)

# Download dile and unzip it on working directory
if(!file.exists("UCI HAR Dataset")) {
    if(!file.exists("./data")){dir.create("./data")}
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/UCI HAR Dataset.zip",method="curl")
    unzip("data/UCI HAR Dataset.zip")
}

# Read labels
features <-read.table("UCI HAR Dataset//features.txt")$V2
activity_labels <- read.table("UCI HAR Dataset//activity_labels.txt")$V2

# Not good idea to have special characters on variable names
features <- gsub("[[:punct:]]","_", features)

# Read test files
subject_test  <- read.table("UCI HAR Dataset//test//subject_test.txt")$V1
y_test <- read.table("UCI HAR Dataset//test//y_test.txt")$V1
X_test <- read.table("UCI HAR Dataset//test//X_test.txt")

# Read train file
subject_train  <- read.table("UCI HAR Dataset//train//subject_train.txt")$V1
y_train <- read.table("UCI HAR Dataset//train//y_train.txt")$V1
X_train <- read.table("UCI HAR Dataset//train//X_train.txt")

# Shape test data
data_test <- X_test
data_test$subject <- subject_test
data_test$y <- y_test
data_test$set <- "test"

# Shape train data
data_train <- X_train
data_train$subject <- subject_train
data_train$y <- y_train
data_train$set <- "train"

# Merge data (1)

data <- rbind(data_test, data_train)
data$subject <- as.factor(data$subject)
data$set <- as.factor(data$set)

# Now data is a tidy data set!!

# Measurements on means and standard deviations (2)

mean_std_cols <- sort(c(grep("_mean__", features, fixed = TRUE),
                        grep("_std__", features, fixed = TRUE)))

data_mean_std <- data[, mean_std_cols]

# Descriptive names to activities (3)

data$activity <- as.factor(mapvalues(data$y,
                                     from = 1:6, 
                                     to = as.character(activity_labels)))

# Descriptive variable names (4)

names(data)[1:561] <- features

# Average of each variable for each activity and each subjec (5)

avg_activity_subject <- ddply(data,
                              .(subject, activity),
                              numcolwise(mean))

write.table(avg_activity_subject, "avg_activity_subject.txt", row.names=FALSE)
