function te = getTemplateProps(templatename);

propsfilename = [templatename '.mat'];
h = eval([templatename ';']);



% main figure;
te.fig.type = 'figure';
te.fig.pos = get(h,'position');
te.fig.units = get(h,'units');
te.fig.color = get(h,'color');


objectlist = findall(h);

% find all uicontrols
uiclist = findobj(objectlist,'type','uicontrol');


for i=1:length(uiclist)
    tag = get(uiclist(i),'tag');
    
    if isempty(tag) == 0    
        te.(tag).type = 'uicontrol';
        te.(tag).style = get(uiclist(i),'style');
        te.(tag).units = get(uiclist(i),'units');
        te.(tag).pos = get(uiclist(i),'position');
        te.(tag).string = get(uiclist(i),'string');
        te.(tag).min = get(uiclist(i),'min');
        te.(tag).max = get(uiclist(i),'max');
        te.(tag).backgroundcolor = get(uiclist(i),'backgroundcolor');
        te.(tag).fontsize = get(uiclist(i),'fontsize');
        te.(tag).fontunits = get(uiclist(i),'fontunits');
        te.(tag).parent = get(get(uiclist(i),'parent'),'tag');
        te.(tag).horizontalalignment = get(uiclist(i),'horizontalalignment');
    end
end


% find all panels
panellist = findobj(objectlist,'type','uipanel');
for i=1:length(panellist)
    tag = get(panellist(i),'tag');
    
    if isempty(tag) == 0
        te.(tag).type = 'uipanel';
        te.(tag).units = get(panellist(i),'units');
        te.(tag).pos = get(panellist(i),'position');
        te.(tag).bgcolor = get(panellist(i),'backgroundcolor');
        te.(tag).fontsize = get(panellist(i),'fontsize');
        te.(tag).fontunits = get(panellist(i),'fontunits');        
        te.(tag).title = get(panellist(i),'title');
        te.(tag).parent = get(get(panellist(i),'parent'),'tag');
    end
end

% find all axes
axeslist = findobj(objectlist,'type','axes');
for i=1:length(axeslist)
    tag = get(axeslist(i),'tag');
    
    if isempty(tag) == 0
        te.(tag).type = 'axes';
        te.(tag).units = get(axeslist(i),'units');           
        te.(tag).pos = get(axeslist(i),'position');
        te.(tag).parent = get(get(axeslist(i),'parent'),'tag');
    end
end

% find all tables
axeslist = findobj(objectlist,'type','uitable');
for i=1:length(axeslist)
    tag = get(axeslist(i),'tag');
%     keyboard
    if isempty(tag) == 0
        te.(tag).type = 'uitable';
        te.(tag).units = get(axeslist(i),'units');            
        te.(tag).pos = get(axeslist(i),'position');
        te.(tag).parent = get(get(axeslist(i),'parent'),'tag');
    end
end


save(propsfilename,'te');
% pause
close(h)
