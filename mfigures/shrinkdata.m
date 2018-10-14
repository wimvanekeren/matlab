function [xn,yn,skip,yfilt,R,restarget,curres] = shrinkdata(f,ax,x,y,dofilt,maxres,minres,sensitivity)
% decreases the amount of samples of a data set x,y which is plotted in ax,
% so that exporting to tikz is lighter
% it does this by analyzing the radius of curvature and the density of
% samples at each point on the curve, and downsizing the density
% accordingly.
%
% f:           figure handle
% ax:          axis handle
% x:           x data in plot
% y:           y data in plot
% dofilt:      do filtering for noise (tricky!)
% minres:      (0.05) minimum resolution in samples per px on screen
% minres:      (1) maximum resolution in samples per px on screen
% sensitivity: (1000) sensitivity of radius of curvature -> target
%              resulution, used in the sigmoid function. higher values gives
%              higher sensitivity

if ~exist('sensitivity','var')
    sensitivity= 500; % lower values = higher sensitivity
end
if ~exist('minres','var')
    minres     = 0.05; % minimum resolution in samples per px on screen
end
if ~exist('maxres','var')
    maxres     = 2;
end

if ~exist('dofilt','var')
    dofilt = 0;
end

if size(x,1)==1
    x=x';
    do_transp_x=1;
else
    do_transp_x=0;
end

if size(y,1)==1
    y=y';
    do_transp_y=1;
else
    do_transp_y=0;
end


axpos = get(ax,'position');
figpos = get(f,'position');

axwidth = axpos(3)*figpos(3);
axheight = axpos(4)*figpos(4);

xlimits = get(ax,'XLim');
deltax = (xlimits(2)-xlimits(1))/axwidth; % unit plot x per px on screen
ylimits = get(ax,'YLim');
deltay = (ylimits(2)-ylimits(1))/axheight; % unit plot y per px on screen

N   = length(x);
if dofilt
    yfilt = convgauss(y,floor(N/50),1);
else
    yfilt = y;
end

% differences, normalized over axis limits
dy  = diff(yfilt)/deltay;
dx  = diff(x)/deltax;

% vector analysis
vk = [dx dy];
Lk = sqrt(vk(:,1).^2 + vk(:,2).^2); % length of sample in px on screen
nk = vk;
nk1= [nk(2:end,:); 0 0];

% radius of curvature
d1=nk;
d2=nk1-nk;
xd=d1(:,1);
yd=d1(:,2);
xdd=d2(:,1);
ydd=d2(:,2);
R = (xd.^2 + yd.^2).^(3/2)./abs(xd.*ydd - yd.*xdd); % radius of curvature (px)

% determine skipping rate
curres     = 1./Lk; % current resolution in samples per px on screen
resolution = 1-1./(1+exp(-R./(sensitivity))); % resolution indicator from 0(min) to 1 (max), in samples per px on screen (sigmoid function from 1->0 in with x=dnk)
restarget   = minres+maxres*resolution; % final target resolution in samples per px on screen
skip       = floor(curres./restarget); % estimated skipping rate

skip(1)=0; %always keep first sample

% start skipping routine
xn = [];
yn = [];
nskip = 0;
i=1;
while 1
    
    % ending
    if i>=N
        xn(end+1)=x(i);
        yn(end+1)=yfilt(i);
        break
    end
   
    % skipping?
    if nskip<skip(i)
        nskip = nskip+1;
    else
        if nskip > 2
            yn(end+1)=yfilt(i);
        else
            yn(end+1)=y(i);
        end
        xn(end+1)=x(i);
        nskip = 0;
    end
    
    i=i+1;
        
    
end

if do_transp_x
    xn = xn';
end

if do_transp_y
    yn = yn';
end