clc; clear all; close all;

data_txt = fopen('./3rd-party/EAR_A_I0037_5_BENNUSHAPE_V1_0/data/101955bennu.tab');
data_vertices_rd = textscan(data_txt, '%c %f %f %f', 1348);
data_facets_rd   = textscan(data_txt, '%c %d %d %d');
fclose(data_txt);

data_txt = fopen('./3rd-party/EAR_A_I0037_5_BENNUSHAPE_V1_0/data/rotate.tab');
data_rotate_rd = textscan(data_txt, '"%s",%f,%f');
fclose(data_txt);

data_txt = fopen('./3rd-party/EAR_A_I0037_5_BENNUSHAPE_V1_0/data/pole.tab');
data_pole_rd = textscan(data_txt, '"%s",%d,%d');
fclose(data_txt);

verticesx = [data_vertices_rd{:,2}];
verticesy = [data_vertices_rd{:,3}];
verticesz = [data_vertices_rd{:,4}];
vertices = [verticesx, verticesy, verticesz];

% unit: km => m
vertices = 1000 * vertices;

facets1 = [data_facets_rd{:,2}];
facets2 = [data_facets_rd{:,3}];
facets3 = [data_facets_rd{:,4}];
facets = [facets1, facets2, facets3];

% load para
P = set_para();

figure(1)
plot3(vertices(:, 1), vertices(:, 2), vertices(:, 3), 'r.','MarkerSize', 2);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
set(gca,'fontsize', P.AxisFontSize);
set(gca,'looseInset',[0 0 0 0]);
title('Scatter Shape Model of Bennu', 'fontsize', P.TitleFontSize);
axis equal;

% calc the gravity func
G   = 6.67E-11;
rho = 2670;
edge_table = zeros(1400, 1400, 2);

facet_size = length(facets);

% operate the edge data
for i = 1 : facet_size
    % facets(i,1)
    for j = 1 : 3
        if(j <= 2)
            vaa = facets(i, j);
            vbb = facets(i, (j + 1));
        else
            vaa = facets(i, j); % j == 3
            vbb = facets(i, 1);
        end
        
        va = min(vaa, vbb); vb = max(vaa, vbb);
        if(edge_table(va, vb, 1) == 0)
            edge_table(va, vb, 1) = i;
        else
            edge_table(va, vb, 2) = i;
        end
    end
end

delta_length = 0.001;
vertices_length = length(vertices);

grav_pot = zeros(vertices_length, 1);
grav_attr = zeros(vertices_length, 3);
grav_grad = zeros(vertices_length, 3, 3);
unused_val = 0;

for i = 1 : vertices_length
    tmp_pos = vertices(i, :) * 1000;
    [grav_pot(i, :), grav_attr(i, :), grav_grad(i, :, :), unused_val] = gen_grav_funcs((tmp_pos + ...
                                                            delta_length * tmp_pos), ...
                                                            vertices, facets, edge_table);
    disp(i);
end

grav_attr_squ = grav_attr .* grav_attr;
grav_attr_val = grav_attr_squ(:, 1) + grav_attr_squ(:, 2) + grav_attr_squ(:, 3);
grav_attr_val = sqrt(grav_attr_val);

% pos = vertices(4, :);
% disp(pos);
% pos = pos + delta_length * pos;
% disp(pos);



