function [ line ] = lineEqn(pt1, pt2)
%lineEqn returns m, x, b for a line containing points pt1, pt2.
m = (pt1(2) - pt2(2)) / (pt1(1) - pt2(1));

b = pt1(2) - (m * pt1(1));

line = [m,b];
end

