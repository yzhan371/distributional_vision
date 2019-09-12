%% onezero
%
% Convert matrices made by makeobjblkmatrix into one-zero only matrix. With a   
% probablity threshold.
% 
%% Syntax
% 
% matrices_oh = onezero(matrices)
% matrices_oh = onezero(matrices,x)
%
%% Description
% 
% Convert the non-zero indices (or above threshold indices) of the input
% matrix to 1.
% 
% Input arguments: matrix - matrix that need to be converted; x- filtering threshold, 
% indices that are above this value are converted to 1, below are zeros,
% default value is 0.
% 
% Output: matrices_oh - matrices that only contain 1 and 0. 1 stands for
% larger than threshold indice value and 0 stands for smaller than threshold. 
% 
%% Example
%
%   matrices_oh = onezero(matrices);
%   matrices_oh = onezero(matrices,0.05);
%
%% Author
% 
% Yiyuan Zhang, Michael F. Bonner | Johns Hopkins University
% 
%% Function
function matrices_oh = onezero(matrices,x)

if nargin<2
    x=0;
end
    
matrices_oh  = matrices;
matrices_oh(matrices_oh<=x)=0;
matrices_oh(matrices_oh>x)=1;

end