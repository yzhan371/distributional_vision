%% colorcode
%
% color code the data for plotting purpose  
% 
% 
%% Syntax
% 
% color = colorcode(dat);
%
%% Description
% 
% According to the max coloum value of each row of input data, give corresponding color
% to each row. The corresponding colors are as followed: 1- red, 2- green,
% 3- blue, 4- cyan, 5- magenta, 6- yellow, 7- white, 8- black.
% 
% Input arguments: dat- data where the color need to be assigned. Second
% dimension between 2-8.
% 
% Output: color- color code matrix that assigns to the matrix's rows.
%  
% 
%% Example
%
%   color = colorcode(ppmi);   
%
%% Author
% 
% Yiyuan Zhang, Michael F. Bonner | Johns Hopkins University
% 
%% Function
function color = colorcode(dat)

if size(dat,2)>8 || size(dat,2)<2
    error('Second dimension of input must between 2 to 8')
end

[~,maxidx] = max(dat,[],2);
color = zeros(size(dat,1),3);

for i = 1:size(dat,1)
    if maxidx(i)<=3 
        color(i,maxidx(i))=1;
    elseif maxidx(i)>3 && maxidx(i)<=6
        color(i,:)=[1,1,1];
        color(i,maxidx(i)-3)=0;
    elseif maxidx(i)==7
        color(i,:) = [1,1,1];
    else
        % do nothing.
    end
end    

end