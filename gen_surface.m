% This is unoffical code mainly based the follow thesis:
% WANG Y LIU P, WU H Y, et al. Terrain analysis and simulation 
% verification on rubblepile-constructed asteroid surfaces[J].
% Journal of Deep Space Exploration 2019, 6(5): 481-487


clc;
close all;

addpath(genpath(pwd));


% d mean the randow size
DUST_DMIN = 0.02;
DUST_DMAX = 0.05;

COBBLE_DMIN = 0.05;
COBBLE_DMAX = 0.5;

BOULDER_DMIN = 0.5;
BOULDER_DMAX = 5;


DUST_ALPHA = 4.8;
[node, TRI] = gen_rock(DUST_DMIN, DUST_DMAX, DUST_ALPHA);
% handle = trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1], 'LineWidth', 1 );
% xlabel('x-axis (m)', 'Fontsize', 16');
% ylabel('y-axis (m)', 'Fontsize', 16');
% zlabel('z-axis (m)', 'Fontsize', 16');
% title( ['Add Rotation Matrix Effect'], 'Fontsize', 16');


% FIGURE 4 --------------------------------------
% generate the surface

% Terrain one(consist of only the dust)
% the position of the dust is subject to uniform distribution
% In 1024X1024 size surface




