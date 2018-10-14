function sOut = regexprep_file(filename_in,filename_out,expression,replace)
% sOut = regexprep_file(filename_in,filename_out,expression,replace)
%
% Wim van Ekeren, 2015

sIn  = fileread(filename_in);
sOut = sIn;
sOut = regexprep(sOut,expression,replace);

if ~isempty(filename_out)
    fid = fopen(filename_out,'w');
    fprintf(fid,'%s',sOut);
    fclose(fid);
end

