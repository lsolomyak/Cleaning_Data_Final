library(dplyr)
#download the data
filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
      download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
      unzip(filename) 
}

testset <- read.table("UCI HAR Dataset/test/X_test.txt")
trainset <- read.table("UCI HAR Dataset/train/X_train.txt")

#download the features
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE, sep = " ", stringsAsFactors = FALSE)
features <- features[ ,2]


#download training and test set labels
train_set_lab <- read.table("UCI HAR Dataset/train/y_train.txt")
test_set_lab <- read.table("UCI HAR Dataset/test/y_test.txt")

# convert it into factors
train_set_lab <- factor(train_set_lab$V1, levels=seq(1:6), labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING","LAYING"))
test_set_lab <- factor(test_set_lab$V1, levels=seq(1:6), labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING","LAYING"))


#let's import the subject 
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, stringsAsFactors = TRUE)
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE, stringsAsFactors = TRUE)

#bind the datasets together 
tset <- cbind(subject_train,train_set_lab, trainset)
testset <- cbind(subject_test, test_set_lab, testset)
names(tset) <- c("subject", "activity", features)
names(testset) <- c("subject", "activity", features)
fullset <- rbind(tset, testset)
# lets get a unique name for every column
un_names <- ave(as.character(names(testset)), names(testset), FUN=function(x) if (length(x)>1) paste0(x[1], '.', seq_along(x), ')') else x[1])
unique_names <- as.data.frame(un_names)
names(fullset) <- unique_names$un_names
names(fullset) <- gsub("-mean",".mean", names(fullset))
names(fullset) <- gsub("-std",".std", names(fullset))

#keep only the columns we want
fullset <- select(fullset,subject, activity, grep("mean" , names(fullset)) , grep("std" , names(fullset)))

#turn id into factor
fullset$subject <- as.factor(fullset$subject)
  #and get the data summary 
data_summary <- fullset %>% group_by(subject, activity) %>% summarise_each(funs(mean), `tBodyAcc.mean()-X`:`fBodyBodyGyroJerkMag.std()`)


write.table(data_summary, "summarized_data.csv", row.names = FALSE)
  #to read the data table set header=true 
