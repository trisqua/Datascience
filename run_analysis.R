# store all files as data frames
activities<-read.table("activity_labels.txt", header=FALSE)
features<-read.table("features.txt",header=FALSE)
testSubject<-read.table("./test/subject_test.txt",header=FALSE)
trainSubject<-read.table("./train/subject_train.txt",header=FALSE)
testActivity<-read.table("./test/y_test.txt",header=FALSE)
trainActivity<-read.table("./train/y_train.txt",header=FALSE)
testDataRaw<-read.table("./test/X_test.txt",header=FALSE)
trainDataRaw<-read.table("./train/X_train.txt",header=FALSE)

# add appropriate columnnames to the two data frames and the subject and activity files
names(testDataRaw)<-t(features)[2,]
names(trainDataRaw)<-t(features)[2,]
names(testSubject)<-c("subjectNo")
names(trainSubject)<-c("subjectNo")
names(testActivity)<-c("activityNo")
names(trainActivity)<-c("activityNo")
names(activities)<-c("activityNo","activity")

# join the subject and activity files to the left of either dataset
testData<-cbind(testSubject,testActivity,testDataRaw)
trainData<-cbind(trainSubject,trainActivity,trainDataRaw)

# add activity-column to either dataset
testData<-join(testData,activities,by="activityNo")
trainData<-join(trainData,activities,by="activityNo")

# move Activity-name forward in dataframe (and remove activityNo)
testData<-testData[,c(1,564,3:563)]
trainData<-trainData[,c(1,564,3:563)]

# merge the two frames to one frame
sensorData <- rbind(testData,trainData)

#keep only the columns that contain general information and mean or std-data (not meanFreq!)
sensorDataClean <- cbind(sensorData[,c(1,2)],sensorData[,grepl("mean[^F]|std",names(sensorData))])

#group the data by subject and activity and take the mean per group
sensorDataClean<-ddply(sensorDataClean, c("subjectNo","activity"), function(x) colMeans(x[names(sensorDataClean)[3:68]]))

#tidy the column names
names(sensorDataClean)<-gsub("BodyBody","Body",names(sensorDataClean))
names(sensorDataClean)<-gsub("-|\\(\\)","",names(sensorDataClean))

