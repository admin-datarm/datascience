==================================================================
Tidy Dataset of Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Zhao Migli
==================================================================

This is a work for Coursera assignment.


The script submitted achieve flowing tidy tasks:
=========================================

- Merge the training and test data with activity and subject columns using cbind and rbind R function.

- Label the merged dataset's columns by loading data from "features.txt", and appending additional two columns "activity_no" and "subject".

- Extract mean and standard deviation related columns by grep R function.

- Name the activities of the dataset with descriptive activity names with merge R funciton.

- Calculate the mean value of each variables grouped by activity and subject variables by using R function group_by and summarise_each.

Contents:
======
This repository files below are :
- README.md, readme file 
- mean_dataset.csv, tidy dataset file
- run_analysis.R, R script generated the dataset.
- CodeBook.md , the codebook file.


Notes: 
======
The script can be run when the Samsung data is put at relative path "../R/wearable" along side with this R script file "run_analysis.R".

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
