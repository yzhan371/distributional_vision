%%
% Load data
load('index_ade20k.mat');
load('image_matrices_wpt_3');
 %% filter objpresence>=20 names
objcount = index.objectcounts;
filtered_name = transpose(index.objectnames);
filtered_name(objcount<20)=[];

%% one-hot
img_matrices_wpt_3boh  = img_matrices_wpt_3b;
img_matrices_wpt_3boh(img_matrices_wpt_3boh~=0)=1;

%% mean all
dat_3b_ns = mean(img_matrices_wpt_3boh,3);
dat_3b_ns(objcount<20,:)=[];

%% px calculation
% initialize px values
px = zeros(size(dat_3b_ns,1),1,'single');
img_matrices_wpt_3boh(objcount<20,:,:)=[];
totx = sum(img_matrices_wpt_3boh,3);
cx = size(img_matrices_wpt_3boh,3)*3;% denominator total block value
for i = 1:length(px)% loop throught all objects
    px(i) = sum(totx(i,:),2)/cx;% calculate px value for obj i
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
pmi = dat_3b_ns./pxpy;% calculate pmi
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
textscatter3(pxpy(:,1),pxpy(:,2),pxpy(:,3),filtered_name,'ColorData',color);
view(50,50)

