%%
% Load data
load('index_ade20k.mat');

%% make gradient obj_loc matrices 
% assign number of images you wish to generate matrix
n = length(index.filename);
img_matrices = zeros(length(index.objectnames),9,n,'single');
for k = 1:n
    % load images
    filename = fullfile(index.folder{k}, index.filename{k});
    [Om,~] = loadAde20K(filename);
    % segement images
    [r,c] = size(Om);
    nine_part = {Om(1:round(r/3),1:round(c/3)),Om(1:round(r/3),round(c/3):round(c*2/3)),...
    Om(1:round(r/3),round(c*2/3):c),Om(round(r/3):round(r*2/3),1:round(c/3)),...
    Om(round(r/3):round(r*2/3),round(c/3):round(c*2/3)),...
    Om(round(r/3):round(r*2/3),round(c*2/3):c),Om(round(r*2/3):r,1:round(c/3)),...
    Om(round(r*2/3):r,round(c/3):round(c*2/3)),Om(round(r*2/3):r,round(c*2/3):c)}; 
    %initialize obj_loc matrix
    obj_loc_matrix = zeros(length(index.objectnames),9);
    %loop through 9 parts
    for i=1:9
        current = nine_part{i};
        [a,b] = size(current);
        blkcount = a*b;
        objidx = setdiff(unique(current),0);
        % fill matrix for each object in each part
        for j= 1:length(objidx)
            obj = objidx(j);
            obj_loc_matrix(obj,i)= length(find(current==obj))/blkcount;
        end
    end
    % fill in cell array
    img_matrices(:,:,k)=obj_loc_matrix;
end

