function simres = wimsim(mdl,model_param,block_param)
% [sim_res,status,t] = wimsim(mdl,model_param,block_param)
% 
% performs simulink simulation and extracts output signal data to struct
% that can be used by SimPlot
%
% In Model Configuration Parameters, make sure to check outputting tout and
% yout as Structure. Check OFF to output simulation data as output object
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
% 24-11-2015, Wim van Ekeren, wimvanekeren@gmail.com

if ~exist('model_param','var')
    model_param = struct;
end

if ~exist('block_param','var')
    block_param = {};
end

% PREPARE
prepareWimSim(mdl,model_param,block_param)

% RUN SIMULATION
simres      = runWimSim( mdl );
