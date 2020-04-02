function forcedat = importLoadsolAndroid(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  KHLACEPOST1 = IMPORTFILE1(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  KHLACEPOST1 = IMPORTFILE1(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  KHLacepost1 = importfile1("C:\Users\Daniel.Feeney\Dropbox (Boa)\Endurance Protocol Trail Run\Outdoor_Protocol_March2020\KH\KH_Lace_post_1.txt", [5, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 02-Apr-2020 14:16:22

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [5, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["VarName1", "Heel", "Medial", "Lateral", "SGV006L", "VarName6", "Lateral1", "Medial1", "Heel1", "SGV005R", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [11, 12, 13, 14, 15], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [11, 12, 13, 14, 15], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
forcedat = readtable(filename, opts);

end