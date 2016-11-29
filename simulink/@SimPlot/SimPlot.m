classdef SimPlot < handle
    
    properties
        m_n_ax = {};
        m_n_fig = 0;
        m_method = 'subplot';
        m_nx = {};
        m_ny = {};
        m_n_stream;
        
        % handle data
        fig = {};
        ax = {};
        pt = {};
        
        m_signals;
        m_LineWidth = 1;
        m_Marker = 'none';
        m_LineStyle = {'-','--','-.',':','-' ,'-','-' ,'-'}
        m_i_plot = 1;       % current plot ax iterator
        m_list = {};
        m_deflist = struct('i_fig',1,'factor',1,'tag',' ','showname',1,'showlegend',1,'leglocation','NorthEast','allowgather',1);
        m_i_ax_cur = {1, 1, 1, 1, 1, 1, 1, 1, 1};
        
        doseparatewindows   = 0;
        fontsize            = 10;
        paperwidth          = 20;
        do_R2015            = 0;
        
    end
    
    
    methods 
        
        function obj = SimPlot(signals,list,prop)
            
            if doplot

                % set matlab version
                vers = version('-release');
                if str2double(vers(1:4)) >= 2015
                    obj.do_R2015 = 1;
                else
                    obj.do_R2015 = 0;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % set properties
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if exist('prop','var');
                    fn = fieldnames(prop);
                    for i=1:length(fn)
                        propname = [fn{i}];
                        obj.(propname) = prop.(fn{i});
                    end
                end

                

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % set simulation streams to object
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                obj.addsignals(signals);         

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % set lists to object
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                obj.addtolist(list);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % create figures, calculate maximum axes, subplot setups
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % max figures;
                for i=1:length(obj.m_list)
                    obj.m_n_fig = max(obj.m_n_fig,obj.m_list{i}.i_fig);
                end                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % make figure;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                
                for j=1:obj.m_n_fig
                    obj.m_n_ax{j} = 0;

                    for i=1:length(obj.m_list)
                        if obj.m_list{i}.i_fig==j
                            obj.m_n_ax{j} = max(obj.m_n_ax{j},obj.m_list{i}.i_ax);
                        end
                    end

                    % set nx, ny
                    if obj.m_n_ax{j} <= 5
                        obj.m_nx{j} = 1;
                        obj.m_ny{j} = obj.m_n_ax{j};
                    elseif obj.m_n_ax{j} <= 10;
                        obj.m_nx{j} = 2;
                        obj.m_ny{j} = ceil(obj.m_n_ax{j}/obj.m_nx{j});
                    else
                        obj.m_nx{j} = 3;
                        obj.m_ny{j} = ceil(obj.m_n_ax{j}/obj.m_nx{j});
                    end

                    for i_fig=1:obj.m_n_fig
                        obj.makefig(i_fig,obj.m_nx{j},obj.m_ny{j});                 
                    end           
                    
                    
%                     % set figure position
%                     obj.setfigpos(j,obj.m_nx{j},obj.m_ny{j})
                end



                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % plot list
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for i=1:length(obj.m_list)
                    obj.addplot(i);  
                end

                % update figure titles
                for i=1:length(obj.fig)
                    obj.setfigtitle(i);
                end
                
                for i_fig = 1:length(obj.fig)
                    % ability to double click on axes objects:
                    addDoubleClickZoom(obj.fig{i_fig}.f);
                    
                    fh(i_fig)=obj.fig{i_fig}.f;
                end
                % set all axes objects in plotted figure same width:
