function [entropyS,ranking] = entropyS(dat)
    
entropyS = -sum(dat.*log(dat),2,'omitnan');

[~,ranking] = sort(entropyS);


end