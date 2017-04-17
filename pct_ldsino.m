function [lsino,yi] = pct_ldsino(bi, hsino, k, sig)
% Simulate low-dose recontructed CTP data by adding Poisson and Gaussian
% noise to the sinogram generated from fanbeam
%
%  INPUT:
%     'bi'                indicent flux at high dose mAs (between 1e5 and 1e6)
% 
%     'hsino'             high dose sinogram data 
%
%     'k'                 ratio between the high and low -dose indicent
%                         flux vs. mAs level (depends on the CT vendors) 
% 
%     'sig'               the variance of electronic noise (Ma 2011 Med. Phys.)
%                           between sqrt(10) and sqrt(11)

%   $Revision: 1.0.0 $  $Date: 2015/11/01 $
%   Copyright (c) 2011 Dong Zeng, Ph.D, zd1989@smu.edu.cn
%   Reference:
%   Zeng, D., Huang, J., Bian, Z., Niu, S., Zhang, H., Feng, Q., Liang, Z. and Ma, J., 2015. A simple low-dose x-ray CT simulation from high-dose scan. IEEE transactions on nuclear science, 62(5), pp.2226-2233.

ri = 1.0; 
yb = k * bi .* exp(-hsino) + ri; % exponential transform to incident flux
yi = poisson(yb) + sqrt(sig)*randn(size(yb)); 
li_hat = -log((yi-ri)./bi);
li_hat(yi-ri <= 0) = 0; 
lsino = li_hat;