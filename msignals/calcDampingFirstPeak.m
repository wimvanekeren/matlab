function [zeta,wn] = calcDampingFirstPeak(y1,t1,M1)
% damping and freq from first peak time and value, by minimization
% 
% note that from previous equations we can calculate the peak time of the
% first peak: peaktime = @(zeta,wn) (pi/(wn*sqrt(1-zeta^2)));
% 
% this we fill in into the general step response equation, and then find
% soution for setting this equal to the found peak height (minimization
% problem).


phase  = @(zeta) (atan( zeta/sqrt(1-zeta^2) ) );
valfcn = @(t,zeta,wn,M) (M*(1-1/(sqrt(1-zeta^2)) * exp(-zeta*wn*t) .* ...
    cos( wn*sqrt(1-zeta^2)*t - phase(zeta) ) ) );

peaktimefcn = @(zeta,wn) (pi/(wn*sqrt(1-zeta^2)));
peakfcn = @(zeta,M) (valfcn(peaktimefcn(zeta,1),zeta,1,M));

zerofcn = @(yp,zeta) (peakfcn(zeta,M1)-yp);
minfcn = @(zeta) (abs(zerofcn(y1,zeta)));

x0 = [0.5];
[zeta,val] = fminsearch(minfcn,x0);

% wn can be found by rearranging the peaktimefcn:
wn = pi/(t1*sqrt(1-zeta^2));

end