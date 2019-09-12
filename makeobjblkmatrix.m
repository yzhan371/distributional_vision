%% makeobjblkmatrix
%
% Make a 3D matrix containing pixel percentage for every object in either horizontal 
% or vertical blcoks in all or a subset of pictures in ADE20K dataset.
% 
%% Syntax
% 
% img_obj_matrices = makeobjblkmatrix(m);
% img_obj_matrices = makeobjblkmatrix(m,1:4,'h');
%
%% Description
% 
% Make a 3D matrix whose dimensions are n*m*i, where n stands for the number of objects
% in ADE20K dataset, m is the number of blocks, and i is the number of
% images. Each index stands for the proportion of pixels that stands for
% object n in block m.
% Required input arguments: m - number of blocks, range [2,8]; [] - subset of images, default
% value(input []): all images in ADE20K; direction of blocks: 'v' - vertical, 'h' -
% horizontal.
% ATTENTION: Must have ADE20K dataset in your working directory!
%
%% Example
%
%   img_obj_matrices = makeobjblkmatrix(2,[],'v');
%   img_obj_matrices = makeobjblkmatrix(3,[1,5,6,200:300],'h');
%
%% Author
% 
% Yiyuan Zhang, Michael F. Bonner | Johns Hopkins University
% 
%% Function

function matrices = makeobjblkmatrix(m,n,db,kb)

if nargin<1 || isempty(m)
    error('Please enter block number')
end

if m>8 || m<1
    error('Number of blocks must between 2 to 8')
end

if isempty(n)
    n= 1:22210;
end

if nargin<2
    n = 1:22210;
    db='v';
    kb = 0:(1/m):1;
    kb(1)=[];
end

if nargin<3 
    db='v';
    kb = 0:(1/m):1;
    kb(1)=[];
end

if nargin<4
    kb = 0:(1/m):1;
    kb(1)=[];
end

if length(kb)~= m
    error('Block proportion vector must have the same length as block number')
end

load('index_ade20k.mat');

if db=='v'
    num_img = length(n);
    matrices = zeros(length(index.objectnames),m,num_img,'single');
    for k = 1:num_img
        % load images
        img = n(k);
        filename = fullfile(index.folder{img}, index.filename{img});
        [Om,~] = loadAde20K(filename);
        % segement images
        [r,~] = size(Om);
        blocks = cell(m,1);
        for j = 1:length(blocks)
            if j==1
                blocks(j) = {Om(1:round(r*kb(j)),:)};
            else
                blocks(j) = {Om(round(r*kb(j-1)):round(r*kb(j)),:)};
            end
        end
        %initialize obj_loc matrix
        img_matrix = zeros(length(index.objectnames),m);
        %loop through blocks
        for i=1:m
            current = blocks{i};
            [a,b] = size(current);
            blkcount = a*b;
            objidx = setdiff(unique(current),0);
            % fill matrix for each object in each part
            for j= 1:length(objidx)
                obj = objidx(j);
                img_matrix(obj,i)= length(find(current==obj))/blkcount;
            end
        end
        % fill in cell array
        matrices(:,:,k)=img_matrix;
    end

    % find imgs containing parts
    parts = index.objectIsPart;
    obj_part = find(sum(parts,2)~=0);
    p = length(obj_part);
    where_part = [];
    for i = 1:p
        pnum = obj_part(i);
        where_part = [where_part,find(parts(pnum,:)~=0)];  
    end
    where_part = intersect(transpose(unique(where_part)),n);
    
    % include parts
    for k = 1:length(where_part)
        img_num = where_part(k);
        % load images
        filename = fullfile(index.folder{img_num}, index.filename{img_num});
        [~,~,Pm,~] = loadAde20K(filename);
        % segement images 
        [r,~] = size(Pm);
        blocks = cell(m,1);
        for j = 1:length(blocks)
            if j==1
                blocks(j) = {Pm(1:round(r*kb(j)),:,:)};
            else
                blocks(j) = {Pm(round(r*kb(j-1)):round(r*kb(j)),:,:)};
            end
        end 
        %initialize obj_loc matrix
        ppt_matrix = zeros(length(index.objectnames),m);
        %loop through 9 parts
        for i=1:m
            current = blocks{i};
            [a,b,d] = size(current);
            blkcount = a*b*d;
            ptidx = setdiff(unique(current),0);
            % fill matrix for each object in each part
            for j= 1:length(ptidx)
                obj = ptidx(j);
                ppt_matrix(obj,i)= length(find(current==obj))/blkcount;
            end
        end
        % fill in cell array
        matrices(:,:,img_num)=ppt_matrix + matrices(:,:,img_num);
    end
    
elseif db =='h'
    num_img = length(n);
    matrices = zeros(length(index.objectnames),m,num_img,'single');
    for k = 1:num_img
        % load images
        img = n(k);
        filename = fullfile(index.folder{img}, index.filename{img});
        [Om,~] = loadAde20K(filename);
        % segement images
        [~,c] = size(Om);
        blocks = cell(m,1);
        for j = 1:length(blocks)
            if j==1
                blocks(j) = {Om(:,1:round(c*kb(j)))};
            else
                blocks(j) = {Om(:,round(c*kb(j-1)):round(c*kb(j)))};
            end
        end
        %initialize obj_loc matrix
        img_matrix = zeros(length(index.objectnames),m);
        %loop through blocks
        for i=1:m
            current = blocks{i};
            [a,b] = size(current);
            blkcount = a*b;
            objidx = setdiff(unique(current),0);
            % fill matrix for each object in each part
            for j= 1:length(objidx)
                obj = objidx(j);
                img_matrix(obj,i)= length(find(current==obj))/blkcount;
            end
        end
        % fill in cell array
        matrices(:,:,k)=img_matrix;
    end

    % find imgs containing parts
    parts = index.objectIsPart;
    obj_part = find(sum(parts,2)~=0);
    p = length(obj_part);
    where_part = [];
    for i = 1:p
        pnum = obj_part(i);
        where_part = [where_part,find(parts(pnum,:)~=0)];  
    end
    where_part = intersect(transpose(unique(where_part)),n);
    
    % include parts
    for k = 1:length(where_part)
        img_num = where_part(k);
        % load images
        filename = fullfile(index.folder{img_num}, index.filename{img_num});
        [~,~,Pm,~] = loadAde20K(filename);
        % segement images 
        c = size(Pm,2);
        blocks = cell(m,1);
        for j = 1:length(blocks)
            if j==1
                blocks(j) = {Pm(:,1:round(c*kb(j)),:)};
            else
                blocks(j) = {Pm(:,round(c*kb(j-1)):round(c*kb(j)),:)};
            end
        end
        %initialize obj_loc matrix
        ppt_matrix = zeros(length(index.objectnames),m);
        %loop through 9 parts
        for i=1:m
            current = blocks{i};
            [a,b,d] = size(current);
            blkcount = a*b*d;
            ptidx = setdiff(unique(current),0);
            % fill matrix for each object in each part
            for j= 1:length(ptidx)
                obj = ptidx(j);
                ppt_matrix(obj,i)= length(find(current==obj))/blkcount;
            end
        end
        % fill in cell array
        matrices(:,:,img_num)=ppt_matrix + matrices(:,:,img_num);
    end

else
    error('Invalid direction input')
end

                     
end
