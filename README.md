# ME273_Autograder
This project is meant to be used for BYU's ME 273 course, to assist in the quick and consistent grading of Matlab programming assignments.

Basic operation is described below, and in more detail in the documentation in 'development_docs'.

Training videos can be accessed at [this link](https://www.youtube.com/channel/UCdVW8Mezn3Rv6SGG9mDs-9A/playlists).

## Basic Operation
To run the ME 273 Autograder, download the files, navigate to the directory 'autograder_core', and run 'main.m'. This should create a graphical user interface (GUI) that will walk you through the process of selecting a lab, specifying the due date, grader function, and file submissions, and then grading them.

During the operation of this program, you should be prompted as to whether you have uploaded the grades to Learning Suite or not. At this point, navigate to 'autograder_core/GradedLabs' and find the appropriate lab folder, 'LabXGraded' (where X is the number of the lab that you are grading). You should see a file named 'ME273LabFeedback.csv'. This can be uploaded to Learning Suite, using the 'Email' column as a student identifier and the 'LabXScore' as the lab score.

You will then be prompted as to whether you have uploaded to Google Drive and sent out feedback. The same file that you uploaded to Learning Suite should be dropped into the ME273 Google Drive in the 'ME273_Feedback' folder, and then the 'Autograder Feedback Giver' script should be run. If you want to test the feedback system, run the 'Test.gs' file; otherwise, run 'Main.gs'.

At the end of this process, a dynamic .csv file is generated that can be read by any spreadsheet program, PROVIDED IT ALLOWS YOU TO SPECIFY [RC] CELL REFERENCE METHOD. A static version of this .csv is also written to the 'graded_labs/LabXGraded/Archives' folder. The dynamic .csv is meant to be accessible for manual grade or due-date edits; these manual edits perpetuate through future grading sessions using 'main.m'.

## Notes
* Dynamic spreadsheets can only be read and edited by spreadsheet programs that can specify RC cell reference format.
* Students that name their files incorrectly (e.g. do not append an underscore and their course ID to their filenames, or mix up their course ID number) will not be graded in the current system.
