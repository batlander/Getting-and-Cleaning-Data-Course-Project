library(dplyr)
library(tidyr)

#1 Merge the training and the test sets to create one data set

## Read train and test data

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Read features
estadistics <- read.table("./UCI HAR Dataset/features.txt")

## Read activity
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Merge test and training data
Xtotal <- rbind(Xtrain, Xtest)
Ytotal <- rbind(Ytrain, Ytest)
Subtotal <- rbind(Subtrain, Subtest)

#2 Extract only main and std numbers

variable <- grep("mean\\(\\)|std\\(\\)", estadistics$V2)
variable <- estadistics[variable,]
Xtotal <- Xtotal[,variable[,1]]

#3 Use descriptive activity names to name the activities in the data set

Ytotal <- gsub ("1", "WALKING", Ytotal$V1)
Ytotal <- gsub ("2", "WALKING_UPSTAIRS", Ytotal)
Ytotal <- gsub ("3", "WALKING_DOWNSTAIRS", Ytotal)
Ytotal <- gsub ("4", "SITTING", Ytotal)
Ytotal <- gsub ("5", "STANDING", Ytotal)
Ytotal <- gsub("6", "STANDING", Ytotal)
Ytotal <- data.frame(Ytotal)
colnames(Ytotal) <- "act"
#4 Appropriately labels the data set with descriptive variable names

colnames(Xtotal) <- variable[,2]

#5 Create new DF

colnames(Subtotal) <- "subject"
result <- cbind(Subtotal, Ytotal, Xtotal)
result <- result  %>% group_by(subject, act) %>% summarize_each(funs(mean))
write.table(result, file = "tidy.txt", row.name = FALSE)


