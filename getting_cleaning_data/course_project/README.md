---
title: "README"
author: "Dan Jahne"
date: "Sunday, April 26, 2015"
output: html_document
---

This script (run_analysis.R) is used to collect, clean, and summarize data from
smartphone accelerometers. It assumes that raw data are located in the working 
directory when called, in the structure described here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Specifically, it expects the following files:
<ul>
<li>".\\UCI HAR Dataset\\features.txt"</li>
<li>".\\UCI HAR Dataset\\activity_labels.txt"</li>
<li>".\\UCI HAR Dataset\\train\\X_train.txt"</li>
<li>".\\UCI HAR Dataset\\train\\subject_train.txt"</li>
<li>".\\UCI HAR Dataset\\train\\y_train.txt"</li>
<li>".\\UCI HAR Dataset\\test\\X_test.txt"</li>
<li>".\\UCI HAR Dataset\\test\\subject_test.txt"</li> 
<li>".\\UCI HAR Dataset\\test\\y_test.txt"</li>
</ul>

Usage:
```{r}
run_analysis()
```


Executing this script will create a new file in the working directory, "averageValuesBySubjectAndActivity.txt", which summarizes the data by each unique subject/activity combination.

Codebook:
<ul>
<li>subject: the identifier for the individual (subject) that this data is associated with</li>
<li>activity: the activity the subject was performing</li>
<li>Remaining columns are the average value across all observations for this specific subject/activity combination. Please see the following file for details: ".\\UCI HAR Dataset\\features_info.txt"</li>
</ul>
