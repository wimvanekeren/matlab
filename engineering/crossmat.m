function A = crossmat(a)
% makes skew symmetric matrix A such that
%   cross(a,b) = A*b
A = [0      -a(3)   a(2);
     a(3)   0       -a(1);
     -a(2)  a(1)    0];