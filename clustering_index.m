function index = clustering_index(dat)
    G = dat(:,1);
    % split data
    cluster_top = [];
    cluster_mid = [];
    cluster_bot = [];
    for i=1:length(G)
       if G(i)==1
           cluster_top = [cluster_top;dat(i,2)];
       elseif G(i)==2
           cluster_mid = [cluster_mid;dat(i,2)];
       else
           cluster_bot = [cluster_bot;dat(i,2)];
       end
    end
    clusters = {cluster_top,cluster_mid,cluster_bot};
    % within group ci
    ci_within = zeros(3,1);
    for i = 1:3
        ent_pair = nchoosek(clusters{i});
        ci_within(i) = mean(abs(ent_pair(:,1)-ent_pair(:,2)));
    end
    
    % between group ci
    ci_btw = zeros(3,1);
    for i = 1:3
        ent = clusters{i};
        outidx = setdiff(1:3,i);
        out_clusters = [clusters{outidx(1)};clusters{outidx(2)}];
        for j = 1:length(ent)
            ci_temp(j) = mean(abs(ent(j)-out_clusters));
        end
        ci_btw(i) = mean(ci_temp); 
    end
    index = mean(ci_btw-ci_within);
end