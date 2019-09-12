function filtered_dat = filter_dat(dat,objcount)
    filtered_dat = dat;  
    filtered_dat(objcount<20,:,:)=[];
end