close all;



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

