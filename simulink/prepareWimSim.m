function [] = prepareWimSim(mdl,model_param,block_param)
% prepareWimSim(mdl,model_param,block_param)
% 
% prepares wimsim-simulation:
% - set model workspace parameters
% - check simulation parameters
% - set block parameters
%
% this function is used by wimsim()
% 
% INPUTS
%   mdl
%       Simulink model name
% 
%   model_param     struct
%       Model parameters are set in the model workspace, using:
%       modelworkspace = get_param(<mdl>,'modelworkspace') ;
%       modelworkspace.assignin(<model param fieldname>,model_param.<fieldname>);
%
%   block_param     cell-struct
%       .BlockName  block name (relative to mdl)
%       .Param      block parameter
%       .Value      block parameter value
%
%       Block parameters are set using:
%       set_param('<mdl>/<BlockName>',<Param>,<Value>)
% 
% OUTPUTS:
%   sim_res         simulation results
%       .time       
%       .<signals>
%
% make sure in Configuration Parameters -> Data import/export that the
% parameter "Save simulation output as single object" has been switched
% off.
%
% Wim van Ekeren, 2016 
% wimvanekeren@gmail.com

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('model_param','var')
    model_param = struct;
end

if ~exist('block_param','var')
    block_param = {};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Default and Standard Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~bdIsLoaded( mdl )
    load_system ( mdl );
end

% prepare model parameters
if strcmp(get_param(mdl,'LimitDataPoints'),'on')
    set_param(mdl, 'LimitDataPoints','off')
    warning(['LimitDataPoints for ' mdl ' has been switched OFF.'])
end

if strcmp(get_param(mdl,'SaveFormat'),'Array')
    set_param(mdl,'SaveFormat','StructureWithTime')
    warning(['Saving format in ' mdl ' for output variables was set to Array, but is incompatible. Save format has been set to Structure with time.']);
end

if strcmp(get_param(mdl,'SaveOutput'),'off')
    set_param(mdl,'SaveOutput','on')
    warning(['Saving output in ' mdl ' was switched off but must be switched on. It has been set accordingly.']);
end

if ~strcmp(get_param(mdl,'OutputSaveName'),'yout')
    set_param(mdl,'OutputSaveName','yout')
    warning(['Output save name of ' mdl ' must be yout. It has been set accordingly.']);
end

if strcmp(get_param(mdl,'SaveTime'),'off')
    set_param(mdl,'SaveTime','on')
    warning(['Saving time in ' mdl ' was switched off but must be switched on. It has been set accordingly.']);
end

if ~strcmp(get_param(mdl,'TimeSaveName'),'tout')
    set_param(mdl,'TimeSaveName','tout')
    warning(['Time save name of ' mdl ' must be tout. It has been set accordingly.']);
end


% set model_param in model workspace
clearModelWorkspace(mdl);
setModelWorkspace(mdl,model_param);
setModelBlockParam(mdl,block_param);