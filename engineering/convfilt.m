function yfilt = convfilt(y,D)
% yfilt = convfilt(y,D)
% Moving average filter, depth D.
n = (2*D-1);
F = ones(n,1)/n;
yfilt = conv(y,F,'same');