%                 equalAxes(fh);
                
                
            else
                if dowarn
                    warning('Base workspace variable doPlot is set to 0. Figures are suppressed. Set doPlot=1 in base workspace to plot figures.')
                end
            end
                
        end
        
        
        function makefig(obj,i_fig,nx,ny)
            
            assert( ~obj.existfig(i_fig) , 'Figure does already exist' );
            
            
          
            % figure position
            posnew(3) = 700*nx + 80;
            posnew(4) = 210*ny;
            posnew(1) = 50;
            posnew(2) = 50;
            
            % paper position
            papwidth    = obj.paperwidth;
            papheight   = posnew(4)*papwidth/posnew(3);
            pappos      = [0 20 papwidth papheight];            
            
            
            obj.fig{i_fig}      = struct;
            obj.fig{i_fig}.f    = figure('position',posnew,'paperposition',pappos);
            obj.ax{i_fig}       = {};
            obj.pt{i_fig}       = {};
        end
        
        function plotsub(obj,i_list)
            % plot single list element in specific subplot
            
            list = obj.m_list{i_list};
          
            assert( list.isplotted == 0 , 'List item has already been plotted.' )
            % indices
            i_ax    = list.i_ax;
            i_fig   = list.i_fig;
            
            
            ax = obj.getax( i_fig , i_ax );
            
            
            % plot the list object in the specific fig and ax
            obj.plotsingle( i_fig , i_ax , list );
            
            % update axes settings
            if list.showlegend
                legend( ax , obj.ax{i_fig}{i_ax}.l ,'Location', list.leglocation,'FontSize',obj.fontsize-2,'Interpreter','none');
            end
            
            % reset ylim if too large
            if any(abs(axis(ax)) > 1e12)
                ylim(ax,[-10 10]);
            end
            
            % delete action lines
            for i=1:length(obj.ax{i_fig}{i_ax}.ptaction)
                delete(obj.ax{i_fig}{i_ax}.ptaction{i})
            end
            obj.ax{i_fig}{i_ax}.ptaction = {};
            
            % plot action lines
            for i=1:length(obj.m_signals{1}.action)
                
                actionx = [obj.m_signals{1}.action(i) obj.m_signals{1}.action(i)];
                limits = axis( ax );
                actiony = limits([3 4]);
                obj.ax{i_fig}{i_ax}.ptaction{i} = plot(actionx,actiony,'r-','Linewidth',1,'HandleVisibility','off');
            end
            
            if isfield(list,'ylabel')
                ylabel( ax , list.ylabel , 'fontsize', obj.fontsize)
                obj.ax{i_fig}{i_ax}.ylabel = list.ylabel;
            end
            
            if isfield(list,'title')
                title( ax , list.title , 'fontsize' , obj.fontsize)
            end
            
            % set plot styles for all streams ..?;
            for j=1:length(obj.pt{i_fig}{i_ax})
                
                
                p = obj.pt{i_fig}{i_ax}{j}.p;                
                
                if iscell(obj.m_LineWidth)
                    LineWidth = obj.m_LineWidth{j};
                else
                    LineWidth = obj.m_LineWidth;
                end
                
                if iscell(obj.m_LineStyle)
                    LineStyle = obj.m_LineStyle{j};
                else
                    LineStyle = obj.m_LineStyle;
                end
                
                if iscell(obj.m_Marker)
                    Marker = obj.m_Marker{j};
                else
                    Marker = obj.m_Marker;
                end
                
                set( p      ,'LineWidth',LineWidth ,...
                             'LineStyle',LineStyle ,...
                             'Marker',Marker);
            end
            
            
        end
        
        function ax = getax(obj,i_fig,i_ax)
            % Returns axes handle. If the axes don't exist yet, it will
            % create it. If the figure does not exist yet, it will create
            % it
            
            % make/prepare axes
            assert( i_ax <= obj.m_nx{i_fig}*obj.m_ny{i_fig} , 'Cannot plot extra axes, out of range' )

            % make figure if it does not exist yet
            if ~obj.existfig(i_fig)
                obj.makefig(i_fig);
            end
            
            if ~obj.existax(i_fig,i_ax)
                obj.makeax(i_fig,i_ax);
            end
            
            ax = obj.ax{i_fig}{i_ax}.a;
        end
        
        function ax = makeax(obj,i_fig,i_ax)
            % create axes if it does not exist yet
            assert( ~obj.existax(i_fig,i_ax) , 'Axes does already exist' );
                
            SUBPLOTIDX = zeros(obj.m_nx{i_fig},obj.m_ny{i_fig});
            n = obj.m_ny{i_fig}*obj.m_nx{i_fig};
            SUBPLOTIDX(:) = 1:n;
            SUBPLOTIDX = SUBPLOTIDX';
            
            figure(obj.fig{i_fig}.f);
            ax = subplot(obj.m_ny{i_fig},obj.m_nx{i_fig},SUBPLOTIDX(i_ax),'fontsize',obj.fontsize);
            
            obj.ax{i_fig}{i_ax}.a = ax;
            obj.ax{i_fig}{i_ax}.l = {};     % legend labels
            obj.pt{i_fig}{i_ax} = {};
            obj.ax{i_fig}{i_ax}.ylabel = '';
            obj.ax{i_fig}{i_ax}.signames = {};
            obj.ax{i_fig}{i_ax}.ptaction = {};
            
            % set axes styles
            hold  ( ax , 'on' );
            xlabel( ax , 'time [s]' , 'FontSize', obj.fontsize);
            grid  ( ax , 'on' )       

            

        end
        
        function r = existax(obj,i_fig,i_ax)
            r = 1;
            if ~obj.existfig(i_fig)
                r = 0;
            elseif length(obj.ax{i_fig}) < i_ax;
                r = 0;
            elseif isempty(obj.ax{i_fig}{i_ax})
                r = 0;
            end
        end
        
        function r = existfig(obj,i_fig)
            r = 1;
            if length(obj.fig) < i_fig;
                r = 0;
            elseif isempty(obj.fig{i_fig})
                r = 0;
            end
        end
        
        function plotsingle(obj,i_fig,i_ax,list)
            i_ps    = length(obj.pt{i_fig}{i_ax})+1;  % new plot stream
            ax      = obj.ax{i_fig}{i_ax}.a;          % axes handle
            cmap    = colormap(ax,'Lines');
            
            % initialize plot stream
            obj.pt{i_fig}{i_ax}{i_ps}.x = [];
            obj.pt{i_fig}{i_ax}{i_ps}.y = []; 
            obj.pt{i_fig}{i_ax}{i_ps}.p = [];            
            
            n_stream = length(list.i_stream);
            for j=1:n_stream
                i_ss    = list.i_stream(j);     % current sig stream
                               
                x = obj.m_signals{j}.time;     
                y = [];
                % iterate over signals in list
                for k=1:length(list.signals)
                    if isfield(obj.m_signals{i_ss},list.signals{k})
                        y = [y list.factor(k)*obj.m_signals{i_ss}.(list.signals{k})(:,list.icol{k})];
                    else
                        y = [y nan(length(x),list.icol{k})];
                        warning(['Signal data has no field named' list.signals{k} '.'])
                    end
                    
                end
                
                % update legend list
                thislabel = {};
                for m=1:length(list.name)
                    
                    showname = list.showname;
                    if size(y,2)==1
