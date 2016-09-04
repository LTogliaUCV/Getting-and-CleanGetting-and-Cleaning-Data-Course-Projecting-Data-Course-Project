#Firt we downloading the dataset from the link 
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Now we load the packages 
library(dplyr)
library(tidyr)
library(Hmisc)
library(reshape2)


#Now we  reads the data set 

# Reading trainings tables:
x_train <- read.table("./train/X_train.txt",sep="")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# Reading feature vector:
features <- read.table('./features.txt')

# Reading activity labels:
activityLabels = read.table('./activity_labels.txt')

#Now we merge the all data in same data-set
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
sameset <- rbind(merge_train, merge_test)



#the following step is assigning the columns names 

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')







#The next step is  extract the measurements
colNames <- colnames(sameset)

#we created a vector for the mean and sd

meanstd <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)


measures <- sameset[ , meanstd == TRUE]


# AS a second  the set for Activity 

Actname <- merge(measures, activityLabels,
                              by='activityId',
                              all.x=TRUE)


Tidy<- aggregate(. ~subjectId + activityId, Actname, mean)
Tidy<- TidyS[order(Tidy$subjectId,Tidy$activityId),]


#For finish we put all the tidy set in a txt file

write.table(TidyS, "Tidy.txt", row.name=FALSE)



