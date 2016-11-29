function dy=numdif(y,D)
% dy=numdif2(y,D)
% numerical differentiation with 2-4-6-8 point difference methods
% D: depth of differentiation. number of samples that are used is 2*D
% 
% Wim van Ekeren


transpose=0;
if size(y,1)==1
    y=y';
    transpose=1;
end


n=2*D+1;
assert(n <= size(y,1),'Length of y must be at least 2*D+1')

switch D
    case 1
        F = [1/2 0 -1/2]';
    case 2
        F = [1/12 1/3 0 -1/3 -1/12]';
    case 3
        F = [1/60 -3/20 3/4 0 -3/4 3/20 -1/60]';
    case 4
        F = [-1/280	4/105	-1/5	4/5	0	-4/5	1/5	-4/105	1/280]';
end

for i=1:size(y,2)
    dy(:,i) = conv(y(:,i),F,'same');
end

if transpose
    dy=dy';
end




