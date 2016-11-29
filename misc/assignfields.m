function assignfields(struct)
% Adds the fields of struct2 to struct1. If fieldnames are the same, fields
% of struct1 will be overwritten
%
% Wim van Ekeren, 2016

assert(isstruct(struct),'input 1 must be struct');

fn = fieldnames(struct);
for i=1:length(fn)
    assignin('caller',fn{i},struct.(fn{i}));
end
