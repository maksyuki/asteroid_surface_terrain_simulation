close all;
figure(3)


% trisurf(facets, vertices(:, 1), vertices(:, 2), vertices(:, 3), grav_attr_val);
% xlabel('X(m)');
% ylabel('Y(m)');
% zlabel('Z(m)');
% xlim([-100,250]);
% ylim([-100,250]);
% zlim([0,400]);
plot3(ansx, ansy, ansz, 'r');
axis equal;
hold on;

for i = 1 : 12 % the target facet is num.8
    v = [vertices(facets(i, 1),:); vertices(facets(i, 2),:); vertices(facets(i, 3),:)];
    f = [1 2 3];
    patch('Faces',f,'Vertices',v,'FaceColor','[0.5 0.54 0.53]', 'FaceAlpha', 1);
    hold on;
end

p1 = vertices(facets(8, 1),:);
p2 = vertices(facets(8, 2),:);
p3 = vertices(facets(8, 3),:);
a = p1 - p2;
b = p1 - p3;
c = cross(a, b);
c_len = sqrt(c * (c'));
c = c / c_len;
d = [0, 0, 1];
rotate_axis = cross(d, c);
rotate_ang  = acos(dot(d, c)); % unit: rad/s
rotate_axis_len = sqrt(rotate_axis * (rotate_axis'));
rotate_axis = rotate_axis / rotate_axis_len;
rotate_mat = zeros(3, 3);

disp(rotate_axis(1));
% calc rotate matrix
rotate_mat(1,1) = cos(rotate_ang) + rotate_axis(1)^2 * (1 - cos(rotate_ang));
rotate_mat(1,2) = rotate_axis(1) * rotate_axis(2) * (1 - cos(rotate_ang)) - rotate_axis(3) * sin(rotate_ang);
rotate_mat(1,3) = rotate_axis(2) * sin(rotate_ang) + rotate_axis(1) * rotate_axis(3) * (1 - cos(rotate_ang));
rotate_mat(2,1) = rotate_axis(3) * sin(rotate_ang) + rotate_axis(1) * rotate_axis(2) * (1 - cos(rotate_ang));
rotate_mat(2,2) = cos(rotate_ang) + rotate_axis(2)^2 * (1 - cos(rotate_ang));
rotate_mat(2,3) = -rotate_axis(1) * sin(rotate_ang) + rotate_axis(2) * rotate_axis(3) * (1 - cos(rotate_ang));
rotate_mat(3,1) = -rotate_axis(2) * sin(rotate_ang) + rotate_axis(1) * rotate_axis(3) * (1 - cos(rotate_ang));
rotate_mat(3,2) = rotate_axis(1) * sin(rotate_ang) + rotate_axis(2) * rotate_axis(3) * (1 - cos(rotate_ang));
rotate_mat(3,3) = cos(rotate_ang) + rotate_axis(3)^2 * (1 - cos(rotate_ang));


for i = 1 : 60
    disp(i);
    s = 1 * abs(randn); %randn
    xpos = 1 + 14 * rand; %rand
    ypos = 1 + 14 * rand; %rand
%     xx = gallery('uniformdata',[30 1], 3 * i - 2) * s * 0.6 + xpos + 25;
%     yy = gallery('uniformdata',[30 1], 3 * i - 1) * s * 0.6 + ypos + 15;
%     zz = gallery('uniformdata',[30 1], 3 * i) * 0.6 + 258;
    xx = gallery('uniformdata',[30 1], 3 * i - 2);
    yy = gallery('uniformdata',[30 1], 3 * i - 1);
    zz = gallery('uniformdata',[30 1], 3 * i);
    pp_set = [xx, yy, zz];
    pp_set = (rotate_mat * pp_set')';
    pp_set(:,1) = pp_set(:,1) * s * 0.6 + xpos + 15;
    pp_set(:,2) = pp_set(:,2) * s * 0.6 + ypos + 10;
    pp_set(:,3) = pp_set(:,3) * 0.6 + 259;
    ttri = delaunayTriangulation(pp_set);
    tetramesh(ttri,'FaceAlpha',0.6);
    hold on;
end




xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
zlim([210,300]);

set(gca,'fontsize', P.AxisFontSize);
set(gca,'looseInset',[0 0 0 0]);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% c = colorbar('FontSize', 14, 'Location','eastoutside', 'Axislocation', 'in');
% c.Label.String = 'Gravity Attraction Value(N)';
% title('Gravity Potential of Bennu with Delaunay Surface', 'fontsize', P.TitleFontSize);
% axis equal;
hold on;




% x2 = gallery('uniformdata',[30 1], 3) + 400
% y2 = gallery('uniformdata',[30 1], 4) + 400;
% z2 = gallery('uniformdata',[30 1], 5) + 400;
% point_set2 = [x2 y2 z2];
% tri2 = delaunayTriangulation(point_set2);
% [KK,VV] = convexHull(tri2);
% trisurf(KK,tri2.Points(:,1), tri2.Points(:,2), tri2.Points(:,3));
% tetramesh(tri2,'FaceAlpha',1);