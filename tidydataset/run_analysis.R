##Tidy wearable computing dataset.

library(dplyr)
#1. Merges the training and the test sets to create one data set.
trainset <- read.csv("../R/wearable/train/X_train.txt",header = F,sep = "")
#(1.1) Merge(append) activity and subject column to train set.
trainactivity <- read.csv("../R/wearable/train/y_train.txt",header = F)
trainsubject <- read.csv("../R/wearable/train/subject_train.txt",header = F)
trainall <- cbind(trainset,trainactivity,trainsubject)
#(1.2)  Merge(append) activity column to test set.
testset <- read.csv("../R/wearable/test/X_test.txt",header = F,sep = "")
testactivity <- read.csv("../R/wearable/test/y_test.txt",header = F)
testsubject <- read.csv("../R/wearable/test/subject_test.txt",header = F)
testall <- cbind(testset,testactivity,testsubject)
#(1.3) Merge the train and test dataset.
allset <- rbind(trainall,testall)
#(1.4) Label the columns
features <- read.csv("../R/wearable/features.txt",header = F,sep = "",stringsAsFactors = F)
names(allset) <- c(features[,2],"activity_no","subject")

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#(2.1) compute indice of columns only contains mean and std .
meanstd_indice <- grep("((.*(mean|std)\\(\\).*)|activity_no|subject)", names(allset))
#(2.2) Filter the dataset given indice.
meanstd_dataset <- allset[,meanstd_indice]

#3. Uses descriptive activity names to name the activities in the data set
#(3.1) Load activity descriptive name data
activitylables <- read.csv("../R/wearable/activity_labels.txt",header = F,sep = "",stringsAsFactors = F)
names(activitylables) <- c("no","activity_label")
#(3.2) Join two dataset to add activity_label column.
tidy_dataset <- merge(x=meanstd_dataset,y=activitylables,by.x="activity_no",by.y="no")

#4. Appropriately labels the data set with descriptive variable names.
#remove the activity_no column (only keep its label)
tidy_dataset <- select(tidy_dataset,-activity_no)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
mean_dataset <- tidy_dataset %>% group_by(subject,activity_label) %>% summarise_each(funs(mean))
#Write tidy_dataset
write.table(mean_dataset, file = "../tidydataset/mean_dataset.csv",row.name=FALSE)

