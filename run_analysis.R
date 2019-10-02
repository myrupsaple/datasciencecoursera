run_analysis <- function() {
        ### Read in the features decoder file
        features <- read.csv("features.txt", header = FALSE, sep = "\n")
        featurechar <- as.character(features[,1])
        keepfeatures <- grepl("mean\\(\\)|std\\(\\)", featurechar)
        
        ### Read in the "X" data from each set and merge the data frames
        xtest <- read.csv("test/X_test.txt", header = FALSE, sep = "")
        xtrain <- read.csv("train/X_train.txt", header = FALSE, sep = "")
        datamerge <- rbind(xtest, xtrain)
        # Clear the original datasets from memory
        rm(xtest)
        rm(xtrain)
        # Replace the headers with activity names
        names(datamerge) <- featurechar
        # Extract desired mean and std values
        datamerge <- datamerge[, keepfeatures]
        
        ### Read in the remaining files and merge
        ## Subject files
        subtest <- read.csv("test/subject_test.txt", header = FALSE, sep = "")
        subtrain <- read.csv("train/subject_train.txt", header = FALSE, sep = "")
        submerge <- rbind(subtest, subtrain)
        rm(subtest)
        rm(subtrain)
        ## Add a header name
        colnames(submerge) <- "Subject ID"
        
        ## Read in test type files
        ytest <- read.csv("test/y_test.txt", header = FALSE, sep = "")
        ytrain <- read.csv("train/y_train.txt", header = FALSE, sep = "")
        active_merge <- rbind(ytest, ytrain)
        rm(ytest)
        rm(ytrain)
        ##Add a header name and replace numbers with descriptive activity names
        activity_labels <- read.csv("activity_labels.txt", header = FALSE, sep = "\n")
        activity_labels <- sub("[0-9] ", "", as.character(activity_labels[, 1]))
        activity_names <- activity_labels[as.numeric(unlist(active_merge))]
        activity_names <- data.frame(activity_names)
        colnames(activity_names) <- "Activity"
        ##Append activity names and subject IDs to main dataframe
        datamerge <- cbind(submerge, activity_names, datamerge)
        
        ### Create a tidy data set summarizing the data
        ## Install dplyr if not installed
        if (!is.element("dplyr", installed.packages()[,1]))
                install.packages("dplyr", dep = TRUE)
        require("dplyr", character.only = TRUE)
        
        ## Sort the data by "Subject ID" and "Activity", find the mean, and output
        # the data to a text file
        summarized_data <- group_by(datamerge, `Subject ID`, Activity) %>%
                summarize_all(mean) %>%
                write.table(file = "Summary.txt", row.name= FALSE)
}