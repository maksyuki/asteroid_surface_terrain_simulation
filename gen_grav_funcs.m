function [grav_pot, grav_attr, grav_grad, inner_ang] = gen_grav_funcs(pos, vertices, facets, edge_table)

G   = 6.67E-11;
rho = 2670;
% calc the fist term of the gravity potential
grav_pot_first_term = 0;
grav_attr_first_term = zeros(3, 1);
grav_grad_first_term = zeros(3, 1);
delta_ang = 0;

for i = 1 : 1400
    for j = i + 1 : 1400
        if(edge_table(i, j, 1) == 0) 
            continue;
        end
        
        % i means vertx 1, j means vertex 2
        r_e1  = pos - vertices(i, :); % 1X3 array
        r_e2  = pos - vertices(j, :); % 1X3 array
        r_e12 = vertices(j, :) - vertices(i, :); % 1X3 array

        dis_e1  = sqrt(r_e1 * (r_e1'));
        dis_e2  = sqrt(r_e2 * (r_e2'));
        dis_e12 = sqrt(r_e12 * (r_e12'));
        L_e = log((dis_e1 + dis_e2 + dis_e12) / (dis_e1 + dis_e2 - dis_e12));
        
        % calc the E_e, need to check two facets that connect to the edge
        face_n = zeros(2, 3);
        for k = 1 : 2 % calc the face A and face B's extern normal vector
            face_v = facets(edge_table(i, j, k), :); % 1X3 array
            tmp_p1 = vertices(face_v(1, 1), :);
            tmp_p2 = vertices(face_v(1, 2), :);
            tmp_p3 = vertices(face_v(1, 3), :);

            face_v_e1 = tmp_p2 - tmp_p1;
            face_v_e2 = tmp_p3 - tmp_p1;
        
            tmp_n = cross(face_v_e1, face_v_e2); % 1X3 array
            check_e = tmp_p1; % 1X3 array
            
            if(dot(tmp_n, check_e) < 0) % tmp_n is the interior vector
                tmp_n = -tmp_n;
            end
            face_n(k, :) = tmp_n / norm(tmp_n);
        end

        % calc the edge 1 and edge 2 extern normal vector
        % this edge is (i, j), satisfy i < j, i, j is the id of the vertices
        edge_n = zeros(2, 3);
        for k = 1 : 2
            tmp_n = cross(r_e12, face_n(k, :));
            tmp_f = facets(edge_table(i, j, k), :); % 1X3 array
            for q = 1 : 3
                if(tmp_f(1, q) == i || tmp_f(1, q) == j)
                    continue;
                else
                    tmp_p3 = vertices(tmp_f(1, q), :);
                    tmp_p1 = vertices(i, :);
                    tmp_v = 0.5 * r_e12 + (tmp_p1 - tmp_p3);
                    if(dot(tmp_v, tmp_n) < 0)
                        tmp_n = -tmp_n;
                    end
                        edge_n(k, :) = tmp_n / norm(tmp_n);
                    break;
                end
            end  
        end
        
        %E_e is a 3X3 array
        E_e = kron(face_n(1, :), edge_n(1, :)') + kron(face_n(2, :), edge_n(2, :)');

        grav_pot_first_term  = grav_pot_first_term + r_e1 * E_e * r_e1' * L_e;
        grav_attr_first_term = grav_attr_first_term + E_e * r_e1' * L_e;
        grav_grad_first_term = grav_grad_first_term + E_e * L_e;
    end
end

grav_pot_first_term  = -0.5 * G * rho * grav_pot_first_term;
grav_attr_first_term = -1 * G * rho * grav_attr_first_term;
grav_grad_first_term = G * rho * grav_grad_first_term;

% calc the second term of the gravity potential
grav_pot_second_term  = 0;
grav_attr_second_term = zeros(3, 1);
grav_grad_second_term = zeros(3, 3);
facet_size = length(facets);

for i = 1 : facet_size
    tmp_p1 = vertices(facets(i, 1), :);
    tmp_p2 = vertices(facets(i, 2), :);
    tmp_p3 = vertices(facets(i, 3), :);
    
    r_f1 = pos - tmp_p1;
    face_v_e1 = tmp_p2 - tmp_p1;
    face_v_e2 = tmp_p3 - tmp_p1;

    tmp_n = cross(face_v_e1, face_v_e2);
    check_e = tmp_p1;
    if(dot(tmp_n, check_e) < 0)
        tmp_n = -tmp_n;
    end
    
    n_f = tmp_n / norm(tmp_n);

    r1 = pos - tmp_p1;
    r2 = pos - tmp_p2;
    r3 = pos - tmp_p3;
    
    r1_len = sqrt(r1 * (r1'));
    r2_len = sqrt(r2 * (r2'));
    r3_len = sqrt(r3 * (r3'));
    omega = 2 * atan2(dot(r1, cross(r2, r3)), r1_len * r2_len * r3_len + ...
                  r1_len * dot(r2, r3) + r2_len * dot(r1, r3) + r3_len * dot(r1, r2));

    delta_ang = delta_ang + omega;

    F_f = kron(n_f, n_f');
    grav_pot_second_term  = grav_pot_second_term + r_f1 * F_f * r_f1' * omega;
    grav_attr_second_term = grav_attr_second_term + F_f * r_f1' * omega;
    grav_grad_second_term = grav_grad_second_term + F_f * omega;
end

grav_pot_second_term  = 0.5 * G * rho * grav_pot_second_term;
grav_attr_second_term =       G * rho * grav_attr_second_term;
grav_grad_second_term =  -1 * G * rho * grav_grad_second_term;

% return the complete result
grav_pot = grav_pot_first_term + grav_pot_second_term;
grav_attr = (grav_attr_first_term + grav_attr_second_term)'; % 1X3 array
grav_grad = grav_grad_first_term + grav_grad_second_term;
inner_ang = delta_ang;
end

