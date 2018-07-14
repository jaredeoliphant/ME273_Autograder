# ME273_Autograder
This project is meant to be used for BYU's ME 273 course, to assist in the quick and consistent grading of programming assignments. At this point, it is run via command-line Matlab scripts, and capable of grading lab assignments with multiple parts and creating a dynamic .csv file with all of the scoring and feedback in it.

The basic operation is to specify the general inputs for the lab, and then to create a cell array of structures with the particular inputs for each lab part, and finally to call the autograder function with these parameters.

Each lab part relies on a grader file that runs a student's function submission and returns a normalized score for how well the code ran, as well as a character array of feedback for the student based on its outputs.

Any student file submissions that are incorrectly named will be discarded. File submissions should be named as follows:

LabPartName_XXXX.m - where XXXX corresponds to the 4-digit course ID number for that student.

The program can operate in basically two modes: original grading mode creates a new dynamic .csv file with all of the students' grades, info, and feedback for that lab in it, or (if a file is specified), reads it back in and appends any new student submissions for that lab (taking into account section deadlines). The other mode is a "re-grading" mode, where student submissions can be submitted up to a week late for a maximum of 80% credit. This mode will also use an existing grades file to determine whether re-grading should be done or whether existing scores and feedback should be used.

## Basic Operation
The main function for this program is the autograder.m function, found in the autograder_core folder. It requires the following inputs: the lab number, the roster file, the weights for the different elements of grading, and a cell array of structures for the lab parts, a flag indicating whether regrading is being performed or not, the date and time that the program should assume to be "now" (termed a "pseudo-date" here), and (optionally) an existing grades file to read in.

The roster file should be a structure consisting of two fields: the file name (roster.name) and the file path (roster.path). The roster itself should be a .csv with at least the following columns: LastName, FirstName, Email, CourseID, SectionNumber. The CourseID for each student should be a unique, four-digit number that will be used to match them to their lab submissions.

The autograder grades each assignment in three ways: it checks that their code functions, it checks for a specific file header format, and it checks for comments in the code. The weights parameter should be a structure with three fields (code, header, comments) with decimal values that add up to 1.0.

The final parameter is a cell array of structures with the following fields: the name of the lab part, its due date (as a Matlab datetime object), the directory where all of the submissions for that part are stored, and a structure with the name and path of the grader file.

The "pseudodate" allows the grader to specify any date and time for the program assume as "now." This enables flexibility in testing and re-grading, as well as computers that may not have their date/time configured correctly.

## Notes on the Graded Lab
The autograder creates a .csv file with all of the roster student info, the lab parts and their scores, and then the feedback at the end. Any submissions that were not properly matched to a student course ID are graded anyways, and their grades and feedback are appended to the end of the .csv file. The compiled scores for the lab parts and the overall lab are written as formulas in order for the .csv to be easily edited manually after the program is run.

The formulas are written in the R1C1 format. Both Microsoft Excel and LibreCalc programs have the ability to interpret formulas in the R1C1 format by changing program options. Without changing this option, the spreadsheet program will not read in the file correctly.
