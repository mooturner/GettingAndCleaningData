
#install packages
packages <- c("data.table", "sqldf")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

#download and extract data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
Data_Test_X <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
Data_Test_Subjects <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
Data_Test_Y <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))

Data_Train_X <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
Data_Train_Subjects <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
Data_Train_Y <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))

Data_Activity_Labels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
Data_Features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
unlink(temp)

head(Data_Test_Y)



#append the datasets
Data_Merged <- rbind(Data_Test_X, Data_Train_X)

#name the columns
setnames(Data_Merged, names(Data_Merged), as.character(Data_Features$V2))


#keep only the mean and std
Data_Merged2 <- Data_Merged[ , grepl("(mean\\(|std)" , names(Data_Merged)) ]


#add the activity num
Data_Y <- rbind(Data_Test_Y, Data_Train_Y)
Data_Merged2$Activity <- Data_Y$V1


#add the activity descriptions
Data_Merged2$ActivityDesc <- Data_Activity_Labels[match(Data_Merged2$Activity, Data_Activity_Labels$V1), "V2"]



#add the subjects
Data_Subjects <- rbind(Data_Test_Subjects, Data_Train_Subjects)
Data_Merged2$Subject <- Data_Subjects$V1




#find the mean for each variable for each group
dt <- data.table(Data_Merged2)
Data_Mean <- dt[, lapply(.SD, mean, na.rm=TRUE), by=list(ActivityDesc,Subject), .SDcols=grepl("(mean\\(|std)" , names(Data_Merged)) ] 



#export data
write.csv(Data_Mean, file = ".\\Data_Mean.csv")


