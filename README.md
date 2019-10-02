This file contains a description of the analysis performed on UCI’s
“Human Acvitity Recognition Using Smartphones” Dataset

1: Merge the training and test sets to create one data set
==========================================================

Data is first downloaded and unzipped to a local directory. The *X\_*,
*subject\_*, and *y\_* files, representing the *output data*, *subjeect
IDs*, and *activity IDs* respectively, are read from each the “test” and
“train” datasets. The *X\_* files from each set are merged with `rbind`
to create one large dataset. The same is done for the *subject\_* and
*y\_* files. The merged data are stored in `datamerge`, `submerge`, and
`active_merge`, respectively.

Files are read using read.csv:
`subtest <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")`
And merged with: `submerge <- rbind(subtest, subtrain)`

2: Extract only the measurements on the mean and SD for each measurement
========================================================================

Within the provided **features.txt** file, `grepl` is used to find
measurements containing “mean()” or “sd()”. The logical vector from this
call is stored in `keepfeatures` and used to extract the appropriate
columns from `datamerge` with the subsetting call
`datamerge <- datamerge[, keepfeatures]`

3: Use descriptive activity names to name the activities in the data set
========================================================================

Activity names are available in the provided activity\_labels.txt file.
These names are read into `activity_labels`, and the leading numerical
identifiers (1-6) are removed with `sub`. The position of each string in
`activity_labels` now corresponds to its numerical identifier.
`activity_names` is then created, and contains a vector of strings of
activity names.

`activity_names` and `submerge`, which contain the *activity names* and
*subject IDs* respectively, are appended to the main dataframe
`datamerge`

4: Appropriate label the data set with descriptive variable names
=================================================================

`keepfeatures` is used to get the variable names from the provided
*features.txt* file. These are then used to modify the names of
`datamerge` using a call to `colnames(datamerge)`

5: Create a tidy data set with the average of each variable for each activity and each subject.
===============================================================================================

The function checks to see if the user has the `dplyr` package
installed, and installs it if not. `group_by` from the `dplyr` package
is used to group `datamerge` by *subject ID* and then by *activity*. The
`summarize_all(mean)` function is then used to find the mean of each
reading for each subject for each activity. The data is then written to
a text file.