%                         showname=0;
                    end
                    
                    showtag = list.showtag;
                    if n_stream==1
%                         showtag=0;
                    end
                    
                    if showname && showtag
                        thislabel{m} = [list.name{m} ' ' obj.m_signals{i_ss}.tag];
                    elseif showname
                        thislabel{m} = [list.name{m}];
                    elseif showtag
                        thislabel{m} = [obj.m_signals{i_ss}.tag];
                    end
                end
                
                obj.ax{i_fig}{i_ax}.l       = { obj.ax{i_fig}{i_ax}.l{:} thislabel{:} };
                
                
                % plot new stream data
                % augment to the previous plotstream if the signal has size 1
                if size(y,2)==1 
                    if n_stream > 1 
                        if list.allowgather && length(obj.pt{i_fig}{i_ax}) >= i_ps
                            if length(obj.pt{i_fig}{i_ax}{i_ps}.x)==length(x)
                                % augment to last plotstream
                                obj.pt{i_fig}{i_ax}{i_ps}.x          = x;
                                obj.pt{i_fig}{i_ax}{i_ps}.y(:,end+1) = y;                    
                                obj.pt{i_fig}{i_ax}{i_ps}.p(end+1)   = plot(ax,x,y,'Color',cmap(j,:));                                
                                
                            else
                                % make new plotstream
                                obj.pt{i_fig}{i_ax}{i_ps} = {};
                                obj.pt{i_fig}{i_ax}{i_ps}.x = x;
                                obj.pt{i_fig}{i_ax}{i_ps}.y = y; 
                                if obj.do_R2015
                                    set(obj.ax{i_fig}{i_ax}.a,'ColorOrderIndex',1);
                                end
                                obj.pt{i_fig}{i_ax}{i_ps}.p = plot(ax,x,y);
                                i_ps                        = i_ps+1;               % current plot stream   
                                

                            end
                        else
                            % make new plotstream
                            obj.pt{i_fig}{i_ax}{i_ps} = {};
                            obj.pt{i_fig}{i_ax}{i_ps}.x = x;
                            obj.pt{i_fig}{i_ax}{i_ps}.y = y; 
                            
                            if obj.do_R2015
                                set(obj.ax{i_fig}{i_ax}.a,'ColorOrderIndex',1);
                            end                              
                            obj.pt{i_fig}{i_ax}{i_ps}.p = plot(ax,x,y);
                            i_ps                        = i_ps+1;               % current plot stream    
                          
                            
                        end
                    elseif n_stream == 1
                        % one signal, size 1, so plot as black
