%%
% Load data
load('index_ade20k.mat');
load('image_matrices_wpt.mat');
%% make one-hot obj_loc matrices
img_matrices_OH  = img_matrices_wpt;
img_matrices_OH(img_matrices_OH~=0)=1;

%% filter objpresence>=20 names
objcount = index.objectcounts;
filtered_name = transpose(index.objectnames);
filtered_name(objcount<20)=[];

%% filtered img OH matrix
filtered_matrix_oh = img_matrices_OH;
filtered_matrix_oh(objcount<20,:,:)=[];

%%
filtered_objpresence = index.objectPresence;
filtered_objpresence(objcount<20,:)=[];
[n,~] = size(filtered_matrix_oh);
avg_zero_out_oh = zeros(n,9);
for i = 1:n
    obj = filtered_objpresence(i,:);
    obj_all = filtered_matrix_oh(i,:,obj~=0);
    avg_zero_out_oh(i,:)= mean(obj_all,3); 
end    

sum_obj = sum(avg_zero_out_oh,2);
normalize_avg_zero_out_oh = avg_zero_out_oh./sum_obj;

%%
rng default 
tsneoh = tsne(normalize_avg_zero_out_oh,'Algorithm','exact','NumDimensions',3,'Options',statset('MaxIter',5000));
%%
tsne2d = textscatter(tsneoh(:,1),tsneoh(:,2),filtered_name);
%%
tsne3d=textscatter3(tsneoh(:,1),tsneoh(:,2),tsneoh(:,3),filtered_name);
view(50,50)