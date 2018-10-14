function T = rotation(angle,axis)
% T = rotation(angle,axis)
% gives rotation matrix



if axis==1;
   T = [1       0           0
        0       cos(angle)  sin(angle)
        0       -sin(angle) cos(angle)];
elseif axis==2;
    T = [   cos(angle)        0       -sin(angle)
            0                 1       0 
            sin(angle)        0       cos(angle)];
    
elseif axis==3;
    T = [   cos(angle)  sin(angle)  0
            -sin(angle) cos(angle)  0
            0           0           1];
    
end