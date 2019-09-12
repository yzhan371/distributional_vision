%% make original matrix
img_matrices_3bp = makeobjblkmatrix(3,[],'v',[1/3,0.75,1]);
%%
oh_3b1 = onezero(img_matrices_3bp);
%% make filtered variables
[filtered_3b1,op,names] = objfreqfilter(oh_3b1,20);

%% calculate ppmi & related variables
[ppmi31,~] = pmiobjblk(filtered_3b1,3);

%% calculate Shannon's entropy & ranking index from low to high
[SEnth3b1,~] = entropyS(ppmi31);


%% color code data
color31 = colorcode(ppmi31);
%% tSNE
rng default 
Y3 = tsne(ppmi31,'Algorithm','exact','NumDimensions',2,'Options',statset('MaxIter',5000));
%% Plot data
figure(1)
plot2d = textscatter(Y3(:,1),Y3(:,2),names,'ColorData',color31);
figure(5)
textscatter(1:780,SEnth3b1,names,'ColorData',color31);
%%
%figure(2)
%plot3d = textscatter3(Y3(:,1),Y3(:,2),Y3(:,3),names,'ColorData',color31);
%view(50,50)

%%
