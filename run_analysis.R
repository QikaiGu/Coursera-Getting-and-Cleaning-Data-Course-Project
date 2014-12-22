# 1. Merges the training and the test sets to create one data set.
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

dataset <- cbind(x, y, subject)

# 2. Extracts only the measurements on the mean and standard deviation for each 
# measurement. 
features <- read.table("UCI HAR Dataset/features.txt")
measurements <- grep("-(mean|std)\\(\\)", features[, 2])

dataset <- dataset[, c(measurements, 562, 563)]

# 3. Uses descriptive activity names to name the activities in the data set.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
dataset[, 67] <- activity_labels[dataset[, 67], 2]

# 4. Appropriately labels the data set with descriptive variable names.
names(dataset) <- c(as.vector(features[measurements, 2]), "activity", "subject")

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
library(plyr)
variable_averages <- ddply(dataset, .(activity, subject), 
                           function(x) colMeans(x[, 1:66]))

write.table(variable_averages, "variable_averages.txt", row.name=FALSE)
