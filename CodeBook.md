CodeBook

Background

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This script does the following:

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

There are 3 basic Steps in this script


Step 1: Download/unzip the file 

library(dplyr)
if(!file.exists(".data")){dir.create(".data")}
#download the data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/easy.zip", method="curl")
directory <- unzip("~/Downloads/easy.zip", exdir = ".data")


There are three types of files to take note of 
X - the actual measurements
y - is the activity label- that can be translated using the activity_label.txt 
subjects- information about which subject was involved
features - information about the features in the data set 


Step 2: Process the data

We combine the data and keep only the features that involve an average or std measurement. 

fullset- is the combined data set- with two important columns to note. 
"activity" describes the activity while 
"subject" is the subject ID for whom the measurement was taken 

We then group the data
data_summary <- fullset %>% group_by(`subject_train$V1`, train_set_lab) %>% summarise_each(funs(mean), `tBodyAcc-mean()-X`:`fBodyBodyGyroJerkMag-std()`)

and summarize it based on the average and the subject number. here is a sample of the dataset output
for head(dataset)

subject           activity tBodyAcc.mean...X tBodyAcc.mean...Y
     <int>             <fctr>             <dbl>             <dbl>
1        1            WALKING        -0.5151064        -0.7302411
2        1   WALKING_UPSTAIRS        -0.6222726        -0.6895491
3        1 WALKING_DOWNSTAIRS        -0.5732177        -0.6404500
4        1            SITTING        -0.3507049        -0.5332175
5        1           STANDING        -0.3889270        -0.4644756
6        1             LAYING        -0.4104810        -0.5669921
7        2            WALKING        -0.4936300        -0.6957560
8        2   WALKING_UPSTAIRS        -0.3575534        -0.8820331
9        2 WALKING_DOWNSTAIRS        -0.4585974        -0.8835681
10       2            SITTING        -0.1348845        -0.6142663
11       2           STANDING        -0.4301112        -0.5794371
12       2             LAYING        -0.3488924        -0.8489561


Step 3: Write out the data 
write.table(data_summary, "summarized_data.csv", row.names = FALSE )

To see the data: 
data <- read.table("summarized_data.csv", header=TRUE)
View(data)

will work. 




