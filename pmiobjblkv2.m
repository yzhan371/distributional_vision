function ppmi = pmiobjblkv2(dat)


pxy = dat/22210;

% initialize px values
px = zeros(size(dat,1),1);
cx = 222210*3;% denominator total block value
for i = 1:length(px)% loop throught all objects
    px(i) = sum(dat(i,:),2)/cx;% calculate px value for obj i
end   
 

% py calculation
py = zeros(size(dat,2),1,'single');% initalize py value
cy = sum(dat,'all'); % denominator, total object presence in image matrices
for i  = 1:length(py) % loop through all blocks
    py(i) = sum(dat(:,i),1)/cy; % calculate py:(# of obj presences in block i) / cy
end

pxpy =px*transpose(py);% calculate pxpy

pmi = log2(pxy./pxpy);% calculate pmi

ppmi = max(pmi,0);% calculate ppmi


end