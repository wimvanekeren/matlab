function limitPlotData(figh,N,Nmin_shrink,doshrink,dofilt,maxres,minres)
% limitPlotData(figh,N,doshrink,dofilt,maxres,minres)
% Limits the number of samples per line in all axes in the figure with
% handle figh. Especially usefull when exporting the figure with e.g.
% matlab2tikz. Working:
% 1. Reduce the number of samples per line to N
% 2. If doshrink, "shrink" the data even more, i.e. using shrinkdata(), it
% skips samples based on the calculated radius of curvature of the line (as
% appearing on the screen).
%
% figh: figure handle
%
% Wim van Ekeren, 2016
% wimvanekeren@gmail.com

if ~exist('doshrink','var')
    dofilt = 0;
end

if ~exist('dofilt','var')
    dofilt = 0;
end


if ~exist('maxres','var')
    maxres = 1;
end

% GET LIST OF FIGURE HANDLES
ha=findobj(figh,'type','axes');
for i=1:length(ha);
    
    % find all lines int he plot
    hl = findobj(ha,'type','line');

    % limit data for every line
    for j=1:length(hl)
        limitThisPlotData(figh,ha(i),hl(j),N,Nmin_shrink,doshrink,dofilt,maxres,minres);
    end
end


function limitThisPlotData(figh,ha,hl,N,Nmin_shrink,doshrink,dofilt,maxres,minres)
% get plotdata
xdata = get(hl,'xdata');
ydata = get(hl,'ydata');
zdata = get(hl,'zdata');

% PRELIMINARY DOWNSCALING OF DATA TO N SAMPLES
if ~isempty(zdata)
    zdata = limitData(zdata);
end
disp(['limiting data to ' num2str(N) ' samples...'])
xdata = limitData(xdata,N);
ydata = limitData(ydata,N);

% SHRINKING 
% works only if there is no zdata
if isempty(zdata) && doshrink && length(xdata) > Nmin_shrink
    [xdata,ydata] = shrinkdata(figh,ha,xdata,ydata,dofilt,maxres,minres);
    disp(['shrinking data to ' num2str(length(xdata)) ' samples...'])
end

% UPDATE PLOT DATA
set(hl,'xdata',xdata,'ydata',ydata,'zdata',zdata);


function dout =limitData(din,N)
n=length(din);
if n>N
    idx = floor(linspace(1,n,N));
    dout = din(idx);
else
    dout=din;
end
    
