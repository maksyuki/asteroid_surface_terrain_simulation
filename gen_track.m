close all;

figure(3)
trisurf(facets, vertices(:, 1), vertices(:, 2), vertices(:, 3), grav_attr_val);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
% xlim([0,250]);
% ylim([0,250]);
zlim([0,250]);

set(gca,'fontsize', P.AxisFontSize);
set(gca,'looseInset',[0 0 0 0]);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
c = colorbar('FontSize', 14, 'Location','eastoutside', 'Axislocation', 'in');
c.Label.String = 'Gravity Attraction Value(N)';
title('Gravity Potential of Bennu with Delaunay Surface', 'fontsize', P.TitleFontSize);
% axis equal;
hold on;

% draw the track
p0 = vertices(1,:);
delta_time = 1;
disp(p0(1,:));
ansx = [];
ansy = [];
ansz = [];


vx = 0.01;
vy = 0.01;
vz = 0.05;
is_inner_ang = 0;
test_grad = zeros(1, 3, 3);
c_r = 0.75;

step = 1;
is_first = true;

% while(1)
    for i = 1 : 2000
        disp(step);
        step = step + 1;
        if(is_first == true)
            is_first = false;
            p0(1,3) = p0(1,3) + 1;
        end
        [~,test_grad, ~, is_inner_ang] = gen_grav_funcs(p0, vertices, facets, edge_table);
        test_g = sqrt(test_grad * (test_grad'));
        disp(test_g);
        disp(is_inner_ang)
        vz = vz - test_g * delta_time;
        xx = p0(1) + vx * delta_time;
        yy = p0(2) + vy * delta_time;
        zz = p0(3) + vz * delta_time - 0.5 * test_g * delta_time^2;
        p0(1) = xx; p0(2) = yy; p0(3) = zz;

%         if(is_inner_ang < 0)
%             break;
%         end
        ansx = [ansx, xx];
        ansy = [ansy, yy];
        ansz = [ansz, zz];
    end
    
%     if(abs(vz) < 1)
%         break;
%     end
%      vz = -c_r * vz;
     
% end

plot3(ansx, ansy, ansz, 'r');

% test_point = vertices(1,:);
% test_point = [0, 0, 200];
% test_pot = zeros(1, 1);
% test_attr = zeros(1, 3);
% test_grad = zeros(1, 3, 3);
% is_inner_ang = 0;

% [~,~, ~, is_inner_ang] = grav_funcs(test_point, vertices, facets, edge_table);

% disp(is_inner_ang);

% test_point = [300, 300, 300];
% [test_pot(1, :), test_attr(1, :), test_grad(1, :, :), is_inner_ang] = grav_funcs(test_point, vertices, facets, edge_table);

% disp(is_inner_ang);