==================================================================
Title: Cleaning_Data_Final_README
Author: Levi Solomyak
==================================================================
Title: Cleaning_Data_Final
==================================================================
Version 1.0
==================================================================
The following script run_Analysis.R takes the data downloaded fron the internet

The script achieves the following:

1) Merges the training and the test sets to create one data set.

2) Extracts only the measurements on the mean and standard deviation for each measurement.

3) Uses descriptive activity names to name the activities in the data set

4) Appropriately labels the data set with descriptive variable names.

5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

There are two important data sets created from running the script: 

a) fullset - The full labeled and described dataset is called

b) summarized_data- the summary of the full data set. This set takes the average of each features and is broken down by subject ID  and by activity 

NOTE- only the second dataset is writen out as a csv file. 
To view it, run the script and then enter:
> data <- read.table("summarized_data.csv", header = TRUE)
> View(data)


Note: Data taken from: Human Activity Recognition Using Smartphones Dataset