%                         obj.pt{i_fig}{i_ax}{i_ps}.x          = x;
%                         obj.pt{i_fig}{i_ax}{i_ps}.y(:,end+1) = y;                    
                        obj.pt{i_fig}{i_ax}{i_ps}.p(end+1)   = plot(ax,x,y,'Color',[0 0 0]);
                    end
                else
                    % make new plotstream
                    obj.pt{i_fig}{i_ax}{i_ps} = {};
                    obj.pt{i_fig}{i_ax}{i_ps}.x = x;
                    obj.pt{i_fig}{i_ax}{i_ps}.y = y; 
                    
                    if obj.do_R2015
                        set(obj.ax{i_fig}{i_ax}.a,'ColorOrderIndex',1);
                    end                    
                    
                    obj.pt{i_fig}{i_ax}{i_ps}.p = plot(ax,x,y);
                    i_ps                        = i_ps+1;               % current plot stream                          
                end
            end
            
            obj.ax{i_fig}{i_ax}.signames = unique({obj.ax{i_fig}{i_ax}.signames{:},list.signals{:}});
            
        end
        
        
        function replot(obj,i_fig,i_ax,i_ps)
            
            if isempty(obj.pt{i_fig}{i_ax}{i_ps})
                warning('Plotstream empty. Nothing to replot')
            else
                delete(obj.pt{i_fig}{i_ax}{i_ps}.p)
                ax = obj.ax{i_fig}{i_ax}.a;
                x  = obj.pt{i_fig}{i_ax}{i_ps}.x;
                y  = obj.pt{i_fig}{i_ax}{i_ps}.y;
                obj.pt{i_fig}{i_ax}{i_ps}.p = plot(ax,x,y);
            end
        end
        
        function addplot(obj,i_list)
            % adds the stream(s) in list to the SimPlot object
            
            for i=1:length(i_list)
                j = i_list(i);
                obj.plotsub(j);
                obj.m_list{j}.isplotted = 1;
            end             
        end
            
        
        function setfigpos(obj,i_fig,nx,ny)
            pos    = get(obj.fig{i_fig}.f,'Position');
            
            posnew=pos;
            
            % figure position
            posnew(3) = 700*nx + 80;
            posnew(4) = 210*ny;
            posnew(1) = 50;
            posnew(2) = 50;
            
            % paper position
            papwidth    = obj.paperwidth;
            papheight   = posnew(4)*papwidth/posnew(3);
            pappos      = [0 0 papwidth papheight];
            
            set(obj.fig{i_fig}.f,'Position',posnew);
            set(obj.fig{i_fig}.f,'PaperPosition',pappos);
        end
        
        function wider(obj,i_fig)
            
            if ~exist('i_fig','var')
                i_fig = 1;
            end
            pos = get(obj.fig{i_fig}.f,'Position');
            pos(3) = 1.5*pos(3);
            pos(4) = pos(4);
            set(obj.fig{i_fig}.f,'Position',pos);

        end
        
        
        function higher(obj,i_fig)
            
            if ~exist('i_fig','var')
                i_fig = 1;
            end
            pos = get(obj.fig{i_fig}.f,'Position');
            pos(3) = pos(3);
            pos(4) = 1.5*pos(4);
            set(obj.fig{i_fig}.f,'Position',pos);

        end        
        
        function close(obj,i_fig)
            
            if ~exist('i_fig','var')
                i_fig = 1;
            end
            
            close(obj.fig{i_fig}.f);
            
            obj.fig{i_fig} = {};
            obj.ax{i_fig} = {};
            obj.pt{i_fig} = {};
            
        end
            
        function addsignals(obj,signals)
            
            if isstruct(signals)
                signals = {signals};
            end
            
            % squeeze signals
            signals_new = {};
            m=0;
            for i=1:length(signals)
                if ~isempty(signals{i})
                    m=m+1;
                    signals_new{m} = signals{i};
                end
            end
            
            assert(m>0,'No simulation results found in first input. Input empty.')
            
            signals = signals_new;
            
            
            for j=1:length(signals)
                if ~isfield(signals{j},'tag')
                    signals{j}.tag = num2str(j);
                end
                
                if ~isfield(signals{j},'action')
                    signals{j}.action = [];
                end

                        
                
            end
            
            obj.m_signals   = signals;
            obj.m_n_stream  = length(signals);           
            
            % look for "constants" in signal list and make a vector of
            % length samples
            specialfields={'tag','action'};
            
            
            
            for j=1:length(signals)
                nS = length(obj.m_signals{j}.time);
                fn = fieldnames(signals{j});
                for i=1:length(fn)
                    if ~any(strcmp(fn{i},specialfields))
                        if size(signals{j}.(fn{i}),1)==1 % only 1 sample means it is a constant
                            obj.m_signals{j}.(fn{i}) = repmat(obj.m_signals{j}.(fn{i}),nS,1);
                        end
                    end
                end
            end
            
                
        end
        
        function obj = setfigtitle(obj,i_fig)
            
            titlelist = {};
            for i=1:length(obj.ax{i_fig})
                titlelist = unique({titlelist{:},obj.ax{i_fig}{i}.signames{:}});
            end
            
            thistitle = titlelist{1};
            if length(titlelist) > 1
                for i=2:length(titlelist)
                    thistitle = [thistitle ', ' titlelist{i}];
                end
            end
            
            obj.fig{i_fig}.title = thistitle;
            set(obj.fig{i_fig}.f,'Name',thistitle);
            
        end
                
        
        function addtolist(obj,list)
            % add list struct to obj.m_list
            
            if ~iscell(list)
                list = {list};
            end
            
            for i=1:length(list)
                
