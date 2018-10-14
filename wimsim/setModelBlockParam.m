function setModelBlockParam(mdl,block_param)
% setModelBlockParam(mdl,block_param)
%
% INPUTS
%   mdl
%       Simulink model name
%
%   block_param     cell-struct
%       .BlockName  block name (relative to mdl)
%       .Param      block parameter
%       .Value      block parameter value
%
%       Block parameters are set using:
%       set_param('<mdl>/<BlockName>',<Param>,<Value>)
%
% Wim van Ekeren, 2016

if ~bdIsLoaded( mdl )
    load_system ( mdl );
end
% Set Block Parameters
for i=1:length(block_param)
    set_param([mdl '/' block_param{i}.BlockName ],block_param{i}.Param,block_param{i}.Value);
end
