library(dplyr)
#download the data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "~/Downloads/easy.zip", method="curl")
directory <- unzip("~/Downloads/easy.zip", exdir = "~/Downloads/")

#Lets import the training and testsets just to look at them now
test_set <- read.csv(directory[15], header = FALSE)
test_set <- strsplit(as.character(test_set$V1), " ") # split it up based on the tabs- indicating a new value
test_set <- unlist(test_set)
#get rid of the blanks
test_set[test_set==""] <- NA 
test_set <- na.omit(test_set)
#turn the test set into a matrix 
test_set <- matrix(test_set, ncol=561)
#turn the set into a table
test_set <- tbl_df(test_set)
#turn all the values into numerics 
test_set <- tbl_df(sapply(test_set, as.numeric)) #tbl_df(

# same thing for the training set (see test set for explanation)
train_set <- read.csv(directory[27], header = FALSE)
# lets try and make it presentable 
train_set <- strsplit(as.character(train_set$V1), " ") 
train_set <- unlist(train_set)
train_set[train_set==""] <- NA
train_set <- na.omit(train_set)
train_set <- matrix(train_set, ncol=561 )
train_set <- tbl_df(train_set)
train_set <- tbl_df(sapply(train_set, as.numeric)) 


#get the features in
features <- read.csv(directory[2], header = FALSE, sep = " ", stringsAsFactors = FALSE)
features <- features[ ,2]
features <- as.data.frame(features)

#We know there are 561 features so thats how many columns our data set should have
names(train_set) <- features$features
names(test_set) <- features$features

# lets import the labels 
train_set_lab <- read.csv(directory[28], header = FALSE, stringsAsFactors = TRUE)
test_set_lab <- read.csv(directory[16], header = FALSE, stringsAsFactors = TRUE)
# convert it into factors
train_set_lab <- factor(train_set_lab$V1, levels=seq(1:6), labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING","LAYING"))
test_set_lab <- factor(test_set_lab$V1, levels=seq(1:6), labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING","LAYING"))

#let's import the subject 
subject_train <- read.csv(directory[26], header = FALSE, stringsAsFactors = TRUE)
subject_test <- read.csv(directory[14], header = FALSE, stringsAsFactors = TRUE)

#subject_test <- read.csv("~/Downloads/UCI HAR Dataset/test/subject_test.txt", header = FALSE, stringsAsFactors = TRUE)
#make it a data frame 
train_set_lab <- as.data.frame(train_set_lab)
test_set_lab <- as.data.frame(test_set_lab)

un_names <- ave(as.character(names(testset)), names(testset), FUN=function(x) if (length(x)>1) paste0(x[1], '(', seq_along(x), ')') else x[1])
unique_names <- as.data.frame(un_names)
tset <- cbind(subject_train$V1,train_set_lab, train_set)
testset <- cbind(subject_test$V1, test_set_lab, test_set)

names(tset) <-  unique_names$un_names
names(testset) <-  unique_names$un_names

tset <- tbl_df(tset)
testset <- tbl_df(testset)
#make sure the names are unique so we can turn it into a table 
#names(tset) <- c("`subject_train$V1`","train_set_lab", features$features)
#names(testset) <- c("`subject_test$V1`","test_set_lab", features$features)
#un_names <- ave(as.character(names(testset)), names(testset), FUN=function(x) if (length(x)>1) paste0(x[1], '(', seq_along(x), ')') else x[1])
#unique_names <- as.data.frame(un_names)
#make sure the subject number is a factor 

#now we add the feature names to the training set
#names(train_set) <- unique_names$un_names
#names(tset) <- unique_names$un_names
#names(testset) <- unique_names$un_names
#and to the test set 

# now we add the labels and subject number and combine data sets
names(tset) <- names(testset)
fullset <- rbind(tset, testset)
names(fullset) <- unique_names$un_names
#names(fullset) <- c("`subject_train$V1`","train_set_lab", features$`features[, 2]`)
fullset <- tbl_df(fullset)
#make sure the subject number is a factor 
fullset$`subject_train$V1` <- as.factor(fullset$`subject_train$V1`)
#lets only choose the columns we need
fullset <- select(fullset,`subject_train$V1`, train_set_lab, grep("mean" , names(fullset)) , grep("std" , names(fullset)))

#first we group by id then by activity
#and rename the first two columns- first all the means then all the std 

# now we get the summary variable called data_summary 
fullset$`subject_train$V1` <- as.factor(fullset$`subject_train$V1`)
data_summary <- fullset %>% group_by(`subject_train$V1`, train_set_lab) %>% summarise_each(funs(mean), `tBodyAcc-mean()-X`:`fBodyBodyGyroJerkMag-std()`)
data_summary <- rename(data_summary,subject= `subject_train$V1` , activity = train_set_lab)

write.table(data_summary, "summarized_data.csv", col.names = TRUE )
