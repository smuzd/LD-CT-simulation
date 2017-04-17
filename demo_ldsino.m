% demo_ldsino
% simulate low-dose sinogram
%
% Reference:
% Zeng, D., Huang, J., Bian, Z., Niu, S., Zhang, H., Feng, Q., Liang, Z. and Ma, J., 2015. A simple low-dose x-ray CT simulation from high-dose scan. IEEE transactions on nuclear science, 62(5), pp.2226-2233.

close all; clear; clc;
load I0 % high-dose (100 mAs) incident
% system steup
sg = sino_geom('fan','nb', 672, 'na',1160, 'ds', 1.85, ...
    'dsd', 1361.2, 'dod',615.18 , ...
    'source_offset',0.0,'orbit',360, 'down', 1);%0.909976 
ig = image_geom('nx',512, 'ny', 512,'fov',350,'offset_x',0,'down', 1);
G = Gtomo2_dscmex(sg, ig);
%% phantom setup
ell = phantom_parameters('Shepp-Logan',ig);
xtrue = ellipse_im(ig, ell, 'oversample', 4);  % noise-free image unit: mm-1
sino = ellipse_sino(sg, ell, 'oversample', 4); % noise-free sinogram

% show high-dose image and sinogram
im plc 2 2
clim = [0 0.035];
im(1, xtrue, 'x', clim), cbar
im(2, sino, 'sino'), cbar
%%
% low-dose noise parameters
k = 0.1924; % low-dose 17 mAs it can be determined by 2015 TNS paper
 
sig = sqrt(11); % standard variance of electronic noise, a characteristic of CT scanner
% perform low-dose simulation on the projection data
lsino = pct_ldsino(I0, sino, k, sig);
%%
% reconstruct image
tmp = fbp2(sg, ig);
fbp = fbp2(lsino, tmp);

% show results
im plc 2 2
clim = [0 0.035];
im(1, xtrue, 'high-dose', clim), cbar;
im(2, fbp, 'FBP low-dose', clim), cbar
im(3, sino, 'sino'), cbar
im(4, lsino, 'noisy sino'), cbar