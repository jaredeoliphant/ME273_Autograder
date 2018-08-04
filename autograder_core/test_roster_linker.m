% Test for roster_linker with new deadline columns
sub_dir = '~/Downloads/lab9_subs/';
roster.name = 'roster.csv';
roster.path = '';
partName = 'Euler';
labNum = 9;

% set weights structure
weights.code = .8;
weights.header = .1;
weights.comments = .1;

regrading = 0;
dueDate = datetime(2018,3,19,16,0,0);
pseudoDate = datetime(2018,3,22,16,0,0);

% call infileprep
subFiles = in_file_prep(sub_dir);

% call roster_linker
linked = roster_linker(subFiles,roster,labNum,partName,weights,regrading,...
    dueDate,pseudoDate);