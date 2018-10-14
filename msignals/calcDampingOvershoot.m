function zeta = calcDampingOvershoot(OS)
% VERIFIED
% calculate damping using the overshoot, OS = (ypeak-M)/M
B = (-log(OS)/pi)^2;
zeta = sqrt(B/(B+1));
end
