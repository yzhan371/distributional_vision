 %% Load Data
 % load ade20k dataset
 load('index_ade20k.mat');
 % load 3 block pixel percentage matrices
 load('image_matrices_wpt_3.mat');
 % load 3 blcok object probablity data 
 load('real_dat_3b.mat');
%% filter names and obj presence
objcount = index.objectcounts;
op = index.objectPresence;
filtered_name = transpose(index.objectnames);
% filter out objs that occur less than 20 times
filtered_name(objcount<20)=[];
op(objcount<20,:)=[];
%% make one-hot version of object-block matrix indices that are greater than 0 count as 1
img_matrices_wpt_3boh  = img_matrices_wpt_3b;
img_matrices_wpt_3boh(img_matrices_wpt_3boh~=0)=1;
%% filtered img OH matrix (objcount >20 times)
filtered_matrix_oh = img_matrices_wpt_3boh;
filtered_matrix_oh(objcount<20,:,:)=[];
%% generate 3b probablity data - unnecessary if data already loaded
filtered_objpresence = index.objectPresence;
filtered_objpresence(objcount<20,:)=[];
[n,~] = size(filtered_matrix_oh);
avg_zero_out_oh_3b = zeros(n,3);
for i = 1:n
    obj = filtered_objpresence(i,:);
    obj_all = filtered_matrix_oh(i,:,obj~=0);
    avg_zero_out_oh_3b(i,:)= mean(obj_all,3); 
end    

sum_obj = sum(avg_zero_out_oh_3b,2);
normalize_avg_zero_out_oh_3b = avg_zero_out_oh_3b./sum_obj;
real_dat_3b = avg_zero_out_oh_3b;

%% px calculation
% initialize px values
px = zeros(size(op,1),1,'single');
% filtering one-hot version of image matrices (objcount>20)
img_matrices_wpt_3boh  = img_matrices_wpt_3b;
img_matrices_wpt_3boh(img_matrices_wpt_3boh~=0)=1;
img_matrices_wpt_3boh(objcount<20,:,:)=[];
for i = 1:length(px)% loop throught all objects
    objp = op(i,:);% objp = object presence vector for object i
    obj_all = img_matrices_wpt_3boh(i,:,objp~=0); % subsetting images that contain obj i
    totx= sum(obj_all,3); % sum presence value for object i, sum to numerator of px
    cx = size(img_matrices_wpt_3boh,3)*3;% denominator total block value
    px(i) = sum(totx,2)/cx;% calculate px value for obj i
end   

%% py1 calculation
py1 = zeros(3,1,'single');% initalize py value
cy = sum(img_matrices_wpt_3boh,'all'); % denominator, total object presence in image matrices
toty = sum(img_matrices_wpt_3boh,3); 
for i  = 1:length(py1) % loop through all blocks
    py1(i) = sum(toty(:,i),1)/cy; % calculate py:(# of obj presences in block i) / cy
end

%% PMI
pxpy =px*transpose(py1);% calculate pxpy
pmi = log2(real_dat_3b./pxpy);% calculate pmi
ppmi = max(pmi,0);% calculate ppmi

%% color code
[~,maxidx] = max(ppmi,[],2);
color = zeros(size(ppmi,1),3);
for i = 1:size(ppmi,1)
    color(i,maxidx(i))=1;
end    
%% tSNE
rng default 
ppmi_tsne = tsne(ppmi,'Algorithm','exact','NumDimensions',3,'Options',statset('MaxIter',5000));

%%
textscatter(ppmi_tsne(:,1),ppmi_tsne(:,2),filtered_name,'ColorData',color);
%%
textscatter3(ppmi_tsne(:,1),ppmi_tsne(:,2),ppmi_tsne(:,3),filtered_name,'ColorData',color);
view(50,50)

%%
textscatter(ppmi(:,1),ppmi(:,2),filtered_name,'ColorData',color);

%%
SE_ppmi3b = -sum(ppmi.*log(ppmi),2,'omitnan');
[~,low2high_ppmi3b_Ent] = sort(SE_ppmi3b);

%%
textscatter3(ppmi(:,1),ppmi(:,2),ppmi(:,3),filtered_name,'ColorData',color);
view(50,50)