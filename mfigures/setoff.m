function setoff(f,d)
% setoff(f,d) dispaces all ydata of all line plots in all axes of figure f by d
%
% usefull for checking whether signals/plotdata are overlapping
%
% when no input is given, f=gcf, d = 1/500 of ylimit difference

% cases no inputs
if nargin==0
    f=gcf;
end



figchilds = get(f,'children');
isax = boolean([strcmp(get(figchilds,'type'),'axes').*[~strcmp(get(figchilds,'tag'),'legend')]]);

h_ax = figchilds(isax);

for i=1:length(h_ax)

    ax = h_ax(i);
    
    % offset d
    if nargin<=1
        height = sum(abs(get(ax,'ylim')));
        d = height/500;
    end
    
    
    % get all plothandles in ax
    childs = get(ax,'children');
    isline = strcmp(get(childs,'type'),'line');
    h_lines = childs(isline);

    % dispace ydata
    dcur = d;
    for i=2:length(h_lines)

        % new ydata
        y = get(h_lines(i),'ydata') + dcur;

        % set ydata
        set(h_lines(i),'ydata',y);

        dcur = dcur+d;
    end
end