%                 try
                
                    if ~isempty(list{i})
                        

                        
                        
                        % figure
                        if ~isfield(list{i},'i_fig')
                            list{i}.i_fig = obj.m_deflist.i_fig;
                        end

                        
                        % axes
                        if ~isfield(list{i},'i_ax')
                            list{i}.i_ax = obj.m_i_ax_cur{list{i}.i_fig};
                            obj.m_i_ax_cur{list{i}.i_fig} = obj.m_i_ax_cur{list{i}.i_fig} + 1;
                        elseif list{i}.i_ax > obj.m_i_ax_cur{list{i}.i_fig}
                            obj.m_i_ax_cur{list{i}.i_fig} = list{i}.i_ax + 1;
                        end

                        

                                        
                        
                        % streams indices
                        if ~isfield(list{i},'i_stream')
                            list{i}.i_stream = 1:obj.m_n_stream;
                        end

                        % does the signal exist?
                        for m=1:length(obj.m_signals)
                            for k=1:length(list{i}.signals)
                                if ~isfield(obj.m_signals{m},list{i}.signals{k})
                                    % does not exist, give warning
                                    warning(['Warning: signal ' list{i}.signals{k} ' does not exist. NaNs will be plotted instead.'])

                                    % make list of NaNs
                                    nsamp = length(obj.m_signals{m}.time);

                                    obj.m_signals{m}.(list{i}.signals{k}) = nan(nsamp,1);

                                end
                            end
                        end
                        
                        % icol
                        if ~isfield(list{i},'icol')
                            list{i}.icol = cell(1,length(list{i}.signals));
                        end
                        if isempty(list{i}.icol)
                            list{i}.icol = cell(1,length(list{i}.signals));
                        end

                        for j=1:length(list{i}.signals)

                            if length(list{i}.icol) < j
                                list{i}.icol{j} = {};
                            end

                            if isempty(list{i}.icol{j})
                                list{i}.icol{j} = 1:size(obj.m_signals{1}.(list{i}.signals{j}),2);
                            end
                            
                            % extend NaNs if icol refers to colums that do
                            % not exist.
                            for m=1:length(obj.m_signals)
                                for k=1:length(list{i}.icol{j})
                                    if list{i}.icol{j}(k) > size(obj.m_signals{m}.(list{i}.signals{j}),2)
        %                               keyboard
                                        nsamp = length(obj.m_signals{m}.time);

                                        obj.m_signals{m}.(list{i}.signals{j})(1:nsamp,list{i}.icol{j}(k)) = nan(nsamp,1);

                                    end
                                end
                            end
                               
                        end

                        % names (legend names)
                        if ~isfield(list{i},'name')
                            list{i}.name = {};
                            for k=1:length(list{i}.signals)
                                name = list{i}.signals{k};
                                for j=list{i}.icol{k}
                                    list{i}.name{end+1} = [name num2str(j)];
                                end
                            end
                            