% % calc the fist term of the gravity potential
% grav_first_term = 0;
% for i = 1 : 1400
%     for j = i + 1 : 1400
%         if(edge_table(i, j, 1) == 0) 
%             continue;
%         end
%         
%         % i means vertx 1, j means vertex 2
%         r_e1  = pos - vertices(i, :); % 1X3 array
%         r_e2  = pos - vertices(j, :); % 1X3 array
%         r_e12 = vertices(j, :) - vertices(i, :); % 1X3 array
% 
%         dis_e1  = sqrt(r_e1 * (r_e1'));
%         dis_e2  = sqrt(r_e2 * (r_e2'));
%         dis_e12 = sqrt(r_e12 * (r_e12'));
%         L_e = log((dis_e1 + dis_e2 + dis_e12) / (dis_e1 + dis_e2 - dis_e12));
%         
%         % calc the E_e, need to check two facets that connect to the edge
%         % face A
%         face_n = zeros(2, 3);
%         for k = 1 : 2 % calc the face A and face B's extern normal vector
%             face_v = facets(edge_table(i, j, k), :); % 1X3 array
%             tmp_p1 = vertices(face_v(1, 1), :);
%             tmp_p2 = vertices(face_v(1, 2), :);
%             tmp_p3 = vertices(face_v(1, 3), :);
% 
%             face_v_e1 = tmp_p2 - tmp_p1;
%             face_v_e2 = tmp_p3 - tmp_p1;
%         
%             tmp_n = cross(face_v_e1, face_v_e2); % 1X3 array
%             check_e = tmp_p1; % 1X3 array
%             
%             if(dot(tmp_n, check_e) < 0) % tmp_n is the interior vector
%                 tmp_n = -tmp_n;
%             end
%             face_n(k, :) = tmp_n;
%         end
% 
%         % calc the edge 1 and edge 2 extern normal vector
%         % this edge is (i, j), satisfy i < j, i, j is the id of the vertices
%         edge_n = zeros(2, 3);
%         for k = 1 : 2
%             tmp_n = cross(r_e12, face_n(k, :));
%             tmp_f = facets(edge_table(i, j, k), :); % 1X3 array
%             for q = 1 : 3
%                 if(tmp_f(1, q) == i || tmp_f(1, q) == j)
%                     continue;
%                 else
%                     tmp_p3 = vertices(tmp_f(1, q), :);
%                     tmp_p1 = vertices(i, :);
%                     tmp_v = 0.5 * r_e12 + (tmp_p1 - tmp_p3);
%                     if(dot(tmp_v, tmp_n) < 0)
%                         tmp_n = -tmp_n;
%                     end
%                         edge_n(k, :) = tmp_n;
%                     break;
%                 end
%             end  
%         end
%         
%         E_e = (face_n(1, :)') * edge_n(1, :) + (face_n(2, :)') * edge_n(2, :);
%         % conclude
%         grav_first_term = grav_first_term + r_e1 * E_e * (r_e1') * L_e;
%     end
% end
% 
% grav_first_term = -0.5 * G * rho * grav_first_term;
% 
% % calc the second term of the gravity potential
% grav_second_term = 0;
% 
% for i = 1 : facet_size
%     tmp_p1 = vertices(facets(i, 1), :);
%     tmp_p2 = vertices(facets(i, 2), :);
%     tmp_p3 = vertices(facets(i, 3), :);
%     
%     r_f1 = pos - tmp_p1;
%     face_v_e1 = tmp_p2 - tmp_p1;
%     face_v_e2 = tmp_p3 - tmp_p1;
% 
%     tmp_n = cross(face_v_e1, face_v_e2);
%     check_e = tmp_p1;
%     if(dot(tmp_n, check_e) < 0)
%         tmp_n = -tmp_n;
%     end
%     
%     r1 = pos - tmp_p1;
%     r2 = pos - tmp_p2;
%     r3 = pos - tmp_p3;
%     
%     r1_len = sqrt(r1 * (r1'));
%     r2_len = sqrt(r2 * (r2'));
%     r3_len = sqrt(r3 * (r3'));
%     omega = 2 * atan2(dot(r1, cross(r2, r3)), r1_len * r2_len * r3_len + ...
%                   r1_len * dot(r2, r3) + r2_len * dot(r1, r3) + r3_len * dot(r1, r2));
%     
%     F_f = (tmp_n') * tmp_n;
%     grav_second_term = grav_second_term + r_f1 * F_f * (r_f1') * omega;
% end
% 
% grav_second_term = 0.5 * G * rho * grav_second_term;
% 
% grav_pot = grav_first_term + grav_second_term;

figure(2)
trisurf(facets, vertices(:, 1), vertices(:, 2), vertices(:, 3), grav_pot);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
set(gca,'fontsize', P.AxisFontSize);
set(gca,'looseInset',[0 0 0 0]);
% colorbar('westoutside');
c = colorbar('FontSize', 14, 'Location','eastoutside', 'Axislocation', 'in');
c.Label.String = 'Gravity Potential Value(J)';
% c.Label.String = '引力势能(J)';

% title('Gravity Potential of Bennu with Delaunay Surface', 'fontsize', P.TitleFontSize);
axis equal;

figure(3)
trisurf(facets, vertices(:, 1), vertices(:, 2), vertices(:, 3), grav_attr_val);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)');
set(gca,'fontsize', P.AxisFontSize);
set(gca,'looseInset',[0 0 0 0]);
% colorbar('westoutside');
c = colorbar('FontSize', 14, 'Location','eastoutside', 'Axislocation', 'in');
c.Label.String = 'Gravity Attraction Value(N)';
% c.Label.String = '引力值(N)';

% title('Gravity Potential of Bennu with Delaunay Surface', 'fontsize', P.TitleFontSize);
axis equal;


% test_x = vertices(:, 1);
% test_y = vertices(:, 2);
% test_z = vertices(:, 3);
% 
% [X, Y] = meshgrid(min(test_y): 10 : max(test_y), min(test_z): 10: max(test_z));
% Z = griddata(test_y, test_z, grav_attr_val, X, Y, 'linear');
% 
% figure(4)
% surfc(X, Y, Z);
% xlabel('Y(m)');
% ylabel('Z(m)');
% zlabel('Gravity Attraction Value(J)');
% set(gca,'fontsize', P.AxisFontSize);
% set(gca,'looseInset',[0 0 0 0]);
% 
% title('Gravity Attraction of Bennu in YOZ Plane', 'fontsize', P.TitleFontSize);
% axis equal;