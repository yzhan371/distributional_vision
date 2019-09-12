%%
% Load data
load('index_ade20k.mat');
%%
objcount = index.objectcounts;
% filter names
filtered_name = transpose(index.objectnames);
filtered_name(objcount<20)=[];
%% reference index
[~,a] = setdiff(index.objectnames,filtered_name);
b = 1:3148;
ref_idx = transpose(setdiff(b,a));