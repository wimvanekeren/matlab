function mdlWorkspace = clearModelWorkspace(mdl)
% mdlWorkspace = clearModelWorkspace(mdl)
%
% simply clears model workspace
%
% Wim van Ekeren, 2016

if ~bdIsLoaded( mdl )
    load_system ( mdl );
end

mdlWorkspace = get_param(mdl,'modelworkspace') ;
mdlWorkspace.clear;