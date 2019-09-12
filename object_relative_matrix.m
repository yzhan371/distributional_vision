%%
% Load data
load('index_ade20k.mat');
load('ref_idx.mat');

%%
n = length(index.filename);
m = length(filtered_name);
obj_rel_matrix = zeros(m,m*4,'single');
for k = 1:n
    % load images
    filename = fullfile(index.folder{k}, index.filename{k});
    [Om,~] = loadAde20K(filename);
    img_OR = zeros(size(obj_rel_matrix));
    obj = setdiff(unique(Om),0);
    obj = intersect(obj,ref_idx); 
    if length(obj)>1
        combs = nchoosek(obj,2);
        a = zeros(size(combs,1),1);
        b = zeros(size(combs,1),1);
        for j = 1:size(combs,1)
            a(j) = find(ref_idx==combs(j,1));
            b(j) = find(ref_idx==combs(j,2));
        end
        LB1 = zeros(length(a),1);
        LB2 = zeros(length(a),1);
        RB1 = zeros(length(a),1);
        RB2 = zeros(length(a),1);
        TB1 = zeros(length(a),1);
        TB2 = zeros(length(a),1);
        BB1 = zeros(length(a),1);
        BB2 = zeros(length(a),1);
        for j = 1:length(a)
            [r,c] = find(Om==combs(j,1));
            [rs,cs] = find(Om==combs(j,2));
            LB1(j) = min(c);
            LB2(j) = min(cs);
            RB1(j) = max(c);
            RB2(j) = max(cs);
            TB1(j) = min(r);
            TB2(j) = min(rs);
            BB1(j) = max(r);
            BB2(j) = max(rs);
        end
        combs_780 = cat(2,a,b);
        l_idx = combs_780(LB1<LB2,:);
        for i = 1:size(l_idx,1)
        img_OR(l_idx(i,1),l_idx(i,2))=1;
        end
        r_idx = combs_780(RB1>RB2,:);
        k1 = r_idx(:,2)+780;
        for i = 1:size(r_idx,1)
            img_OR(r_idx(i,1),k1(i))=1;
        end
        a_idx = combs_780(TB1>TB2,:);
        k2 = a_idx(:,2)+780*2;
        for i = 1:size(a_idx,1)
            img_OR(a_idx(i,1),k2(i))=1;
        end
        b_idx = combs_780(BB1<BB2,:);
        k3 = b_idx(:,2)+780*3;
        for i = 1:size(b_idx,1)
            img_OR(b_idx(i,1),k3(i))=1;
        end
        obj_rel_matrix = obj_rel_matrix + img_OR;
    else
        % do nothing
    end
end

%% Calculate Avg
obj_rel_matrix_pdf = zeros(size(obj_rel_matrix));
for i = 1:4
    st = (i-1)*780+1;
    obj_rel_matrix_pdf(:,st:i*780) = obj_rel_matrix(:,st:i*780)./effect_size;
end
obj_rel_matrix_pdf(isnan(obj_rel_matrix_pdf))=0;

%% tSNE
rng default 
tsneOR = tsne(obj_rel_matrix_pdf,'Algorithm','exact','NumDimensions',3,'NumPCAComponents',50,'Options',statset('MaxIter',10000));

%%
objcount = index.objectcounts;
filtered_name = transpose(index.objectnames);
filtered_name(objcount<20)=[];
%%
textscatter(tsneOR(:,1),tsneOR(:,2),filtered_name);

