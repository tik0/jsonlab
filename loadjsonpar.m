function data = loadjsonpar(fname,opt)
%
% data=loadjson(fname,opt)
%
% wrapper to parse a JSON (JavaScript Object Notation) file much faster
%
% authors: Timo Korthals (tkorthals<at>it-ec.uni-bielefeld.de)
% created on 2016/08/22
%
% input:
%      fname: input file name, containing JSON objects
%      opt: a struct as discribed in loadjson.m
%
% output:
%      data: a cell array, where {...} blocks are converted into cell arrays,
%           and [...] are converted to arrays
%
% examples:
%      data=loadjson('../myFile.json')
%      data=loadjson('../myFile.json', opt)
%
% license:
%     BSD or GPL version 3, see LICENSE_{BSD,GPLv3}.txt files for details 
%

%% Check the parallel pool
p = gcp('nocreate'); % If no pool, do not create new one.
poolsize = 0;
if ~isempty(p)
    poolsize = p.NumWorkers;
    disp(['Parse with ', num2str(poolsize), ' parallel worker']);
else
    warning('No parallel pool found. Uses single thread.');
end

%% Load the JSON file and format it, so that one line holds one object
dataTxt = fileread(fname);
% Remove all new lines
dataTxt = regexprep(dataTxt,'\n','');
% Insert a new line at object boundaries
dataTxt = regexprep(dataTxt,'}{','}\n{');
% Split the data
dataTxt = strsplit(dataTxt,'\n');
% Prune emtpy lines
dataTxt = dataTxt(~cellfun(@(a) isempty(a),dataTxt));

% Preallocation
data = cell(size(dataTxt));

%% Parsing
if poolsize
    parfor idx = 1 : numel(dataTxt)
        data{idx} = loadjson(dataTxt{idx}, opt);
    end
else
    for idx = 1 : numel(dataTxt)
        data{idx} = loadjson(dataTxt{idx}, opt);
    end
end

end