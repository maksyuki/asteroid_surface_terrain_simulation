% according to the thesis above:
% Terrain analysis and simulation verification on rubblepile-constructed 
% asteroid surfaces

clc;
close all;

addpath(genpath(pwd));


% d mean the randow size

DUST_DMIN = 0.02;
DUST_DMAX = 0.05;

COBBLE_DMIN = 0.05;
COBBLE_DMAX = 0.5;

BOULDER_DMIN = 0.5;
BOULDER_DMAX = 1;


dust_alpha = 4.8;
dust_beta = 1 - (DUST_DMIN/DUST_DMAX)^dust_alpha;

dust_d = DUST_DMIN / (1 - dust_beta * rand(1, 1)) ^(1 / dust_alpha);


[node_x, node_y, node_z, TRI] = make_icosahedron(1, dust_d, 1, 1, 0);

node = [node_x; node_y; node_z]';

% stretch_matrix's size: 42X3

% FIGURE 1 --------------------------------------
figure(1)
stretch_matrix = ones(42, 3);
for i = 1 : 42
    for j = 1 : 3
        stretch_matrix(i, j) = 1.25 - 0.5 * rand(1, 1);
    end
    
end

stretch_matrix = dust_d * stretch_matrix;
node = node + stretch_matrix;

handle = trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1], 'LineWidth', 1 );
xlabel('x-axis (m)', 'Fontsize', 16');
ylabel('y-axis (m)', 'Fontsize', 16');
zlabel('z-axis (m)', 'Fontsize', 16');
title( ['Add Stretch Matrix Effect'], 'Fontsize', 16');

axis equal;
grid off;


% FIGURE 2 --------------------------------------
figure(2)
reshape_matrix = [1, 0,   0;
                  0, 0.7, 0;
                  0, 0, 0.5];
node = node * reshape_matrix;

handle = trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1], 'LineWidth', 1 );
xlabel('x-axis (m)', 'Fontsize', 16');
ylabel('y-axis (m)', 'Fontsize', 16');
zlabel('z-axis (m)', 'Fontsize', 16');
title( ['Add Reshape Matrix Effect'], 'Fontsize', 16');

axis equal;
grid off;

% FIGURE 3 --------------------------------------
figure(3)
rot_alpha = rand(1, 1) * 2 * pi;
rotX = [1,        0,               0; 
        0, cos(rot_alpha),  sin(rot_alpha); 
        0, -sin(rot_alpha), cos(rot_alpha)];


rot_beta = rand(1, 1) * 2 * pi;
rotY = [cos(rot_beta),  0, -sin(rot_beta);
             0,         1,        0;
        sin(rot_beta),  0, cos(rot_beta)];

    
rot_gamma = rand(1, 1) * 2 * pi;
rotZ = [cos(rot_gamma),  sin(rot_gamma), 0;
        -sin(rot_gamma), cos(rot_gamma), 0;
              0,               0,        1];

rotation_matrix = rotX * rotY * rotZ;
node = node * rotation_matrix;

handle = trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1], 'LineWidth', 1 );
xlabel('x-axis (m)', 'Fontsize', 16');
ylabel('y-axis (m)', 'Fontsize', 16');
zlabel('z-axis (m)', 'Fontsize', 16');
title( ['Add Rotation Matrix Effect'], 'Fontsize', 16');

axis equal;
grid off;

% FIGURE 4 --------------------------------------
% generate the surface





