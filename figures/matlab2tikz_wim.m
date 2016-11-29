function matlab2tikz_wim(varargin)
% matlab2tikz_wim(f,filename,...)
% export figure to tikz figure and limit XData/YData in all plots using
% limitPlotData() and shrinkdata()
% 
% INPUTS
% f:            figure handle
% filename:     output filename (without .tex extension)
% N:            (1000) max nubmer of samples per line in plot. if doshrink,
%               best practice is to set N very high (N~10^4) and set 
%               "maxres" to your liking
% Nminshrink    (500) minimum number of samples for shrinking
% keep_ratio:   (true) keep the current ratio of the figure position
% doshrink:     (true) shrink data, see limitPlotData() and shrinkdata()
% dofilt:       (false) when shrinking, do filtering
% maxres:       (2) maximum resolution on screen (samples/px)
% minres:       (0.05) minimum resulotion on screen (samples/px)
% saveFigCopy:  (true) save a matlab .fig copy with the same filename
% TickFormat:   (auto) number formating of tick labels 'auto','fixed',
%               'sci',...
% +other:       all other paramters are passed to matlab2tikz
% 
% example:
% 
% MATLAB:
% =============================
% t=[0:0.001:10]';
% s=tf('s');
% zeta=0.4;
% wn  = 6*pi;
% h=wn^2/(s^2+2*zeta*wn*s+wn^2);
% y=step(h,t);
% plot(t,y,'s-');
% set(gca,'FontSize',8);
% title('badness $\phi$','fontweight','bold','interpreter','latex');
% xlabel('1 to 10');
% ylabel('angle [deg]','fontsize',14);
% 
% % 1:
% matlab2tikz(gcf,'fig_tikz.tex');
% 
% % 2:
% N           = 10000;
% dofilt      = 1;
% keep_ratio  = 0;
% maxres      = 2;
% minres      = 0.05;
% doshrink    = 1;
% matlab2tikz_wim(gcf,'fig_tikz.tex','N',N,'maxres',maxres);
% 
% % 3:
% matlab2tikz_wim(gcf,'fig_tikz.tex',N,keep_ratio,doshrink);
% =============================
%
% LATEX:
% =============================
% ..
% \usepackage{pgfplots}
% \newlength\fheight
% \newlength\fwidth
% \def\ylabeldist{-0.08} % y right positive
% \def\xlabeldist{-0.10} % x up positive
% \newcommand{\labelsize}{\footnotesize}
% \newcommand{\ticksize}{\scriptsize}
% ..
% \begin{figure}
% 	\centering
% 	\setlength{\fwidth}{0.5\textwidth}
% 	\setlength{\fheight}{1\textwidth}
%   \def\ylabeldist{-0.12} % y right positive
%   \def\xlabeldist{-0.16} % x up positive      
% 	\input{fig_tikz}
% \end{figure}
% =============================
%
% Wim van Ekeren, 2016
% wimvanekeren@gmail.com

%%%%%%%%%%%%%%%%%%%
% PARSE INPUTS
%%%%%%%%%%%%%%%%%%%
p = inputParser;
p.KeepUnmatched = true;

% local & limitPlotData parameters
addRequired(p,'f',@ishandle);
addRequired(p,'filename',@ischar);
addOptional(p,'N',1000,@isnumeric);
addOptional(p,'Nmin_shrink',500,@isnumeric);
addOptional(p,'keep_ratio',0,@isnumeric);
addOptional(p,'doshrink',1,@isnumeric);
addOptional(p,'dofilt',0,@isnumeric);
addOptional(p,'maxres',2,@isnumeric);
addOptional(p,'minres',0.05,@isnumeric);
addOptional(p,'saveFigCopy',1);
addOptional(p,'TickFormat','auto');
addOptional(p,'FontSize',[],@isnumeric);

% matlab2tikz parameters
addOptional(p,'width','\fwidth',@ischar);
addOptional(p,'height','\fheight',@ischar);
addOptional(p,'interpretTickLabelsAsTex',true,@ischar);
addOptional(p,'extraAxisOptions',{});
addOptional(p,'doSmartLabelDistance',1);

parse(p,varargin{:});

% local & limitPlotData parameters
f           = p.Results.f;
filename    = p.Results.filename;
N           = p.Results.N;
keep_ratio  = p.Results.keep_ratio;
doshrink    = p.Results.doshrink;
dofilt      = p.Results.dofilt;
maxres      = p.Results.maxres;
minres      = p.Results.minres;
saveFigCopy = p.Results.saveFigCopy;
TickFormat  = p.Results.TickFormat;
Nmin_shrink = p.Results.Nmin_shrink;
FontSize    = p.Results.FontSize;


% matlab2tikz parameters
width                       = p.Results.width;
height                      = p.Results.height;
interpretTickLabelsAsTex    = p.Results.interpretTickLabelsAsTex;
extraAxisOptions            = p.Results.extraAxisOptions;
doSmartLabelDistance        = p.Results.doSmartLabelDistance;

% initial commands
% set FontSize
if ~isempty(FontSize)
    ha=findobj(f,'type','axes');
    for i=1:length(ha);
        set(ha(i),'FontSize',FontSize)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMIT PLOTDATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
limitPlotData(f,N,Nmin_shrink,doshrink,dofilt,maxres,minres); 

% save .fig copy of this figure
if saveFigCopy
    saveas(f,filename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB2TIKZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make varargin for matlab2tikz from unmatched parameters in input parser:
fn = fieldnames(p.Unmatched);
vararg_tikz = {};
for i=1:length(fn)
    vararg_tikz{end+1} = fn{i};
    vararg_tikz{end+1} = p.Unmatched.(fn{i});
end

extraAxisOptions{end+1}     =   'title style={font=\labelsize}';
extraAxisOptions{end+1}     =   'xlabel style={font=\labelsize}';
extraAxisOptions{end+1}     =   'ylabel style={font=\labelsize}';
extraAxisOptions{end+1}     =   'legend style={font=\labelsize}';
extraAxisOptions{end+1}     =   'ticklabel style={font=\ticksize}';

if doSmartLabelDistance
    extraAxisOptions{end+1}     =   'xlabel style={at={(axis description cs:0.5,\xlabeldist)}}';
    extraAxisOptions{end+1}     =   'ylabel style={at={(axis description cs:\ylabeldist,0.5)}}';
end
if ~strcmp(TickFormat,'auto')
    extraAxisOptions{end+1} = ['xticklabel style={/pgf/number format/.cd, ' TickFormat '}'];
    extraAxisOptions{end+1} = ['yticklabel style={/pgf/number format/.cd, ' TickFormat '}'];
end

% make tikz figure
if keep_ratio
    pos = get(f,'position');
    h_b = pos(4)/pos(3); % height/width ratio
    
%     tmpfile='tmp.tex';
    matlab2tikz([filename '.tex'],...
        'figurehandle',f,...
        'width',width,...
        'height',[num2str(h_b) '\fwidth'],...
        'interpretTickLabelsAsTex',true,...
        'floatFormat','%02.4f',...
        'extraAxisOptions',extraAxisOptions,...
        vararg_tikz{:})
else
%     tmpfile='tmp.tex';
    matlab2tikz([filename '.tex'],...
        'figurehandle',f,...
        'width',width,...
        'height',height,...
        'interpretTickLabelsAsTex',interpretTickLabelsAsTex,...
        'floatFormat','%02.4f',...
        'extraAxisOptions',extraAxisOptions,...
        vararg_tikz{:})
end

% rmTikzTicksOpts(tmpfile,filename)
% delete(tmpfile)