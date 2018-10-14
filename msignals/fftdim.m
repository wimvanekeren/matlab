function [f,magy,phasey] = fftdim(y,ts,Nfft)
% [f,magy,phasey] = fft_dimensional(y,ts,Nfft)
% calculates fft(y,Nfft) and converts result to usable, dimensional outputs
% 
% INPUTS
%   y         input time signal
%   ts        sample time of signal y
%   Nfft      number of samples to be used for fft. if no number is given,
%   the greatest power of 2 will be taken: Nfft = 2^(length(dec2bin(n))-1)
%
% OUTPUTS
%   f         frequency (Hz)
%   magy      magnitude, in same units of y
%   phasey    phase (rad)

% T=100;

% t=linspace(0,T-ts,N);
% fy = [0.1 0.15 0.2 0.5]; % in Hz
% phy = [10 20 30 40]*pi/180;
% for i=1:length(fy)
% suby(:,i)=sin(2*pi*fy(i)*t + phy(i)); % y(t)
% end
% y = sum(suby,2) + 1;

if ~exist('Nfft','var')
    Nfft = 2^(length(dec2bin(length(y)))-1);
end

Y = fft(y,Nfft);
magy = abs(Y(1:Nfft/2,:))*2/Nfft;
% magY2 = abs(Y(N:-1:N/2+2,:));
phasey = angle(Y(1:Nfft/2,:));

T = Nfft*ts;
f = (0:Nfft/2-1)/T;
% figure; plot(t,y)
% xlabel('time [s]')
% figure; plot(f,[magY])
% xlabel('f [Hz]')
