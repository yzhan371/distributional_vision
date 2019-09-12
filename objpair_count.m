%%
% Load data
load('index_ade20k.mat');
%%
n = length(filtered_name);
m = length(index.filename); 
effect_size = zeros(n,n,'single');
for i = 1:m
    obj_paircount = zeros(size(effect_size));
    filename = fullfile(index.folder{i}, index.filename{i});
    [Om,~] = loadAde20K(filename);
    obj = setdiff(unique(Om),0);
    obj = intersect(obj,ref_idx);
    if length(obj)>1
        objpairimg = nchoosek(obj,2);
        a = zeros(size(objpairimg,1),1);
        b = zeros(size(objpairimg,1),1);
        for j = 1:size(objpairimg,1)
            a(j) = find(ref_idx==objpairimg(j,1));
            b(j) = find(ref_idx==objpairimg(j,2));
        end
        obj_paircount(a,b)=1;
        effect_size = effect_size+obj_paircount;
    else
        %do nothing
    end
end




