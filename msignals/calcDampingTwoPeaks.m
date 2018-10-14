function [zeta,wn] = calcDampingTwoPeaks(y1,y2,t1,t2,M,n)
% VERIFIED
% see
% http://www.cs.mun.ca/av/old/teaching/cs/notes/time2_inclass.pdf
%
% y1,t1: peak 1, value and time
% y2,t2: peak 2, value and time
% M:     final value
% n:     number of periodes t1 and t1 are apart
% 
% A. generic step-response second order system:
% y(t) = M*(1-1/(sqrt(1-zeta^2)) * exp(-zeta*wn*t) * ...
%   cos( wn*sqrt(1-zeta^2)t - phi )
%           --> phi = atan( zeta/(sqrt(1-zeta^2) )
%
% B. and time derivative (equals impulse response)
% dy/dt = 1/sqrt(1-zeta^2) exp(-zeta * wn *t) * sin( wn*sqrt(1-zeta^2)*t )
% 
% 1. use (A) to compare peaks: (y1-1)/(y2-1)
% 2. use (B) to find time of peaks: 
%     dy/dt = 0 --> wn*sqrt(1-zeta^2)*t = 0 + k*pi --> ...
%     t2-t1 = (2*n*pi)/(wn*sqrt(1-zeta^2))
%
% combine 1+2 to yield a relation for zeta and wn

if ~exist('n','var')
    n=1;
end

dt = t2-t1;
lnzooi = log(y1-M)-log(y2-M);

B = lnzooi/(2*n*pi);
zeta = sqrt(B^2/(B^2+1));

zeta_wn = lnzooi/dt;
wn      = zeta_wn/zeta;


end