%                         elseif length(list{i}.name) == length(list{i}.signals)
%                             keyboard
%                             newname = {};
%                             for k=1:length(list{i}.signals)
%                                 name = list{i}.name{k};
%                                 for j=1:length(list{i}.icol{k});
%                                     newname{end+1} = [name num2str(list{i}.icol{k}(j))];
%                                 end
%                             end
%                             list{i}.name = newname;
                        end

                        % showtag: default: do show if there are multiple
                        % streams plotted
                        if ~isfield(list{i},'showtag')
                            if length(list{i}.i_stream)>1
                                list{i}.showtag = 1;
                            else
                                list{i}.showtag = 0;
                            end
                        end


                        % not plotted yet
                        list{i}.isplotted = 0;

                        % set other defaults
                        fn=  fieldnames(obj.m_deflist);
                        for j=1:length(fn)
                            if ~isfield(list{i},fn{j});
                                list{i}.(fn{j}) = obj.m_deflist.(fn{j});
                            end
                        end


                        assert(isnumeric(list{i}.factor),'Field factor must be numeric')
                            
                        
                        % vectorise factor field if necessary
                        if length(list{i}.factor)==1 && length(list{i}.signals) > 1
                            list{i}.factor = repmat(list{i}.factor,[1 length(list{i}.signals)]);
                        end                   
                        
                        


                        % add to object list
                        obj.m_list{end+1} = list{i};
                    end
%                 catch e
%                     warning(['Error while interpreting list item ' num2str(i) '.'])
%                     throw(e)
%                 end

            end
            
            if obj.doseparatewindows
                for i=1:length(obj.m_list)
                    obj.m_list{i}.i_fig = obj.m_list{i}.i_ax;
                    obj.m_list{i}.i_ax  = 1;
                end
            end
            
        end
            
        
    end
    
end
    