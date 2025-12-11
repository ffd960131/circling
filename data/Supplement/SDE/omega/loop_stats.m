clear; clc;

M = 50;

crossings1 = [];
L1 = [];
NT1 = [];

for i = 1:6

    load(['traj5_',num2str(i),'.mat']);
    X = x;
    Y = y;

    for m = 1:size(x,2)

        x = X(:,m);
        y = Y(:,m);

        x = (x - min(x(:))) / (max(x(:)) - min(x(:)));
        y = (y - min(y(:))) / (max(y(:)) - min(y(:)));

        n = numel(x);
        crossings = 0; lengths = [];

        path_length = @(X,Y) sum(sqrt(diff(X).^2 + diff(Y).^2));

        for i = 1:n-3
            for j = i+2:n-1
                [isC,~] = seg_intersect([x(i) y(i)], [x(i+1) y(i+1)], ...
                                        [x(j) y(j)], [x(j+1) y(j+1)]);
                if isC
                    crossings = crossings + 1;
                    lengths(end+1) = path_length(x(i:j),y(i:j));
                end
            end
        end

        L = path_length(x,y)/crossings;

        dx = diff(x);
        dy = diff(y);
        ds = sqrt(dx.^2 + dy.^2);
        theta = atan2(dy, dx);
        dtheta = diff(theta);
        NT = sum(abs(dtheta)) / sum(ds);

        crossings_all(m) = crossings;
        crossings_mean = mean(crossings_all);
        L_all(m) = L;
        L_mean = mean(L);
        NT_all(m) = NT;
        NT_mean = mean(NT_all);

    end

    crossings1 = [crossings1; crossings_mean];
    L1 = [L1; L_mean];
    NT1 = [NT1; NT_mean];
end

function [isC, p] = seg_intersect(A,B,C,D)
p = [];
den = (D(2)-C(2))*(B(1)-A(1)) - (D(1)-C(1))*(B(2)-A(2));
if abs(den) < 1e-12, isC = false; return; end
ua = ((D(1)-C(1))*(A(2)-C(2)) - (D(2)-C(2))*(A(1)-C(1)))/den;
ub = ((B(1)-A(1))*(A(2)-C(2)) - (B(2)-A(2))*(A(1)-C(1)))/den;
isC = (ua>=0 && ua<=1 && ub>=0 && ub<=1);
if isC
    p = A + ua*(B-A);
end
end
