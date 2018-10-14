function fullfilename = get_user_file(frompath)
% fullfilename = get_user_file(frompath)
% Interactively choose file from a path (by number). Input path optional.
% Default path is current relative: './'

if nargin==0
    frompath = pwd;
end
options = ls(frompath);

for i=1:size(options,1)
    
    fprintf('%1.0f\t%s\n',i,options(i,:));
end

answer = input('Choose file by number: ','s');

if ~isnan(str2double(answer))
    n = str2double(answer);
else
    error('User input must be numeric.')
end


this_option = options(n,:);

file = remove_end_space(this_option);

fullfilename = fullfile(frompath,file);

function strOut = remove_end_space(strIn)

strOut = regexprep(strIn,'\s*\>','');
