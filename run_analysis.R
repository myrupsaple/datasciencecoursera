run_analysis <- function() {
        ### Download data
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, "data.zip")
        unzip("data.zip")
        
        ### Read in the features decoder file
        features <- read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = "\n")
        featurechar <- as.character(features[,1])
        keepfeatures <- grepl("mean\\(\\)|std\\(\\)", featurechar)
        
        ### Read in the "X" data from each set and merge the data frames
        xtest <- read.csv("UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
        xtrain <- read.csv("UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
        datamerge <- rbind(xtest, xtrain)
        # Clear the original datasets from memory to save space
        rm(xtest)
        rm(xtrain)
        # Replace the headers with activity names
        names(datamerge) <- featurechar
        # Extract desired mean and std values
        datamerge <- datamerge[, keepfeatures]
        
        ### Read in the remaining files and merge
        ## Subject files
        subtest <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
        subtrain <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
        submerge <- rbind(subtest, subtrain)
        rm(subtest)
        rm(subtrain)
        colnames(submerge) <- "Subject_ID"
        
        ## Read in test type files
        ytest <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
        ytrain <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
        activemerge <- rbind(ytest, ytrain)
        rm(ytest)
        rm(ytrain)
        ##Add a header name and replace numbers with descriptive activity names
        activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "\n")
        activity_labels <- sub("[0-9] ", "", as.character(activity_labels[, 1]))
        activity_names <- activity_labels[as.numeric(unlist(activemerge))]
        activity_names <- data.frame(activity_names)
        colnames(activity_names) <- "Activity"
        
        ###Append activity names and Subject_IDs to main dataframe
        datamerge <- cbind(submerge, activity_names, datamerge)
        
        ### Create a tidy data set summarizing the data
        ## Install dplyr if not installed
        if (!is.element("dplyr", installed.packages()[,1]))
                install.packages("dplyr", dep = TRUE)
        require("dplyr", character.only = TRUE)
        
        ## Sort the data by "Subject_ID" and "Activity", find the mean, and output
        # the data to a text file
        summarized_data <- group_by(datamerge, Subject_ID, Activity) %>%
                summarize_all(mean) %>%
                write.table(file = "UCI HAR Dataset/Summary.txt", row.name= FALSE)
}