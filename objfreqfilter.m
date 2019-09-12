%% objfreqfilter
%
% Obtain filtered matrices (names,objectpresence & other data) from the ADE20K dataset,  
% based on threshold n - object that occurs less than n times get filtered out. 
% 
%% Syntax
% 
% filtered_matrix = objfreqfilter(matrix);
% [filtered_matrix,op,names] = objfreqfilter(matrix,n)
%
%% Description
% 
% Filter input matrix (first dimension must be 3148) based on object courrance
% statistics in ADE20K dataset. Objects that occur less than n time get
% filterd out.
%  
% Required input arguments: matrix - matrix that need to be filtered, first dimension
% must be 3148;n - filtering threshold, objects that occur less than n
% times got filtered out, default value 20;
% 
% Output: filtered matrix- matrix whose rows that corresponding to low
% freq objects are deleted. op- filtered object presence matrix, for later
% ananlysis. names- filtered object name cell array, for ploting
% and reference purpose.
%
%% Example
%
%   filtered_v2b = objfreqfilter(v2b);
%   [filtered_h3b,op,names] = objfreqfilter(h3b,40);
%
%% Author
% 
% Yiyuan Zhang, Michael F. Bonner | Johns Hopkins University
% 
%% Function
function [filtered_matrices,op,names] = objfreqfilter(matrix,n)

load('index_ade20k.mat');

if nargin<2
    n=20;
end

if size(matrix,1)~= size(index.objectnames)
    error('Input dimension error')
end

objcount = index.objectcounts;
filtered_matrices = matrix;
filtered_matrices(objcount<n,:,:)=[];

op = index.objectPresence; 
op(objcount<n,:)=[];

names = transpose(index.objectnames);
names(objcount<n)=[];

end