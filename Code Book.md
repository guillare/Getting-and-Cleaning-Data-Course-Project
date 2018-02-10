# Getting and Cleaning data Project

Author: Guillermo Arenas

### Description of the variables

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### More information

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Data Source
Click here ()

### The data set "zip" includes: 

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

### Instructions of Project

You should create one R script called run_analysis.R that does the following.

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Description to the process

First, we have to download data
We have to check if the file (uci_har_dataset.zip) exists
if it does not, we create it 
Download data as .zip
```
fileUrl <-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./UCI HAR Dat.zip')) {
    download.file(fileUrl,destfile='./UCI HAR Dat.zip', mode='wb')
    unzip("UCI HAR Dat.zip", exdir = '.')
}
```

### Load features******************************************** 
```
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])
```
### Load train***********************************************
```
train_x <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
train_subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

train <-  data.frame(train_subject, train_activity, train_x)
names(train) <- c(c('Subject', 'Activity'), features)
```
### Load test************************************************
```
test_x <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test_subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

test <-  data.frame(test_subject, test_activity, test_x)
names(test) <- c(c('Subject', 'Activity'), features)
```
### 1. Merges the training and the test sets to create one data set.
We use the comand "rbind" to merge train and test
```
data_set_all<-rbind(train, test)
```
### 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 

```
m_st_sel <- grep('mean|std', features)
data_sub <- data_set_all[,c(1,2,m_st_sel + 2)]
```
### 3. Uses descriptive activity names to name the activities in the data set
We can do that download the labels from the "activity_labels.txt" file
```
Activitylabels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
Activitylabels <- as.character(Activitylabels[,2])
data_sub$Activity <- Activitylabels[data_sub$Activity]
```
### 4.	Appropriately labels the data set with descriptive variable names. 
Replace the names with names from activity labels
```
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
```
### 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Result: Tidy data named "final_data.txt"
```
final_data <- aggregate(data_sub[,3:81], by = list(Activity = data_sub$Activity, Subject = data_sub$Subject),FUN = mean)
write.table(x = final_data, file = "final_data.txt", row.names = FALSE)
```
