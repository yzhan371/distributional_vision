kt = 0.25:0.01:0.4;
kg = 0.15:0.01:0.33;
for i = 1:length(kt)
    for j = 1:length(kg)
        km(i,j) = 1-kt(i)-kg(j);
    end
end
%%
load('index_ade20k.mat');
%%
img_matrices_all = zeros(length(index.objectnames),3,length(kt),length(kg),'single');% preset and add
%img_matrices_all = cellfun(@(x) zeros(length(index.objectnames),3,'single'),img_matrices_all,'UniformOutput',false);
%%
% find imgs containing parts
    parts = index.objectIsPart;
    obj_part = find(sum(parts,2)~=0);
    p = length(obj_part);
    where_part = [];
    for i = 1:p
        pnum = obj_part(i);
        where_part = [where_part,find(parts(pnum,:)~=0)];  
    end
    where_part = transpose(unique(where_part));
%% OM
nimg = 22210;
for num_img = 1:nimg
  img_matrices = zeros(size(img_matrices_all),'single');
  filename = fullfile(index.folder{num_img}, index.filename{num_img});
  [Om,~,Pm,~] = loadAde20K(filename); 
  blk_top = cell(length(kt),1);
  blk_bot = cell(length(kg),1);
  [r,~] = size(Om);
  for ntop = 1:length(kt)
        blk_top{ntop} = Om(1:round(r*kt(ntop)),:);
  end
  for nbot = 1: length(kg)
        blk_bot{nbot} = Om(round(r*(1-kg(nbot))):r,:);
  end
  for i = 1:length(kt)
      for j = 1:length(kg)
          blk_mid = Om(round(r*kt(i)):round(r*km(i,j)),:);
          blocks = {blk_top{i},blk_mid,blk_bot{j}};
          img_matrix = zeros(length(index.objectnames),3);
          for nblk=1:3
            current = blocks{nblk};
            [a,b] = size(current);
            blkcount = a*b;
            objidx = setdiff(unique(current),0);
            % fill matrix for each object in each part
            for nobj= 1:length(objidx)
                obj = objidx(nobj);
                img_matrix(obj,nblk)= length(find(current==obj))/blkcount;
            end  
          end
          img_matrices(:,:,i,j) = img_matrix;
      end       
  end
  if ismember(num_img,where_part)
     [r,~] = size(Pm);
     pblk_top = cell(length(kt),1);
     pblk_bot = cell(length(kg),1);
     for ntop = 1:length(kt)
        pblk_top{ntop} = Pm(1:round(r*kt(ntop)),:,:);
     end
     for nbot = 1: length(kg)
        pblk_bot{nbot} = Pm(round(r*(1-kg(nbot))):r,:,:);
     end
  
     for i = 1:length(kt)
       for j = 1:length(kg)
          pblk_mid = Pm(round(r*kt(i)):round(r*km(i,j)),:,:);
          pblocks = {pblk_top{i},pblk_mid,pblk_bot{j}};
          %initialize obj_loc matrix
          ppt_matrix = zeros(length(index.objectnames),3);
          %loop through 9 parts
          for nblk=1:3
            current = pblocks{nblk};
            [a,b,d] = size(current);
            blkcount = a*b*d;
            ptidx = setdiff(unique(current),0);
            % fill matrix for each object in each part
              for nobj= 1:length(ptidx)
                obj = ptidx(nobj);
                ppt_matrix(obj,nblk)= length(find(current==obj))/blkcount;
              end
          end
          img_matrices(:,:,i,j) = img_matrices(:,:,i,j) + ppt_matrix;
      end
    end        
  else
      % do nothing
  end
  img_matrices = onezero(img_matrices);
  img_matrices_all = img_matrices_all+ img_matrices;
end
save('data.mat','img_matrices_all'); 
%% filter
objcount = index.objectcounts;

filtered_dat = nan(780,3,length(kt),lenght(kg),'single');
for i = 1:length(kt)
    for j = 1:length(kg)
        filtered_dat(:,:,i,j)  = filter_dat(img_matrices(:,:,i,j),objcount);
    end
end

%% ppmi

ppmi = nan(size(filtered_dat),'single');
for i = 1:length(kt)
    for j = 1:length(kg)
        ppmi(:,:,i,j)  = pmiobjblkv2(filtered_dat(:,:,i,j));
    end
end

%% entropy

SEnt = nan(size(filtered_dat),'single');
for i = 1:length(kt)
    for j = 1:length(kg)
        SEnt(:,:,i,j)  = entropyS(ppmi(:,:,i,j));
    end
end

%% add label
SEntL = nan(size(filtered_dat),'single');
for i = 1:length(kt)
    for j = 1:length(kg)
        temp = ppmi(:,:,i,j);
        [~,label] = max(temp,[],2);
        SEntL(:,:,i,j) = [label,SEnt(:,:,i,j)];
    end
end

%% calculate clustering index

%clustering_idx = cellfun(@clustering_index,SEnt_label,'UniformOutput',0);
clustering_idx = nan(size(km),'single');
for i = 1:length(kt)
    for j = 1:length(kg)
        clustering_idx(i,j) = clustering_index(SEnt_label(:,:,i,j));
    end
end