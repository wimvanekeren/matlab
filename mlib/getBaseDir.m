function basepath= getBaseDir(dirname)
% gets the full pathname to the directory dirname. <dirname> should be a
% directory higher up in the present working directory:
%
% basepath = regexp(pwd,['[\w\\:]*\\' dirname '\\'],'match');
%
% Wim van Ekeren, 2016

basepathcell = regexp(pwd,['[\w\\:]*\\' dirname ],'match');

if isempty(basepathcell)
    if strcmp('dirname','OpenFlight')
        basepath = 'C:\Users\Wim\Dropbox\MasterThesis\Programming\FASER\OpenFlight\';
    else
        error('DLR:getBaseDir:BadPath','Directory not found in present working directory');
    end
else
    basepath = [basepathcell{1} '\'];
end