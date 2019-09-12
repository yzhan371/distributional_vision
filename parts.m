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
img_matrices_wpt = img_matrices;
for k = 1:m
    img_num = where_part(k);
    % load images
    filename = fullfile(index.folder{img_num}, index.filename{img_num});
    [~,~,Pm,~] = loadAde20K(filename);
    % segement images 
    [r,c,~] = size(Pm);
    nine_part = {Pm(1:round(r/3),1:round(c/3),:),Pm(1:round(r/3),round(c/3):round(c*2/3),:),...
    Pm(1:round(r/3),round(c*2/3):c,:),Pm(round(r/3):round(r*2/3),1:round(c/3),:),...
    Pm(round(r/3):round(r*2/3),round(c/3):round(c*2/3),:),...
    Pm(round(r/3):round(r*2/3),round(c*2/3):c,:),Pm(round(r*2/3):r,1:round(c/3),:),...
    Pm(round(r*2/3):r,round(c/3):round(c*2/3),:),Pm(round(r*2/3):r,round(c*2/3):c,:)}; 
    %initialize obj_loc matrix
    pt_loc_matrix = zeros(length(index.objectnames),9);
    %loop through 9 parts
    for i=1:9
        current = nine_part{i};
        [a,b,d] = size(current);
        blkcount = a*b*d;
        ptidx = setdiff(unique(current),0);
        % fill matrix for each object in each part
        for j= 1:length(ptidx)
            obj = ptidx(j);
            pt_loc_matrix(obj,i)= length(find(current==obj))/blkcount;
        end
    end
    % fill in cell array
    img_matrices_wpt(:,:,img_num)=pt_loc_matrix + img_matrices(:,:,img_num);
end