function assignfields(struct)
% assignfields(struct)
% Assigns all the fields of in struct in the workspace which the
% function is called from

assert(isstruct(struct),'input 1 must be struct');

fn = fieldnames(struct);
for i=1:length(fn)
    assignin('caller',fn{i},struct.(fn{i}));
end
