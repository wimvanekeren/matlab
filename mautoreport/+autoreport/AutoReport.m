classdef AutoReport < handle
% Class to be able to quickly produce a tex-report with the currently
% opened figures in matlab. By pressing Export Report, a folder with a
% main.tex will be produced, containing figures and info.
% 
% Just construct the class to see its workings:
%
% Try executing any of the following:
%   AutoReport
%   EXAMPLE
%   autoreport.AutoReport
%   autoreport.EXAMPLE
% 
% Defaults:
%     obj.def.float             = '[h]';
%     obj.def.figwidth          = '0.8';
%     obj.def.check_export      = 1;
%     obj.def.check_singlefig   = 0;       
%     obj.def.author            = 'Unknown Author';
%     obj.def.ws_variables      = {'';'';'';'';'';'';'';''};       
%  
% Defaults can be altered by setting the variables in lines 36-49 in the
% constructor, or they can be given when calling the constructor in a
% struct variable, e.g.:
%   
%     mydef.float             = '[h]';
%     mydef.figwidth          = '0.2';
%     mydef.author            = 'Wim van Ekeren';
%   autoreport.AutoReport(mydef)
%     --> mydef can also be a .mat filename string, which contains a
%     struct variable called "def"
%
% Wim van Ekeren, 2015
    
    properties
        h = struct;         % contains all figure/object handles
        path = struct;      % path names struct
        file = struct;      % file names struct
        def = struct;       % defaults
        ws_variables = {};  % workspace variables
    end
    
    
    methods 
        
        function obj = AutoReport(def)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % GET DEFAULTS
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            this_file = which( '+autoreport/AutoReport.m' );
            assert( ~isempty( this_file ), ...
                'File not found, check that AutoReport is included in path.' );            
            
            % hard-coded defaults:
            obj.def.figpos = [50 50];
            obj.def.float = '[h]';
            obj.def.figwidth = '0.8';
            obj.def.check_export = 1;
            obj.def.check_singlefig = 0;       
            obj.def.author = 'Unknown Author';
            obj.def.ws_variables = {'';'';'';'';'';'';'';''};   
            obj.def.reporttag_base = 'report';
            obj.def.path.lib            = strrep([fileparts( this_file ) '/'],'\','/');%'C:/Users/Wim/Dropbox/MasterThesis/Programming/lib/+autoreport/';
            obj.def.path.save           = strrep([ pwd '/' ],'\','/'); % 'C:/Users/Wim/Dropbox/MasterThesis/Programming/AutoReports/'; % pwd;
            obj.def.doopen = 1;
            obj.def.dosavews = 1;
            obj.def.dokeeppaperpos = 0;
            obj.def.dosetlinewidth = 0;
            obj.def.table_length = 8;

            
            % if defaults are given, overwrite with defaults
            do_overwrite=0;
            if nargin>0
                if isstruct(def)
                    do_overwrite=1;
                elseif ischar(def)
                    filename_def = def;
                    load(filename_def); % should load variable named def
                    do_overwrite=1;
                else
                    warning('Input def must be a filename string, or a def struct.')
                end
                
            else
                % default config file
                if exist([obj.def.path.lib 'config.mat'],'file')
                    load([obj.def.path.lib 'config.mat']); % should load variable named def
                    do_overwrite = 1;
                end
                    
            end
            
            % overwrite obj.def with def
            if do_overwrite
                fn=fieldnames(def);
                for j=1:length(fn)
                    if strcmp(fn{j},'path')
                        fn2 = fieldnames(def.path);
                        for k=1:length(fn2)
                            obj.def.path.(fn2{k}) = def.path.(fn2{k});
                        end
                    else
                        obj.def.(fn{j}) = def.(fn{j});  
                    end
                end    
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % INITIALIZATION
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % set path and file structs
            obj.path.lib            = obj.def.path.lib;
            obj.path.save           = obj.def.path.save;
            obj.path.template       = [obj.def.path.lib 'textemplates/'];
            obj.file.templ.fig      = [obj.path.template 'fig.tex'];
            obj.file.templ.main     = [obj.path.template 'main.tex'];
            obj.file.templ.body     = [obj.path.template 'body.tex'];
            obj.file.templ.table    = [obj.path.template 'table.tex'];        
            
            
            % get caller file name
            stack = dbstack;
            if length(stack)==1
                obj.file.caller = '<CommandWindow>';
            else
                obj.file.caller = stack(2).file;
            end
            obj.path.pwd = strrep([ pwd '/' ],'\','/');
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % DRAW INITIAL FIGURE
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % figure template
            load([obj.path.lib 'figmanage_template.mat']);
            figures = findall(0,'Type','figure');
            % after 2015a, the figures are returned as objects instead of
            % handles...
            vers = version('-release');
            if str2num(vers(1:4)) >= 2015
                fighandles = nan( size( figures ) );
                for i = 1:numel( figures )
                    fighandles( i ) = figures( i ).Number;
                end
            else
                fighandles = figures;
            end
            
            
            n = length(fighandles);
            buttonheight = 20;
            buttonwidth  = 180;
            
            expbuttonheight = 20;
            expbuttonwidth  = 40;
            
            checkwidth   = 20;
            checkheight  = 20;

            figtagwidth = 0;
            figtagheight = 20; 
            
            figwidthwidth = 40;
            figwidthheight = 20;
            
            figcapwidth = 300;
            figcapheight = 20;
            
            
            % BUILD FIGURE
            obj.h = autoreport.buildFromTemplateProps(te);

            set(obj.h.fig,'Units','pixels','Name','AutoReport Control Panel')
            figpos = get(obj.h.fig,'Position');
            base      = figpos(3:4);
            figpos(4) = figpos(4) + (n+1)*(buttonheight+5);
            figpos(1:2) = obj.def.figpos;
            set(obj.h.fig,'Position',figpos);
            
            
            % reporttag
%             j=1;
%             tag_try = [obj.def.reporttag_base num2str(j,'%02.0f')];
%             file_folders = ls(obj.path.save);
%             while 1
%                 tag_unique = 1;
%                 for i=1:size(file_folders,1)
%                     if ~isempty(regexp(file_folders(i,:),tag_try,'once'))
%                         tag_unique = 0;
%                     end
%                 end
%                 
%                 if ~tag_unique
%                     j=j+1;
%                     tag_try = [obj.def.reporttag_base num2str(j,'%02.0f')];
%                 else
%                     % unique tag found
%                     reporttag = tag_try;
%                     break
%                 end
%             end
            reporttag = obj.def.reporttag_base; % number at end of reporttag
            
            
            % CALLBACK OF EXPORT BUTTON
            set(obj.h.button_export,'Callback',{@clickExpButton,obj})
            
            % SET DEFAULTS TO UICONTROLS ETC
            set(obj.h.edit_savepath,'String',obj.path.save,'HorizontalAlignment','right');
            set(obj.h.edit_reporttag,'String',reporttag,'HorizontalAlignment','left');
            set(obj.h.edit_description,'String','Empty Description','HorizontalAlignment','left');
            set(obj.h.edit_author,'String',obj.def.author,'HorizontalAlignment','left');
            set(obj.h.edit_reporttitle,'String',reporttag,'HorizontalAlignment','left');
             table_data   = cell(length(obj.def.ws_variables),2);
             table_labels = obj.def.ws_variables;
             table_values = cell(size(obj.def.ws_variables));
             table_data = {table_labels{:} ; table_values{:}}';
            set(obj.h.table_workspace,'Data',table_data,'ColumnEditable',[true],'ColumnName',{'variable','text'});
            set(obj.h.table_workspace,'CellEditCallback',{@setTableValues,obj});
            set(obj.h.button_default,'Callback',{@saveConfig,obj})
            set(obj.h.check_savews,'Value',obj.def.dosavews);
            set(obj.h.check_open,'Value',obj.def.doopen);
            set(obj.h.check_keeppaperpos,'Value',obj.def.dokeeppaperpos);
            set(obj.h.check_linewidth,'Value',obj.def.dosetlinewidth);
            
            obj = setTableValues([],[],obj);
            
            % make buttons, checkboxes for all figures
            for i=1:length(fighandles)

                figname    = get(fighandles(i),'Name');
                buttonname = ['Figure ' num2str(fighandles(i)) ': ' figname];
                %figtag  = ['fig' num2str(i,'%02.0f')];
                fighandle = fighandles(i);

                obj.h.fighandle{i} = fighandle;
                
                % FIGURE BUTTON
                x = 3;
                y = base(2) +(i-1)*(buttonheight+5);
                w = buttonwidth;
                he = buttonheight;
                obj.h.buttons{i} = uicontrol(...
                                'units','pixels',...
                                'position',[x y w he],...
                                'string',buttonname,...
                                'Callback',{@clickFigButton,obj.h.fighandle{i}});
                
                % DO EXPORT FIGURE
                x = 3 + buttonwidth+20;
                y = base(2) +(i-1)*(buttonheight+5);
                w = checkwidth;
                he = checkheight;
                obj.h.check_export{i} = uicontrol(...
                                'Style','checkbox',...
                                'units','pixels',...
                                'position',[x y w he],...
                                'tag',num2str(i),...
                                'Value',obj.def.check_export); 
                            
                % FIGURE WIDTH IN LATEX
                x = 3+buttonwidth+1*checkwidth+1*20+figtagwidth+20;
                y = base(2) +(i-1)*(buttonheight+5);
                w = figwidthwidth;
                he = figwidthheight;                           
                obj.h.text_figwidth{i} = uicontrol(...
                                'Style','edit',...
                                'units','pixels',...
                                'position',[x y w he],...
                                'tag',num2str(i),...
                                'String',obj.def.figwidth,...
                                'BackgroundColor',[1 1 1],...
                                'HorizontalAlignment','Left');  
                x = 3+buttonwidth+1*checkwidth+1*20+figtagwidth+20+figwidthwidth+20;
                y = base(2) +(i-1)*(buttonheight+5);
                w = figcapwidth;
                he = figcapheight;
                obj.h.text_figcap{i} = uicontrol(...
                                'Style','edit',...
                                'units','pixels',...
                                'position',[x y w he],...
                                'tag',num2str(i),...
                                'String',figname,...
                                'BackgroundColor',[1 1 1],...
                                'HorizontalAlignment','Left');  

            end
            
            x = 3 + buttonwidth+20;
            y = base(2) + n*(buttonheight+5);
            w = 80;
            he = checkheight;            
            obj.h.text_title1 = uicontrol(...
                                'Style','text',...
                                'units','pixels',...
                                'position',[x y w he],...
                                'tag',num2str(i),...
                                'String','Export',...
                                'HorizontalAlignment','Left'); 
            x = 3+buttonwidth+1*checkwidth+1*20+figtagwidth+20;
            y = base(2) + n*(buttonheight+5);
            w = figwidthwidth;
            he = figwidthheight;                                
            obj.h.text_title2 = uicontrol(...
                                'Style','text',...
                                'units','pixels',...
                                'position',[x y w he],...
                                'tag',num2str(i),...
                                'String','Width',...
                                'HorizontalAlignment','Left');
            x = 3+buttonwidth+1*checkwidth+1*20+figtagwidth+20+figwidthwidth+20;
            y = base(2) + n*(buttonheight+5);
            w = figcapwidth;
            he = figcapheight;                                
            obj.h.text_title3 = uicontrol(...
                                'Style','text',...
                                'units','pixels',...
                                'position',[x y w he],...
                                'tag',num2str(i),...
                                'String','Figure Caption',...
                                'HorizontalAlignment','Left');                               
            
        end
        
        

            
        
            

        
    end
    
    
end



function obj = setTableValues(hobj,event,obj)

    % TABLE DATA
    table_data      = get(obj.h.table_workspace,'Data');
    table_labels    = {table_data{:,1}};
%     keyboard
    
    i=0;
    TABLE = cell(obj.def.table_length,2);
    for i=1:length(table_labels);
        if ~isempty(table_labels{i})
            try
                value = evalin('base',[table_labels{i} ';']);
            catch e
%                 keyboards
%                 warning(['Error evaluating ' table_labels{i} ' in base workspace. Variable might not exist.'])
%                 disp(e.message);
                value = 'N/A';
            end

            if isnumeric(value)
                table_values{i} = num2str(value);
            elseif iscell(value)
                try
                    table_values{i} = evalc('base',['disp(' table_labels{i} ')']);
                catch
%                     warning(['Error evaluating ' table_labels{i} ' in base workspace. Variable might not exist.'])
%                     disp(e.message);
                    table_values{i} = 'N/A';     
                end
            elseif ischar(value)
                table_values{i} = value;          
            else
%                 warning(['Workspace variable ' table_labels{i} ' must be either string, numeric or cell of strings.'])
                table_values{i} = 'N/A';
            end


        else
            table_values{i} = 'N/A';
        end
        
        TABLE{i,1} = table_labels{i};
        TABLE{i,2} = table_values{i};        
    end            
    
    set(obj.h.table_workspace,'Data',TABLE);
end

function saveConfig(hobj,event,obj)
    def=obj.def;
    def.reporttag_base      = get(obj.h.edit_reporttag,'String');
    def.author              = get(obj.h.edit_author,'String');
    def.path.save           = get(obj.h.edit_savepath,'String');
        table_data          = get(obj.h.table_workspace,'Data');
    def.ws_variables        = {table_data{:,1}};
    def.figwidth            = get(obj.h.text_figwidth{end},'String');
    def.doopen              = get(obj.h.check_open,'Value');
    def.dosavews            = get(obj.h.check_savews,'Value');
    def.dokeeppaperpos      = get(obj.h.check_keeppaperpos,'Value');
    def.dosetlinewidth      = get(obj.h.check_linewidth,'Value');
    figpos                  = get(obj.h.fig,'Position');
    def.figpos              = figpos(1:2);
    
    
    save([obj.path.lib 'config'],'def')
    disp(['configuration saved to ' obj.path.lib 'config.mat']);
    disp('To restore original defaults, remove this file.')
end

function clickFigButton(hObj,event,fighandle)
    figure(fighandle)
end


function clickExpButton(hObj,event,obj)

import autoreport.*;

tabfilename = 'table.tex';
reporttag   = get(obj.h.edit_reporttag,'String');
stringdate = datestr(now,'yyyy_mm_dd__HH_MM_SS');
dirname = [stringdate '_' reporttag];

obj.path.save   = get(obj.h.edit_savepath,'String');
obj.path.report = [ obj.path.save dirname '/' ];
mkdir(obj.path.save,dirname);

% read checkboxsettings
if get(obj.h.check_savews,'Value');
    dosavews = 1;
else
    dosavews = 0;
end

if get(obj.h.check_open,'Value');
    doopen = 1;
else
    doopen = 0;
end

if get(obj.h.check_keeppaperpos,'Value');
    dokeeppaperpos = 1;
else
    dokeeppaperpos = 0;
end

if get(obj.h.check_linewidth,'Value')
    dosetlinewidth = 1;
    linewidth = str2double(get(obj.h.edit_linewidth,'String'));
else
    dosetlinewidth = 0;
    linewidth = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET SETUP VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE INFO
for i=1:length(obj.h.buttons)
    i_doexport(i) = get(obj.h.check_export{i},'Value');
    i_dosingle(i) = 0;%get(obj.h.check_singlefig{i},'Value');
    figtag{i}     = ['fig' num2str(i,'%02.0f')];%get(obj.h.text_figtag{i},'String');
    fighandle{i}  = obj.h.fighandle{i};
    figfile{i}    = [obj.path.report figtag{i} '.eps'];
    figcap{i}     = get(obj.h.text_figcap{i},'String');
end
% figure list
IDX = find(i_doexport);

if isempty(IDX)
    error('No figures to export to AutoReport. No report produced.')
end

% SAVE FIGURES
disp('save figures...')
for i=1:length(IDX)
    idx = IDX(i);
    
    if ~dokeeppaperpos
        % adjust paperposition to what you see
        pos = get(fighandle{idx},'Position');
        ratio = pos(4)/pos(3); % ratio = height/width
        ppcm = 30; % pixels per centimeter
        width = pos(3)/ppcm;
        paperpos =  [ 0 0 width width*ratio ];
        set(fighandle{idx},'PaperPosition',paperpos)
    end
    
    if dosetlinewidth
        axh = get(fighandle{idx},'Children');
        for j=1:length(axh)
            if strcmp(get(axh(j),'type'),'axes')
                lineh = get(axh(j),'Children');
                for k=1:length(lineh)
                    if strcmp(get(lineh(k),'type'),'line')
                        set(lineh(k),'Linewidth',linewidth);
                    end
                end
            end
        end
    end
    
    saveas(fighandle{idx},figfile{idx},'epsc')
end

TABLE = remove_empty_rows(get(obj.h.table_workspace,'Data'));

matrix2latexarray(TABLE,[obj.path.report 'temptable.txt']);
TABTEXT = fileread([obj.path.report 'temptable.txt']);
delete([obj.path.report 'temptable.txt']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEX FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TABCAPTION = 'Workspace variables';
TABLABEL   = 'workspace_variables';
TAB = texrep(obj.file.templ.table,'',{TABCAPTION,TABLABEL,TABTEXT});

% FIGURE TEXTS
FIGTEXT =[];
for i=1:length(IDX);
    idx = IDX(i);
    FLOATOPT = obj.def.float;
    FIGWIDTH = get(obj.h.text_figwidth{idx},'String');
    FIGFILE  = figfile{idx};
    FIGCAP   = strrep(figcap{idx},'_','\_');
    FIGLABEL = figtag{idx};
    figtexstring{i} = texrep(obj.file.templ.fig,'',{FLOATOPT,FIGWIDTH,FIGFILE,FIGCAP,FIGLABEL});
    FIGTEXT = [FIGTEXT figtexstring{i}];
end


% MAKE MAIN.TEX
mainfile    = [obj.path.report 'main.tex'];
TITLE       = strrep(get(obj.h.edit_reporttitle,'String'),'_','\_');
DATE        = datestr(now,'dd mmmm yyyy');
AUTHOR      = get(obj.h.edit_author,'String');
PWD         = obj.path.pwd;
CALLER      = obj.file.caller;
DESCRIPTION = get(obj.h.edit_description,'String');
sOut        = texrep(obj.file.templ.main,mainfile,{TITLE,AUTHOR,DATE,PWD,CALLER,TAB,DESCRIPTION,FIGTEXT});
disp('export done.')
winopen([obj.path.report 'main.tex']);


% OPEN .TEX
if doopen
    winopen([obj.path.report 'main.tex']);
end

% SAVE CURRENT BASE WORKSPACE IN REPORT FOLDER
if dosavews
    evalin('base',['save(''' obj.path.report 'BaseWorkspace.mat'')']);
end



end

function out = remove_empty_rows(in)
    out={};
    m=0;
    for i=1:size(in,1)
        if ~isempty(in{i,1})
            m=m+1;
            for j=1:size(in,2)
                out{m,j} = in{i,j};
            end
        end
    end
end
            


