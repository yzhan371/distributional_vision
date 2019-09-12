%%
% Load data
load('index_ade20k.mat');

%% make 3-blcok obj_loc matrices 
% assign number of images you wish to generate matrix
n = length(index.filename);
img_matrices_3b = zeros(length(index.objectnames),3,n,'single');
for k = 1:n
    % load images
    filename = fullfile(index.folder{k}, index.filename{k});
    [Om,~] = loadAde20K(filename);
    % segement images
    [r,~] = size(Om);
    three_part = {Om(1:round(r/3),:),Om(round(r/3):round(r*2/3),:),...
    Om(round(r*2/3):r,:)}; 
    %initialize obj_loc matrix
    obj_loc_matrix_3b = zeros(length(index.objectnames),3);
    %loop through 9 parts
    for i=1:3
        current = three_part{i};
        [a,b] = size(current);
        blkcount = a*b;
        objidx = setdiff(unique(current),0);
        % fill matrix for each object in each part
        for j= 1:length(objidx)
            obj = objidx(j);
            obj_loc_matrix_3b(obj,i)= length(find(current==obj))/blkcount;
        end
    end
    % fill in cell array
    img_matrices_3b(:,:,k)=obj_loc_matrix_3b;
end

%% Include Parts
parts = index.objectIsPart;
obj_part = find(sum(parts,2)~=0);
n = length(obj_part);
where_part = [];
for i = 1:n
    pnum = obj_part(i);
    where_part = [where_part,find(parts(pnum,:)~=0)];  
end
where_part = transpose(unique(where_part));
%%
m = length(where_part);
img_matrices_wpt_3b = img_matrices_3b;
for k = 1:m
    img_num = where_part(k);
    % load images
    filename = fullfile(index.folder{img_num}, index.filename{img_num});
    [~,~,Pm,~] = loadAde20K(filename);
    % segement images 
    [r,~] = size(Pm);
    three_part = {Pm(1:round(r/3),:,:),Pm(round(r/3):round(r*2/3),:,:),...
    Pm(round(r*2/3):r,:,:)}; 
    %initialize obj_loc matrix
    pt_loc_matrix_3b = zeros(length(index.objectnames),3);
    %loop through 9 parts
    for i=1:3
        current = three_part{i};
        [a,b,d] = size(current);
        blkcount = a*b*d;
        ptidx = setdiff(unique(current),0);
        % fill matrix for each object in each part
        for j= 1:length(ptidx)
            obj = ptidx(j);
            pt_loc_matrix_3b(obj,i)= length(find(current==obj))/blkcount;
        end
    end
    % fill in cell array
    img_matrices_wpt_3b(:,:,img_num)=pt_loc_matrix_3b + img_matrices_3b(:,:,img_num);
end