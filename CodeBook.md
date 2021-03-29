CodeBook
================
KennethFajardo
3/29/2021

# Getting and Cleaning Data Project

This project aims to clean the data from an experiment on recognizing
human acitivty using smartphones, which has an output of different
values across different measurements. This documentation comprehensively
explains the processes involved in tidying the data.

## Getting the data

The raw data is downloaded from
[here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
This contains an archive of testing and training data with labels that
are separated into other other files. The files are, then, extracted
from the archive using WinRAR.

## Loading the needed libraries

The libraries used for this project are:

``` r
library(tidyr)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(data.table)
```

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

``` r
library(reshape2)
```

    ## 
    ## Attaching package: 'reshape2'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     dcast, melt

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     smiths

## Reading the training and testing data sets

The utilized function for reading the data is the *fread()* function.

``` r
# Read the training and testing sets

X_train <- fread("./train/X_train.txt") 
y_train <- fread("./train/y_train.txt") 
X_test <- fread("./test/X_test.txt")
y_test <- fread("./test/y_test.txt")

# Read the test subject ID sets
S_train <- fread("./train/subject_train.txt")
S_test <- fread("./test/subject_test.txt")
```

## Merging the training and the test sets to create one data set

The column headers for the subject (S) and activity (Y) files are
renamed for readability.

``` r
names(S_train) <- "ID"
names(S_test) <- "ID"
names(y_train) <- "act"
names(y_test) <- "act"
```

Add the subject and activity columns to the training and testing data.

``` r
# Add the subject ID column to both testing and training data
X_train <- cbind(S_train, X_train)
X_test <- cbind(S_test, X_test)

# Add y_train as a new column to X_train
train <- cbind(X_train, y_train)
test <- cbind(X_test, y_test)
```

Merge the training and testing data.

``` r
rawData <- rbind(train,test)
str(rawData)
```

    ## Classes 'data.table' and 'data.frame':   10299 obs. of  563 variables:
    ##  $ ID  : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
    ##  $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
    ##  $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
    ##  $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
    ##  $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
    ##  $ V6  : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
    ##  $ V7  : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
    ##  $ V8  : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
    ##  $ V9  : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
    ##  $ V10 : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
    ##  $ V11 : num  -0.567 -0.558 -0.558 -0.576 -0.569 ...
    ##  $ V12 : num  -0.744 -0.818 -0.818 -0.83 -0.825 ...
    ##  $ V13 : num  0.853 0.849 0.844 0.844 0.849 ...
    ##  $ V14 : num  0.686 0.686 0.682 0.682 0.683 ...
    ##  $ V15 : num  0.814 0.823 0.839 0.838 0.838 ...
    ##  $ V16 : num  -0.966 -0.982 -0.983 -0.986 -0.993 ...
    ##  $ V17 : num  -1 -1 -1 -1 -1 ...
    ##  $ V18 : num  -1 -1 -1 -1 -1 ...
    ##  $ V19 : num  -0.995 -0.998 -0.999 -1 -1 ...
    ##  $ V20 : num  -0.994 -0.999 -0.997 -0.997 -0.998 ...
    ##  $ V21 : num  -0.988 -0.978 -0.965 -0.984 -0.981 ...
    ##  $ V22 : num  -0.943 -0.948 -0.975 -0.986 -0.991 ...
    ##  $ V23 : num  -0.408 -0.715 -0.592 -0.627 -0.787 ...
    ##  $ V24 : num  -0.679 -0.501 -0.486 -0.851 -0.559 ...
    ##  $ V25 : num  -0.602 -0.571 -0.571 -0.912 -0.761 ...
    ##  $ V26 : num  0.9293 0.6116 0.273 0.0614 0.3133 ...
    ##  $ V27 : num  -0.853 -0.3295 -0.0863 0.0748 -0.1312 ...
    ##  $ V28 : num  0.36 0.284 0.337 0.198 0.191 ...
    ##  $ V29 : num  -0.0585 0.2846 -0.1647 -0.2643 0.0869 ...
    ##  $ V30 : num  0.2569 0.1157 0.0172 0.0725 0.2576 ...
    ##  $ V31 : num  -0.2248 -0.091 -0.0745 -0.1553 -0.2725 ...
    ##  $ V32 : num  0.264 0.294 0.342 0.323 0.435 ...
    ##  $ V33 : num  -0.0952 -0.2812 -0.3326 -0.1708 -0.3154 ...
    ##  $ V34 : num  0.279 0.086 0.239 0.295 0.44 ...
    ##  $ V35 : num  -0.4651 -0.0222 -0.1362 -0.3061 -0.2691 ...
    ##  $ V36 : num  0.4919 -0.0167 0.1739 0.4821 0.1794 ...
    ##  $ V37 : num  -0.191 -0.221 -0.299 -0.47 -0.089 ...
    ##  $ V38 : num  0.3763 -0.0134 -0.1247 -0.3057 -0.1558 ...
    ##  $ V39 : num  0.4351 -0.0727 -0.1811 -0.3627 -0.1898 ...
    ##  $ V40 : num  0.661 0.579 0.609 0.507 0.599 ...
    ##  $ V41 : num  0.963 0.967 0.967 0.968 0.968 ...
    ##  $ V42 : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
    ##  $ V43 : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
    ##  $ V44 : num  -0.985 -0.997 -1 -0.997 -0.998 ...
    ##  $ V45 : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
    ##  $ V46 : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
    ##  $ V47 : num  -0.985 -0.998 -1 -0.996 -0.998 ...
    ##  $ V48 : num  -0.984 -0.99 -0.993 -0.981 -0.989 ...
    ##  $ V49 : num  -0.895 -0.933 -0.993 -0.978 -0.979 ...
    ##  $ V50 : num  0.892 0.892 0.892 0.894 0.894 ...
    ##  $ V51 : num  -0.161 -0.161 -0.164 -0.164 -0.167 ...
    ##  $ V52 : num  0.1247 0.1226 0.0946 0.0934 0.0917 ...
    ##  $ V53 : num  0.977 0.985 0.987 0.987 0.987 ...
    ##  $ V54 : num  -0.123 -0.115 -0.115 -0.121 -0.122 ...
    ##  $ V55 : num  0.0565 0.1028 0.1028 0.0958 0.0941 ...
    ##  $ V56 : num  -0.375 -0.383 -0.402 -0.4 -0.4 ...
    ##  $ V57 : num  0.899 0.908 0.909 0.911 0.912 ...
    ##  $ V58 : num  -0.971 -0.971 -0.97 -0.969 -0.967 ...
    ##  $ V59 : num  -0.976 -0.979 -0.982 -0.982 -0.984 ...
    ##  $ V60 : num  -0.984 -0.999 -1 -0.996 -0.998 ...
    ##  $ V61 : num  -0.989 -0.99 -0.992 -0.981 -0.991 ...
    ##  $ V62 : num  -0.918 -0.942 -0.993 -0.98 -0.98 ...
    ##  $ V63 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
    ##  $ V64 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
    ##  $ V65 : num  0.114 -0.21 -0.927 -0.596 -0.617 ...
    ##  $ V66 : num  -0.59042 -0.41006 0.00223 -0.06493 -0.25727 ...
    ##  $ V67 : num  0.5911 0.4139 0.0275 0.0754 0.2689 ...
    ##  $ V68 : num  -0.5918 -0.4176 -0.0567 -0.0858 -0.2807 ...
    ##  $ V69 : num  0.5925 0.4213 0.0855 0.0962 0.2926 ...
    ##  $ V70 : num  -0.745 -0.196 -0.329 -0.295 -0.167 ...
    ##  $ V71 : num  0.7209 0.1253 0.2705 0.2283 0.0899 ...
    ##  $ V72 : num  -0.7124 -0.1056 -0.2545 -0.2063 -0.0663 ...
    ##  $ V73 : num  0.7113 0.1091 0.2576 0.2048 0.0671 ...
    ##  $ V74 : num  -0.995 -0.834 -0.705 -0.385 -0.237 ...
    ##  $ V75 : num  0.996 0.834 0.714 0.386 0.239 ...
    ##  $ V76 : num  -0.996 -0.834 -0.723 -0.387 -0.241 ...
    ##  $ V77 : num  0.992 0.83 0.729 0.385 0.241 ...
    ##  $ V78 : num  0.57 -0.831 -0.181 -0.991 -0.408 ...
    ##  $ V79 : num  0.439 -0.866 0.338 -0.969 -0.185 ...
    ##  $ V80 : num  0.987 0.974 0.643 0.984 0.965 ...
    ##  $ V81 : num  0.078 0.074 0.0736 0.0773 0.0734 ...
    ##  $ V82 : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
    ##  $ V83 : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
    ##  $ V84 : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
    ##  $ V85 : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
    ##  $ V86 : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
    ##  $ V87 : num  -0.994 -0.996 -0.991 -0.994 -0.997 ...
    ##  $ V88 : num  -0.986 -0.979 -0.979 -0.986 -0.987 ...
    ##  $ V89 : num  -0.993 -0.991 -0.987 -0.991 -0.991 ...
    ##  $ V90 : num  -0.985 -0.995 -0.987 -0.987 -0.997 ...
    ##  $ V91 : num  -0.992 -0.979 -0.979 -0.992 -0.992 ...
    ##  $ V92 : num  -0.993 -0.992 -0.992 -0.99 -0.99 ...
    ##  $ V93 : num  0.99 0.993 0.988 0.988 0.994 ...
    ##  $ V94 : num  0.992 0.992 0.992 0.993 0.993 ...
    ##  $ V95 : num  0.991 0.989 0.989 0.993 0.986 ...
    ##  $ V96 : num  -0.994 -0.991 -0.988 -0.993 -0.994 ...
    ##  $ V97 : num  -1 -1 -1 -1 -1 ...
    ##  $ V98 : num  -1 -1 -1 -1 -1 ...
    ##   [list output truncated]
    ##  - attr(*, ".internal.selfref")=<externalptr>

## Extracting the measurements on the mean and standard deviation for each measurement

The measurements are contained within the file “features.txt”. Read the
file.

``` r
features <- fread("features.txt")
```

Extract the rows containing the substring “mean()” and “std()”.

``` r
features <- features[grep("mean\\(\\)|std\\(\\)",features$V2)]
```

Modify the feature ID column to be of the same format as rawData
(i.e. “V{feature\_ID}” and drop the feature name column.

``` r
features$V1 <- features[,paste("V", features$V1, sep="")]
str(features)
```

    ## Classes 'data.table' and 'data.frame':   66 obs. of  2 variables:
    ##  $ V1: chr  "V1" "V2" "V3" "V4" ...
    ##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

Extract the columns from the raw data which are in the variable
“features”.

``` r
extracted <- cbind(ID=rawData$ID ,rawData[, features$V1, with=FALSE], act=rawData$act)
```

## Use descriptive activity names to name the activities in the data set

Retrieve the activity labels from “activity\_labels.txt”, and rename the
columns.

``` r
activity <- fread("activity_labels.txt") 
names(activity) <- c("ID", "activity")
head(activity)
```

    ##    ID           activity
    ## 1:  1            WALKING
    ## 2:  2   WALKING_UPSTAIRS
    ## 3:  3 WALKING_DOWNSTAIRS
    ## 4:  4            SITTING
    ## 5:  5           STANDING
    ## 6:  6             LAYING

Replace the activity column in the raw data with its corresponding
acitivity name.

``` r
extracted <- mutate(extracted, act=activity[act, 2])
```

## Appropriately label the data set with descriptive variable names

Melt the data in order to easily separate the variables.

``` r
extracted <- as.data.table(extracted)
setkey(extracted, ID, act)
extracted <- melt(setDT(extracted), key(extracted), variable.name="feature.ID")
```

Replace the feature ID in the raw data with its corresponding feature
name.

``` r
extracted <- merge(x=extracted, y=features[, list(V1, V2)], by.x="feature.ID", by.y = "V1", all.x = TRUE)
```

Since this column header was renamed, we plug it back on.

``` r
names(extracted)[length(extracted)] <- 'feature.name' 
```

Drop feature.ID column to avoid redundancy.

``` r
extracted$feature.ID <- NULL
head(extracted)
```

    ##    ID    act     value      feature.name
    ## 1:  1 LAYING 0.4034743 tBodyAcc-mean()-X
    ## 2:  1 LAYING 0.2783732 tBodyAcc-mean()-X
    ## 3:  1 LAYING 0.2765553 tBodyAcc-mean()-X
    ## 4:  1 LAYING 0.2795748 tBodyAcc-mean()-X
    ## 5:  1 LAYING 0.2765270 tBodyAcc-mean()-X
    ## 6:  1 LAYING 0.2781233 tBodyAcc-mean()-X

## Create a second, independent tidy data set with the average of each variable for each activity and each subject

Create separate data

``` r
sep <- extracted
```

The variables can be factored into: 1. Domain (T or F) 2. Acting Force
(Gravity or Body) 3. Device (Gyroscope or Accelerometer) 4. Statistical
Summary (Mean or SD) 5. Axes (X, Y, or Z) 6. Jerk, Magnitude or NA
Feature names are split according to the variables above using the
separate function from dplyr. Separating the columns might take a few
seconds. The warnings below say that the labels that do not belong to
any of the factors are resolved as <NA>.

``` r
# DOMAIN
sep <- sep %>% separate(col=feature.name, into=c("domain", "temp"), sep="(?<=^.)(?=[A-Z])")

# STAT and AXES
sep <- sep %>% separate(col=temp, into=c("temp", "stat", "axes"), sep="-")
```

    ## Warning: Expected 3 pieces. Missing pieces filled with `NA` in 185382 rows
    ## [144187, 144188, 144189, 144190, 144191, 144192, 144193, 144194, 144195,
    ## 144196, 144197, 144198, 144199, 144200, 144201, 144202, 144203, 144204, 144205,
    ## 144206, ...].

``` r
# FORCE, DEVICE and JERK_MAG
sep <- sep %>% separate(col=temp, into=c("force", "device", "jerk_mag"), sep="(?<=.)(?=[A-Z])")
```

    ## Warning: Expected 3 pieces. Additional pieces discarded in 102990 rows [185383,
    ## 185384, 185385, 185386, 185387, 185388, 185389, 185390, 185391, 185392, 185393,
    ## 185394, 185395, 185396, 185397, 185398, 185399, 185400, 185401, 185402, ...].

    ## Warning: Expected 3 pieces. Missing pieces filled with `NA` in 308970 rows [1,
    ## 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ...].

Replace the factors to make them more readable.

``` r
sep[domain == "t", 4] <- "Time"
sep[domain == "f", 4] <- "Frequency"
sep[device == "Acc", 6] <- "Accelerator"
sep[device == "Gyro", 6] <- "Gyroscope"
sep[jerk_mag == "Mag", 7] <- "Magnitude"
sep[stat == "mean()", 8] <- "Mean"
sep[stat == "std()", 8] <- "StanDev"
```

Summarize the data, adding in the count and mean for each unique
measurement per subject.

``` r
setkey(sep, ID, act, force, domain, device, jerk_mag, stat, axes)
tidyData <- sep[, list(count=.N, average=mean(value)), by=key(sep)]
head(tidyData, 50)
```

    ##     ID    act force    domain      device  jerk_mag    stat axes count
    ##  1:  1 LAYING  Body Frequency Accelerator      <NA>    Mean    X    50
    ##  2:  1 LAYING  Body Frequency Accelerator      <NA>    Mean    Y    50
    ##  3:  1 LAYING  Body Frequency Accelerator      <NA>    Mean    Z    50
    ##  4:  1 LAYING  Body Frequency Accelerator      <NA> StanDev    X    50
    ##  5:  1 LAYING  Body Frequency Accelerator      <NA> StanDev    Y    50
    ##  6:  1 LAYING  Body Frequency Accelerator      <NA> StanDev    Z    50
    ##  7:  1 LAYING  Body Frequency Accelerator      Jerk    Mean    X    50
    ##  8:  1 LAYING  Body Frequency Accelerator      Jerk    Mean    Y    50
    ##  9:  1 LAYING  Body Frequency Accelerator      Jerk    Mean    Z    50
    ## 10:  1 LAYING  Body Frequency Accelerator      Jerk StanDev    X    50
    ## 11:  1 LAYING  Body Frequency Accelerator      Jerk StanDev    Y    50
    ## 12:  1 LAYING  Body Frequency Accelerator      Jerk StanDev    Z    50
    ## 13:  1 LAYING  Body Frequency Accelerator Magnitude    Mean <NA>    50
    ## 14:  1 LAYING  Body Frequency Accelerator Magnitude StanDev <NA>    50
    ## 15:  1 LAYING  Body Frequency        Body       Acc    Mean <NA>    50
    ## 16:  1 LAYING  Body Frequency        Body       Acc StanDev <NA>    50
    ## 17:  1 LAYING  Body Frequency        Body      Gyro    Mean <NA>   100
    ## 18:  1 LAYING  Body Frequency        Body      Gyro StanDev <NA>   100
    ## 19:  1 LAYING  Body Frequency   Gyroscope      <NA>    Mean    X    50
    ## 20:  1 LAYING  Body Frequency   Gyroscope      <NA>    Mean    Y    50
    ## 21:  1 LAYING  Body Frequency   Gyroscope      <NA>    Mean    Z    50
    ## 22:  1 LAYING  Body Frequency   Gyroscope      <NA> StanDev    X    50
    ## 23:  1 LAYING  Body Frequency   Gyroscope      <NA> StanDev    Y    50
    ## 24:  1 LAYING  Body Frequency   Gyroscope      <NA> StanDev    Z    50
    ## 25:  1 LAYING  Body      Time Accelerator      <NA>    Mean    X    50
    ## 26:  1 LAYING  Body      Time Accelerator      <NA>    Mean    Y    50
    ## 27:  1 LAYING  Body      Time Accelerator      <NA>    Mean    Z    50
    ## 28:  1 LAYING  Body      Time Accelerator      <NA> StanDev    X    50
    ## 29:  1 LAYING  Body      Time Accelerator      <NA> StanDev    Y    50
    ## 30:  1 LAYING  Body      Time Accelerator      <NA> StanDev    Z    50
    ## 31:  1 LAYING  Body      Time Accelerator      Jerk    Mean <NA>    50
    ## 32:  1 LAYING  Body      Time Accelerator      Jerk    Mean    X    50
    ## 33:  1 LAYING  Body      Time Accelerator      Jerk    Mean    Y    50
    ## 34:  1 LAYING  Body      Time Accelerator      Jerk    Mean    Z    50
    ## 35:  1 LAYING  Body      Time Accelerator      Jerk StanDev <NA>    50
    ## 36:  1 LAYING  Body      Time Accelerator      Jerk StanDev    X    50
    ## 37:  1 LAYING  Body      Time Accelerator      Jerk StanDev    Y    50
    ## 38:  1 LAYING  Body      Time Accelerator      Jerk StanDev    Z    50
    ## 39:  1 LAYING  Body      Time Accelerator Magnitude    Mean <NA>    50
    ## 40:  1 LAYING  Body      Time Accelerator Magnitude StanDev <NA>    50
    ## 41:  1 LAYING  Body      Time   Gyroscope      <NA>    Mean    X    50
    ## 42:  1 LAYING  Body      Time   Gyroscope      <NA>    Mean    Y    50
    ## 43:  1 LAYING  Body      Time   Gyroscope      <NA>    Mean    Z    50
    ## 44:  1 LAYING  Body      Time   Gyroscope      <NA> StanDev    X    50
    ## 45:  1 LAYING  Body      Time   Gyroscope      <NA> StanDev    Y    50
    ## 46:  1 LAYING  Body      Time   Gyroscope      <NA> StanDev    Z    50
    ## 47:  1 LAYING  Body      Time   Gyroscope      Jerk    Mean <NA>    50
    ## 48:  1 LAYING  Body      Time   Gyroscope      Jerk    Mean    X    50
    ## 49:  1 LAYING  Body      Time   Gyroscope      Jerk    Mean    Y    50
    ## 50:  1 LAYING  Body      Time   Gyroscope      Jerk    Mean    Z    50
    ##     ID    act force    domain      device  jerk_mag    stat axes count
    ##          average
    ##  1: -0.939099052
    ##  2: -0.867065205
    ##  3: -0.882666876
    ##  4: -0.924437435
    ##  5: -0.833625556
    ##  6: -0.812891559
    ##  7: -0.957073884
    ##  8: -0.922462610
    ##  9: -0.948060904
    ## 10: -0.964160709
    ## 11: -0.932217870
    ## 12: -0.960586987
    ## 13: -0.861767648
    ## 14: -0.798300940
    ## 15: -0.933300361
    ## 16: -0.921803976
    ## 17: -0.902278566
    ## 18: -0.878490054
    ## 19: -0.850249175
    ## 20: -0.952191495
    ## 21: -0.909302721
    ## 22: -0.882296451
    ## 23: -0.951232049
    ## 24: -0.916582508
    ## 25:  0.221598244
    ## 26: -0.040513953
    ## 27: -0.113203554
    ## 28: -0.928056469
    ## 29: -0.836827406
    ## 30: -0.826061402
    ## 31: -0.954396265
    ## 32:  0.081086534
    ## 33:  0.003838204
    ## 34:  0.010834236
    ## 35: -0.928245628
    ## 36: -0.958482112
    ## 37: -0.924149274
    ## 38: -0.954855111
    ## 39: -0.841929152
    ## 40: -0.795144864
    ## 41: -0.016553094
    ## 42: -0.064486124
    ## 43:  0.148689436
    ## 44: -0.873543868
    ## 45: -0.951090440
    ## 46: -0.908284663
    ## 47: -0.963461030
    ## 48: -0.107270949
    ## 49: -0.041517287
    ## 50: -0.074050121
    ##          average

``` r
str(tidyData)
```

    ## Classes 'data.table' and 'data.frame':   11520 obs. of  10 variables:
    ##  $ ID      : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ act     : chr  "LAYING" "LAYING" "LAYING" "LAYING" ...
    ##  $ force   : chr  "Body" "Body" "Body" "Body" ...
    ##  $ domain  : chr  "Frequency" "Frequency" "Frequency" "Frequency" ...
    ##  $ device  : chr  "Accelerator" "Accelerator" "Accelerator" "Accelerator" ...
    ##  $ jerk_mag: chr  NA NA NA NA ...
    ##  $ stat    : chr  "Mean" "Mean" "Mean" "StanDev" ...
    ##  $ axes    : chr  "X" "Y" "Z" "X" ...
    ##  $ count   : int  50 50 50 50 50 50 50 50 50 50 ...
    ##  $ average : num  -0.939 -0.867 -0.883 -0.924 -0.834 ...
    ##  - attr(*, "sorted")= chr  "ID" "act" "force" "domain" ...
    ##  - attr(*, ".internal.selfref")=<externalptr>
