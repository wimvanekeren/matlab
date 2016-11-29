function StepInfo = stepwimfo(y,t,M)
% StepInfo = stepwimfo(y,t,M)
% Extract step response characteristics from step-response measurement data
% y: non-normalized output signal (nx1 or 1xn)
% t: time signal (optional)
% M: step size (optional, put NaN to let M be found)
% 
% Step is assumed to be positive!
%
% Output:
% ==========================
% StepInfo.yInit            initial value
% StepInfo.tInit            start of step time
% StepInfo.ySteady          steady state value
% StepInfo.stepSize         signal step size ySteady-yInit
% StepInfo.tSettling        5% setlling time
% StepInfo.tRise            63% rise time
% StepInfo.NoiseStdDev      noise standard deviation
% StepInfo.SNR              step-to-noise ratio
% StepInfo.yFilt            yfilt=convgauss(y,n_sigma)
% StepInfo.report           
%   0:  correct
%   1:  high noise
%   2:  no steady state
%   3:  divergence detected
%   4:  anything else


if ~exist('t','var')
    t=1:length(y);
end

if ~exist('M','var')
    M = nan;
end

flag_fatal      = 0;
flag_divergence = 0;

% BASIC INFO
StepInfo = getStepInfo(y,t,M);

% SEARCH FOR PEAKS
if ~[StepInfo.report==4]
    peak_tolerance  = abs(0.5*StepInfo.NoiseStdDev + 0.05*StepInfo.stepSize); 
    [maxt,mint]     = peakdet(StepInfo.yFilt-StepInfo.yInit, peak_tolerance, t-StepInfo.tInit); 
else
    peak_tolerance  = nan;
    flag_fatal      = 1;
    maxt = [];
    mint = [];
end



if ~isempty(maxt)
    peaksTime  = maxt(:,1);
    peaksVal   = maxt(:,2);
    
    if peaksVal(end) > peaksVal(1) 
        warning('Unstable signal.')
        flag_divergence = 1;
    end
    
else 
    peaksTime  = [];
    peaksVal   = [];    
end

if ~isempty(mint)
    valleysTime = mint(:,1);
    valleysVal  = mint(:,2);
    
    if peaksVal(end) > peaksVal(1) 
        warning('Unstable signal.')
        flag_divergence = 1;
    end
    
else
    valleysTime = [];
    valleysVal  = [];
end

% GET DAMPING/FREQUENCY ESTIMATES
if flag_divergence || StepInfo.report==4
    flag_fatal = 1;
end

if ~flag_fatal
    [wn,zeta,method,weight] = getDampingEstimates(peaksTime,peaksVal,valleysTime,valleysVal,StepInfo.stepSize,StepInfo.NoiseStdDev);
else
    wn      = nan;
    zeta    = nan;
    method  = nan;
    weight  = nan;
end

% MEAN / STANDARD DEVIATION
zeta_final = sum(zeta.*weight)/sum(weight);
wn_final   = sum(wn.*weight)/sum(weight);


% StepInfo.report           
%   0:  correct
%   1:  high noise
%   2:  no steady state
%   3:  divergence detected
%   4:  anything else
if flag_divergence
    StepInfo.report = 3;
end

% damping and frequency info
StepInfo.zeta         = zeta;
StepInfo.wn           = wn;
StepInfo.method       = method;
StepInfo.meanZeta     = zeta_final;
StepInfo.meanWn       = wn_final;

% peaks and valleys
StepInfo.peaksTime   = peaksTime;
StepInfo.peaksVal    = peaksVal;
StepInfo.valleysTime = valleysTime;
StepInfo.valleysVal  = valleysVal;
StepInfo.peakTol     = peak_tolerance;

end

function StepInfo = getStepInfo(y,t,M)
% y: non-normalized output signal
% t: time signal
% M: step magnitude (optional, put NaN to let M be found)


flag_noise      = 0;
flag_anything   = 0;
flag_nosteady   = 0;

do_find_mag = 1;
if ~exist('M','var')
    do_find_mag = 1;
    M           = nan;
elseif isnan(M) || isempty(M)
    do_find_mag = 1;
    M           = nan;
elseif isnumeric(M)
    do_find_mag = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL SIGNAL CHARACTERISTICS: NOISE/STEP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yd  = diff(y);
ydd = diff(yd);
stddevNoise    = sqrt(mean(ydd.^2));
if do_find_mag
    stepEstimate   = y(end)-y(1);
else
    stepEstimate   = M;
end
SNR            = stepEstimate/stddevNoise;


if SNR < 20
    warning('Step-to-Noise ratio is smaller than 20. Results might be inaccurate.')
    flag_noise = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILTER SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if SNR > 100
    n_sigma = 1;
elseif SNR > 50
    n_sigma = 3;
elseif SNR > 25
    n_sigma = 5;
