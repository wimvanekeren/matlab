function sOut = texrep(filename_template,filename_out,fields)
% sOut = texrep(filename_template,filename_out,inputs)
% Fills the template in filename_template with strings from fields, at all
% places with <x>, in the order indicated by the number x in the template
% file.
%
% Inputs:
%   filename_template   Template filename with <> fields
%   filaneme_out        Output file generated. If empty string is given, no
%                       file is generated
%   fields              Cell of strings not greater than no. of <> fields
% Outputs:
%   sOut                Output file as a string
%
% Example: 
% if filename_template.tex equals:
% -------------
% blablabla input <1> and here comes another string: <2> balblabla
% -------------
% and if fields = {'chicken','dog'}
%
% then filename_out.tex equals:
% -------------
% blablabla input chicken and here comes another string: dog balblabla
% -------------
%
% Wim van Ekeren, 2015

sIn = fileread(filename_template);

% string replacements for latex symbols/escape characters
fields = strrep(fields,'\','\\');
sOut = sIn;

for i=1:length(fields)
    inString = fields{i};
    inTag    = ['<' num2str(i) '>'];
    
    sOut = regexprep(sOut,inTag,inString);
end

if ~isempty(filename_out)
    fid = fopen(filename_out,'w');
    fprintf(fid,'%s',sOut);
    fclose(fid);
end

