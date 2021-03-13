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


ALPHA = 2.8;

% generate the surface

% Terrain one(consist of all kind of the rock)
% the position of the dust is subject to uniform distribution
% In 1024X1024 size surface
surface = zeros(1024, 3);
visited = zeros(1024, 1024);

cnt = 1;
EPS = 1e-3;

while(1)
    if(cnt > 1000)
        break;
    end
    
    tmpx = floor(1024 * rand(1, 1));
    tmpy = floor(1024 * rand(1, 1));
    if(tmpx == 0) 
        tmpx = 1;
    end
    
    if(tmpy == 0)
        tmpy = 1;
    end

    if(visited(tmpx, tmpy) < EPS)
        visited(tmpx, tmpy) = 1;
        
        surface(cnt, 1) = tmpx;
        surface(cnt, 2) = tmpy;
        surface(cnt, 3) = -0.5 + rand(1, 1);
        tmpSize = floor(1 + 3 * rand(1, 1));
        
%         tmpSize = 3;
        disp(tmpSize);
        if(tmpSize == 1) 
            [node, TRI] = gen_rock(DUST_DMIN, DUST_DMAX, ALPHA);
            node(:,1) = node(:,1) * 300 + tmpx;
            node(:,2) = node(:,2) * 300 + tmpy;
            node(:,3) = node(:,3) * 300 + surface(cnt, 3);
            trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', 'blue', 'EdgeColor', 'blue', 'LineWidth', 1);
            hold on;
        end
        if(tmpSize == 2) 
            [node, TRI] = gen_rock(COBBLE_DMIN, COBBLE_DMAX, ALPHA);
            node(:,1) = node(:,1) * 40 + tmpx;
            node(:,2) = node(:,2) * 40 + tmpy;
            node(:,3) = node(:,3) * 40 + surface(cnt, 3);
            trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', 'red', 'EdgeColor', 'red', 'LineWidth', 1);
            hold on;
        end
        if(tmpSize == 3) 
            [node, TRI] = gen_rock(BOULDER_DMIN, BOULDER_DMAX, ALPHA);
            node(:,1) = node(:,1) * 6 + tmpx;
            node(:,2) = node(:,2) * 6 + tmpy;
            node(:,3) = node(:,3) * 6 + surface(cnt, 3);
            trisurf(TRI, node(:,1), node(:,2), node(:,3), 'FaceColor', 'green', 'EdgeColor', 'green', 'LineWidth', 1);
            hold on;
        end
        
        cnt = cnt + 1;
        disp(cnt);
    end
end

v = [0 0; 1024 0; 1024 1024; 0 1024];
f = [1 2 3 4];
patch('Faces', f, 'Vertices', v, 'FaceColor', '[0.8 0.8 0.8]', 'FaceAlpha', 1);

xlabel('x-axis (m)', 'Fontsize', 16');
ylabel('y-axis (m)', 'Fontsize', 16');
zlabel('z-axis (m)', 'Fontsize', 16');
grid on;
axis equal;
grid off;