elseif SNR > 15
    n_sigma = 8;
elseif SNR > 10
    n_sigma = 10;
else
    n_sigma = 15;
end
yfilt=convgauss(y,n_sigma,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL STARTING VALUE // STARTING TIME OF STEP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% determine rise threshold
if SNR < 30
    % some noise
    dy_rise = stddevNoise;
else
    % little noise
    dy_rise = stddevNoise+0.01*stepEstimate;
end

% get rise threshold
y_start  = yfilt(1)+dy_rise;
i_start  = find(yfilt >= y_start,1,'first');
if isempty(i_start)
    warning('stepwimfo:BadSignal','Cannot find starting of step')
    flag_anything = 1;
elseif i_start~=1
    i_start = i_start-1;
end

% get mean starting value
y_init = mean(y(1:i_start));
t_init = t(i_start);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FINAL STEADY-STATE VALUE // SETTLING-TIME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dy_sett = stddevNoise + 0.05*stepEstimate;
i_sett  = find(abs(yfilt-yfilt(end))>=dy_sett,1,'last');
if i_sett == length(y)
    warning('stepwimfo:BadSignal','Signal does not seem to have settled to steady state.');
    i_sett=i_sett-1;
    flag_nosteady = 1;
end
i_sett      = i_sett+1;
y_ss        = mean(y(i_sett:end));
t_sett      = t(i_sett);

if do_find_mag
    M       = y_ss - y_init;
    
    if M < 0
        warning('Step seems negative.')
        flag_anything = 1;
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update stepSize // more accurate SNR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stepSize = M;
SNR      = stepSize/stddevNoise;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RISE TIME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i_rise = find(yfilt >= y_init+0.63*M,1,'first');
t_rise = t(i_rise);

%%%%%%%%%%%%%%%%%%%%%%
% StepInfo.report           
%   0:  correct
%   1:  high noise
%   2:  no steady state
%   3:  divergence detected
%   4:  anything else
report = 0;
if flag_noise
    report = 1;
end

if flag_nosteady
    report = 2;
end

if flag_anything
    report = 4;
end

%%%%%%%%%%%%%
StepInfo.yInit      = y_init;
StepInfo.tInit      = t_init;
StepInfo.ySteady    = y_ss;
StepInfo.stepSize   = stepSize;
StepInfo.tSettling  = t_sett;
StepInfo.tRise      = t_rise;
StepInfo.NoiseStdDev = stddevNoise;
StepInfo.SNR = SNR;
StepInfo.yFilt = yfilt;
StepInfo.report = report;

end

function [wn,zeta,method,weight] = getDampingEstimates(peaksTime,peaksVal,valleysTime,valleysVal,M,NoiseStdDev)
% methods:
% 1: calcDampingFirstPeak
% 2: calcDampingPeakValley
% 3: calcDampingTwoPeaks

nPeaks   = length(peaksTime);
nValleys = length(valleysTime);

zeta = [];
wn   = [];
method = [];
weight = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%
% DETERMINE METHODS
%%%%%%%%%%%%%%%%%%%%%%%%%%
do_firstpeak  = 0;
do_peakvalley = 0;
do_peakpairs  = 0;
if nPeaks==0;
    % overdamped
    zeta = nan;
    wn   = nan;
else
    do_firstpeak = 1;
    if nValleys >= 1
        % one peak, at least one valley
        do_peakvalley = 1; 
    end
    
    if nPeaks > 1
        % multiple peaks
        do_peakpairs  = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%
if do_firstpeak
    % calculation by single peak
    t1 = peaksTime(1);
    y1 = peaksVal(1);
    [zeta(end+1),wn(end+1)] = calcDampingFirstPeak(y1,t1,M);
    method(end+1) = 1;     
    weight(end+1) = 0.5*abs(y1-M)/NoiseStdDev;    
end

if do_peakvalley
    % calculation by peak valley pairs
    nComparisons = nValleys;
    for i=1:nComparisons
        t1 = peaksTime(i);
        y1 = peaksVal(i);
        t2 = valleysTime(i);
        y2 = valleysVal(i);         
        [zeta(end+1),wn(end+1)] = calcDampingPeakValley(y1,y2,t1,t2,M);
        method(end+1) = 2;
        weight(end+1) = abs(y2-y1)/NoiseStdDev;
    end    
end

if do_peakpairs
    % calculation by peak pairs
    nComparisons = nPeaks-1;
    for i=1:nComparisons
        t1 = peaksTime(i);
        y1 = peaksVal(i);
        t2 = peaksTime(i+1);
        y2 = peaksVal(i+1);   
        
        n=1; % periods peaks are apart
        [zeta(end+1),wn(end+1)] = calcDampingTwoPeaks(y1,y2,t1,t2,M,n);
        method(end+1) = 3;
        weight(end+1) = abs(y2-y1)/NoiseStdDev;
    end    
end




end