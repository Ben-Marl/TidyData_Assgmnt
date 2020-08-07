## You should create one R script called run_analysis.R that does the following.

## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names.
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


X_train <- read.table("./data/train/X_train.txt")               ## reads the training set
y_train <- read.table("./data/train/y_train.txt")               ## reads the training labels
subject_train <- read.table("./data/train/subject_train.txt")   ## reads the subject who performed the activity [1-30]


X_test <- read.table("./data/test/X_test.txt")              ## reads the test sets
y_test <- read.table("./data/test/y_test.txt")              ## reads the test labels    
subject_test <- read.table("./data/test/subject_test.txt")  


features <- read.table("./data/features.txt")   ## reads the list of features
mergedData <- rbind(X_train, X_test) 
mergedData$labels <- rbind(y_train, y_test) 
mergedData$subjects <- rbind(subject_train, subject_test) 
colnames(mergedData) <- features$V2   ## gives columns the names


df2 <- mergedData[,grepl("mean()|std()", names(mergedData))]
df2 <- cbind(subjects = rbind(subject_train, subject_test), labels = rbind(y_train, y_test), df2)
colnames(df2)[1]<-"subject"
colnames(df2)[2]<-"activity"
activity_names <- read.table("./data/activity_labels.txt")   ## reads the class labels with their corresponding activity names


library(qdapTools)
df2[,2] <- lookup(df2[,2], activity_names, key.reassign = NULL,
                  missing = NA)   ## looks up for activities according to given num.
##Arguments of lookup:
##terms - A vector of terms to undergo a lookup.
## key.match- Takes one of the following: (1) a two column data.frame of a match key and
## reassignment column, (2) a named list of vectors (Note: if data.frame or named
## list supplied no key reassign needed) or (3) a single vector match key.
## key.reassign- A single reassignment vector supplied if key.match is not a two column data.frame/named
##list.
## missing Value to assign to terms not matching the key.match. If set to NULL the original
## values in terms corresponding to the missing elements are retained.
## Value
##Outputs A new vector with reassigned values


write.table(df2,"tidy-data.txt", row.name=FALSE) ## converts the new tidy data into text format

