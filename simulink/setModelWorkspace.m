function mdlWorkspace = setModelWorkspace(mdl,model_param)
% mdlWorkspace = setModelWorkspace(mdl,model_param)
% sets variables in model workspace from fields of model_param structure
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
% Wim van Ekeren, 2016


if ~bdIsLoaded( mdl )
    load_system ( mdl );
end


mdlWorkspace = get_param(mdl,'modelworkspace') ;
fn = fieldnames(model_param);
for i=1:length(fn)
    mdlWorkspace.assignin(fn{i},model_param.(fn{i}));
end