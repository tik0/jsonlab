% Load JSON file and parse it
close all;
clear all;

disp('ST: Single thread using loadjsonpar');
disp('MT: Multi thread with 2 parallel worker using loadjsonpar');
disp('CO: Common execution using loadjson');

POOLNUM = 2;
addpath('..');
FILENAME = './1000.json';

parsingOption.SimplifyCall = 0;
parsingOption.FastArrayParser = 1;
parsingOption.ShowProgress = 0;

%% ST
tic
loadjsonpar(FILENAME, parsingOption);
disp(['ST: ', num2str(toc), ' seconds']);

%% MT
try
  parpool(POOLNUM);
catch
  disp('Just go on')
end
tic
loadjsonpar(FILENAME, parsingOption);
disp(['MT: ', num2str(toc), ' seconds']);
delete(gcp('nocreate')); % close the parallel pool

%% CO
tic
loadjson(FILENAME, parsingOption);
disp(['CO: ', num2str(toc), ' seconds']);