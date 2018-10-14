function h = buildFromTemplateProps(te)

% draw figure
h.fig = figure(...
    'units',te.fig.units,...
    'position',te.fig.pos,...
    'Color',te.fig.color);

% draw all panels
obj_names = fieldnames(te);
for i=1:length(obj_names)
    
    if isfield(te.(obj_names{i}),'type')
        switch te.(obj_names{i}).type

            case 'uipanel'
                h.(obj_names{i}) = uipanel;
                fn = fieldnames(te.(obj_names{i}));
                for j=1:length(fn)
                    if ~any(strcmpi(fn{j},{'type','parent'}));
                        set(h.(obj_names{i}),fn{j},te.(obj_names{i}).(fn{j}));
                    end
                end                 
            case 'axes'
                h.(obj_names{i}) = axes;    
                fn = fieldnames(te.(obj_names{i}));
                for j=1:length(fn)
                    if ~any(strcmpi(fn{j},{'type','parent'}));
                        set(h.(obj_names{i}),fn{j},te.(obj_names{i}).(fn{j}));
                    end
                end 
            case 'uicontrol'
                h.(obj_names{i}) = uicontrol;
                fn = fieldnames(te.(obj_names{i}));
                for j=1:length(fn)
                    if ~any(strcmpi(fn{j},{'type','parent'}));
                        set(h.(obj_names{i}),fn{j},te.(obj_names{i}).(fn{j}));
                    end
                end      
            case 'uitable'
                h.(obj_names{i}) = uitable;
                fn = fieldnames(te.(obj_names{i}));
                for j=1:length(fn)
                    if ~any(strcmpi(fn{j},{'type','parent'}));
                        set(h.(obj_names{i}),fn{j},te.(obj_names{i}).(fn{j}));
                    end
                end                  
        end
       
    end
end