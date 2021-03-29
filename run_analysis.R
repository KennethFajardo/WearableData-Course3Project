# The libraries used for this project
library(tidyr)
library(dplyr)
library(data.table)
library(reshape2)
# ---------- ITEM 1 ---------------- 
# Read the training and testing sets

X_train <- fread("./train/X_train.txt") 
y_train <- fread("./train/y_train.txt") 
X_test <- fread("./test/X_test.txt")
y_test <- fread("./test/y_test.txt")

# Read the test subject ID sets
S_train <- fread("./train/subject_train.txt")
S_test <- fread("./test/subject_test.txt")

# Change the label for the subject and activity columns
names(S_train) <- "ID"
names(S_test) <- "ID"
names(y_train) <- "act"
names(y_test) <- "act"

# Add the subject ID column to both testing and training data
X_train <- cbind(S_train, X_train)
X_test <- cbind(S_test, X_test)

# Add y_train as a new column to X_train
train <- cbind(X_train, y_train)
test <- cbind(X_test, y_test)

# Merge the training and testing sets
rawData <- rbind(train,test)

# (OPTIONAL) Convert to datatable to tibble
#rawData <- tibble::as.tibble(rawData)

# ---------- ITEM 2 ---------------- 
# NOTE: The measurements for this experiment are listed on 'features.txt'

# Read 'features.txt'
features <- fread("features.txt")

# Extract rows containing the words "mean" and "std"
features <- features[grep("mean\\(\\)|std\\(\\)",features$V2)]

# Modify the feature ID column to be of the same format as rawData (i.e. "V{feature_ID}"
# and remove the feature name column.
features$V1 <- features[,paste("V", features$V1, sep="")]

# Extract the columns from rawData which are in var features
extracted <- cbind(ID=rawData$ID ,rawData[, features$V1, with=FALSE], act=rawData$act)

# ---------- ITEM 3 ---------------- 
# Retrieve the activity labels from "activity_labels.txt" 

activity <- fread("activity_labels.txt") 
names(activity) <- c("ID", "activity")

# ---------- ITEM 4 ---------------- 
# Replace the activity column in the raw data with its corresponding acitivity name
extracted <- mutate(extracted, act=activity[act, 2])

# Melt the data in order to easily separate the variables
extracted <- as.data.table(extracted)
setkey(extracted, ID, act)
extracted <- melt(setDT(extracted), key(extracted), variable.name="feature.ID")

# Replace the feature ID in the raw data with its corresponding feature name
extracted <- merge(x=extracted, y=features[, list(V1, V2)], by.x="feature.ID", by.y = "V1", 
            all.x = TRUE)
for (i in extracted$feature.ID) { 
    # Retrieve the index of the corresponding feature ID of extracted
    # and then assign the feature name to extracted$feature.ID
    extracted[feature.ID==i, 3] <- features[match(i, features$V1), V2] 
}

# Since this column header was renamed, we plug it back on
names(extracted)[length(extracted)] <- 'activity' 

# ---------- ITEM 5 ---------------- 
# TIDYING THE DATA
# Create separate data
sep <- extracted

# The variables can be factored into: 
#(1) Domain (T or F); (2) Acting Force (Gravity or Body); (3) Device (Gyroscope or Accelerometer) 
#(4) Statistical Summary (Mean or SD); #(5) Axes (X, Y, or Z); (6) Recorded Jerk (Yes or No); 
#(7) Recorded Magnitude (Yes or No)

# DOMAIN













