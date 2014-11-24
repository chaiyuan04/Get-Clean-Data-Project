#Course Project

setwd("C:/Users/chaix026/Dropbox/R/Getting Data and Data Clearning/quiz/Get-Clean-Data-Project")
ProjectUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(ProjectUrl, destfile="./data/ProjectData.zip")
unzip("./data/Get-Clean-Data-Project/ProjectData.zip", exdir="./data")

features <- read.table("./data/UCI HAR Dataset/features.txt")
head(features)
tail(features)

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activity_labels


#Training Data
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
colnames(X_train) <- features[,2]
head(X_train)

Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
colnames(Y_train) <- "ActivityLabel"
summary(Y_train)

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "VolunteerID"
head(subject_train)
table(subject_train)

trainData <- cbind(subject_train, Y_train, X_train)
head(trainData)


#Test
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
colnames(X_test) <- features[,2]
head(X_test)

Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
colnames(Y_test) <- "ActivityLabel"
summary(Y_test)

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "VolunteerID"
head(subject_test)
table(subject_test)

testData <- cbind(subject_test, Y_test, X_test)
head(testData)

#MergeData
MergeData <- rbind(trainData, testData)
head(MergeData)

#Extrats only the mean and std
library(stringr)

#Colnames having "mean" or "std"
MeanStdCol <- grepl("mean|std", colnames(MergeData))

#Selction: include the first two columns "ID" and "Activitiy", as well as only "mean" and "std" cols
SelCol <- MeanStdCol
SelCol[c(1,2)] <- c(TRUE, TRUE)
MergeDataSel <- MergeData[, SelCol]

#Rename Activity Labels
MergeDataSel[,2] <- as.factor(MergeDataSel[,2])
levels(MergeDataSel[,2]) <- activity_labels[,2]

#New data set of average
library(data.table)
DT <- as.data.table(MergeDataSel)
DT <- DT[order(VolunteerID, ActivityLabel)]
DT <- DT[, lapply(.SD, mean), by=list(VolunteerID, ActivityLabel)]


#Write the tidy data set as txt file
write.table(DT, file="./data/TidyData.txt", row.names=FALSE)


