function files = get_grader_dir(grader_dir)

% Get files in grader directory
files = dir(grader_dir);

% Remove invalid filenames
files(1:2) = [];

end