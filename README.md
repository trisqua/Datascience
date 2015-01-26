In order to be able to run the 'run_analysis.R' script, make sure to go through these steps:

* your working directory should directly contain the 'activity-labels.txt' and 'features.txt' files and both the 'test' and 'train' folder
(i.e. place the 'run_analysis.R' script in the 'UCI HAR Dataset' folder)
* install and load the 'plyr' package (if you haven't done that already) 

The script takes the following steps:
1. read files 'activity_label', 'features', 'subject_test', 'y_test', 'X_test', 'subject_train', 'y_train', 'X_train' into dataframes: activities, features, testSubject, testActivity, testDataRaw, trainSubject, trainActivity, trainDataRaw

2. add names to all dataframes: use the names from 'features' as columnnames for testDataRaw and trainDataRaw. The set 'subjectNo' as columnname for test/trainSubject, set 'activityNo' as columnname for test/trainActivity and 'activityNo','activity' as names for the 'activities' dataframe

3. bind the columns with subjects and activities to the left of the 'test' dataframe and the 'train' dataframe
(and rename the dataframes testData and trainData)

4. adding a column with activities to both the testDataRaw and trainDataRaw dataframes (by joining them with the 'activities' dataframe)

5. rearrange either dataframe: move the column with activitynames to the 2nd column and removing the 'activityNo' column (i.e. the column with activity numbers)

6. merge the two dataframes. Since the column names are the same, this is done by a simple 'rbind' command. We rename the dataframe to sensorData

7. we are only interested in columns that contain either a mean or a std. We apply a logical vector to the sensorData dataframe to keep those columns. The logical vector uses the 'grepl' command, which returns a TRUE or FALSE for each column that contains the substring you specify.
The argument for the grepl command is 'mean[^F]|std'. This is true for any substring that contains 'mean' but not 'meanF', or 'std'.
The first two columns of the sensorData dataframe are now bound (with cbind) to all columns that contain either 'mean' (and not 'meanF') or 'std'; the result is sensorDataClean.

8. In this step, the rows are grouped by 'subjectNo' and 'activity' (in that order) and the mean is calculated for each of those groups. 
Since there were 30 subjects and 6 activities and only 66 columns with measures, the resulting dataframe has 180 rows and 68 columns.

9. The last step: tidying up the dataset a little. All bashes and parentheses are removed from the column names and the names containing 'BodyBody' are corrected to contain just 'Body'.