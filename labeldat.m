function labeled_dat = labeldat(dat)
    [~,label] = max(dat,[],2);
    labeled_dat = [label,dat];
end