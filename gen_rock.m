% This is unoffical code mainly based the follow thesis:
% WANG Y LIU P, WU H Y, et al. Terrain analysis and simulation 
% verification on rubblepile-constructed asteroid surfaces[J].
% Journal of Deep Space Exploration 2019, 6(5): 481-487


function [node, TRI] = gen_rock(d_min, d_max, alpha)
% example using in the application:
%
% [node, TRI] = gen_rock(DUST_DMIN, DUST_DMAX, DUST_ALPHA);
% handle = trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1], 'LineWidth', 1 );
% xlabel('x-axis (m)', 'Fontsize', 16');
% ylabel('y-axis (m)', 'Fontsize', 16');
% zlabel('z-axis (m)', 'Fontsize', 16');
% title( ['Add Reshape Matrix Effect'], 'Fontsize', 16');
% 
% axis equal;
% grid off;

beta = 1 - (d_min/d_max)^alpha;
d = d_min / ((1 - beta * rand(1, 1))^(1 / alpha));


[node_x, node_y, node_z, TRI] = make_icosahedron(1, d, 1, 0, 0);

node = [node_x; node_y; node_z]';

% stretch_matrix's size: 42X3
% Add Stretch Matrix Effect
stretch_matrix = ones(42, 3);
for i = 1 : 42
    for j = 1 : 3
        stretch_matrix(i, j) = 1.25 - 0.5 * rand(1, 1);
    end
    
end


stretch_matrix = d * stretch_matrix;
node = node + stretch_matrix;


% Add Reshape Matrix Effect
reshape_matrix = [1, 0,   0;
                  0, 0.7, 0;
                  0, 0, 0.5];
node = node * reshape_matrix;


% Add Reshape Matrix Effect
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
end