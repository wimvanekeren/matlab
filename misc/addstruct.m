function structOut = addstruct(structBase,structAdd,options)
% Adds the fields of struct2 to struct1. If fieldnames are the same, fields
% of struct1 will be overwritten
%
% options:  'overload' --> only overload fields, gives error when field does
%               not exist in struct1
%           'merge'    --> only merge structs, gives error when field DOES
%               already exist in struct1
%           'normal'   --> no errors; overload if field already exist, create
%               field if it does not exist
% 
% Wim van Ekeren, 2016

if nargin==2
    options = '';
end

assert(isstruct(structBase),'input 1 must be struct');
assert(isstruct(structAdd),'input 2 must be struct');

structOut=structBase;
fn = fieldnames(structAdd);
for i=1:length(fn)
    nm=fn{i};
    
    
    ISF = isfield(structBase,nm) ;
    switch options
        case 'overload'
            if ~ISF
                error(['Field ' fn{i} ' does not exist in input 1 (structBase). Consider choosing option ''merge'' or ''normal'''])
            end
        case 'merge'
            if ISF
                error(['Field ' fn{i} ' alread exists in input 1 (structBase). Consider choosing option ''overload'' or ''normal'''])
            end
        case 'normal'
    end
    
    structOut.(nm) = structAdd.(nm);
end
