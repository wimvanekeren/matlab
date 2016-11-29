function simres = runWimSim( mdl )
% simres = runWimSim( mdl ) performs simulink simulation with currently
% defined base/model workspace variables and extracts output signal data to
% struct that can be used by SimPlot
%
% this function is used by wimsim()
%
% Wim van Ekeren, 2016

if ~bdIsLoaded( mdl )
    load_system ( mdl );
end

[yout,tout,auxvars,status]  = runWimSim_internal( mdl );
simres                     = processWimSim(tout,yout,auxvars);


function [yout,tout,local_auxvars,local_status] = runWimSim_internal( mdl )

local_status=1;
try
    % the function sim() is used in this way to cope with the case when a
    % singularity/inf/nan causes an error in the simulation. In that case
    % it will still output all signals to the workspace, wherever sOut =
    % sim( mdl ) would not have yielded these variables.
    sim( mdl );
catch local_e
    warning('some error occured:');
    throw(local_e)
end

if ~exist('tout','var')
    error('No output time tout. Either an error occured, or tout is not set as output variable.')
end

if ~exist('yout','var')
    yout.signals = [];
end

% catch all "to workspace" signals that are outputted by the sim() command.
local_varnames = whos;
local_auxvars = struct;
for local_i=1:length(local_varnames)
    if ~any(strcmp(local_varnames(local_i).name,{'mdl','tout','yout','xout','local_i','local_varnames','local_e','local_status'}))
        local_auxvars.(local_varnames(local_i).name) = eval(local_varnames(local_i).name);
    end
end

function simres = processWimSim(tout,yout,auxvars)
% casts the simulation outputs from yout and auxvars to one single struct
% of arrays.
%
% yout:     simulation output, must be set to 'struct' in model
%           configuration parameters
% tout:     array with time values


% Write Simulation Outputs to sim_res
time = tout;

% Standard Output Signals xout,yout,tout
yout_names  = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ALL SIGNALS FROM yout TO sim_res
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(yout.signals)
    % loop over all output signals
    for i=1:length(yout.signals)
        
        % get signal name using regular expression
        name = regexp(yout.signals(i).blockName,['(?<=\w+/)(\w+)'],'match');
        
        if ~isempty(name)
            if ~isempty(name{1})
                
                % add name to yout_name list
                yout_names{end+1} = name{1};
                
                % add data to sim_res data
                simres.(yout_names{i}) = yout.signals(i).values;
            end
        else
            warning(['Output signal with blockName ' yout.signals(i).blockName ' could not be parsed.'])
        end
    end
end
simres.time        = time;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET ALL SIGNALS FROM auxvars TO sim_res
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extra output variables? 
ns=length(simres.time);

signames = fieldnames(auxvars);
for i=1:length(signames)
    thisname = signames{i};

    
    % does this variable name already exist?
    conflict = find(strcmp(thisname,yout_names));
    if conflict
        warning(['Simulation output variable ' thisname ' conflicts with yout signal ' yout_names{conflict} '. yout signal is kept.'])
    else
        % check what kind of variable you are
        VAR     = auxvars.(thisname);
        CLASS   = class(VAR);

        % get the variable values depending on how the auxvar is saved
        switch CLASS
            case 'timeseries'
                values = squeeze(VAR.Data);
            case 'double'
                values = squeeze(VAR);
            case 'struct'
                values = squeeze(VAR.signals.values);
            otherwise
                values = squeeze(VAR);
        end

        % check the number of samples in "values" and put the data in the
        % sim_res struct
        if size(values,1)~=ns && size(values,3) ~= ns
            % is the data transposed?
            if length(size(values))==2 && size(values,2)==ns
                simres.(thisname) = values';
            else
                % no dimension in "values" has the length that equals the
                % sample size
                simres.(thisname) = values;
                warning(['Number of samples in sim_res.' thisname ' does not correspond with sim_res.time.'])
            end
        else
            % number of samples is correct.
            simres.(thisname)=values;
        end

    end

end
