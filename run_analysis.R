#First, we have to download data
#We have to check if the file (uci_har_dataset.zip) exists
# if it does not, we create it 
#Download data as .zip
fileUrl <-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./UCI HAR Dat.zip')) {
    download.file(fileUrl,destfile='./UCI HAR Dat.zip', mode='wb')
    unzip("UCI HAR Dat.zip", exdir = '.')
}


#Load features******************************************** 
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

#Load train***********************************************
train_x <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
train_subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

train <-  data.frame(train_subject, train_activity, train_x)
names(train) <- c(c('Subject', 'Activity'), features)

#Load test************************************************
test_x <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test_subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

test <-  data.frame(test_subject, test_activity, test_x)
names(test) <- c(c('Subject', 'Activity'), features)

# 1. Merges the training and the test sets to create one data set.
data_set_all<-rbind(train, test)

# 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
m_st_sel <- grep('mean|std', features)
data_sub <- data_set_all[,c(1,2,m_st_sel + 2)]

# 3.	Uses descriptive activity names to name the activities in the data set
Activitylabels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
Activitylabels <- as.character(Activitylabels[,2])
data_sub$Activity <- Activitylabels[data_sub$Activity]
# 4.	Appropriately labels the data set with descriptive variable names. 
changename <- names(data_sub)
changename <- gsub("[(][)]", "", changename)
changename <- gsub("^t", "TimeDomain_", changename)
changename <- gsub("^f", "FrequencyDomain_", changename)
changename <- gsub("Acc", "Accelerometer", changename)
changename <- gsub("Gyro", "Gyroscope", changename)
changename <- gsub("Mag", "Magnitude", changename)
changename <- gsub("-mean-", "_Mean_", changename)
changename <- gsub("-std-", "_St.Deviation_", changename)
changename <- gsub("-", "_", changename)
names(data_sub) <- changename
# 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final_data <- aggregate(data_sub[,3:81], by = list(Activity = data_sub$Activity, Subject = data_sub$Subject),FUN = mean)
write.table(x = final_data, file = "final_data.txt", row.names = FALSE)
