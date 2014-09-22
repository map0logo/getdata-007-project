Getting and Cleaning Data, course project repository
====================================================

Uses plyr

If folder "UCI HAR Dataset" doesn't exists in working directory downloads and unzip data.

Read labels from "UCI HAR Dataset//features.txt" and "UCI HAR Dataset//activity_labels.txt"

In features replaces special characters by "_"

Read Test and Train files, subject_?, y_?, and X_?

Add set field to each data frame and merge using rbind.

Using grep calculate mean and std field, and filter data.

Assign descriptive names to activities using mapvalues function with activity_labels.

Assign descriptive names to variables from features vector.

Calculates averages of each variable for each activity and subject using ddply and numcolwise.
