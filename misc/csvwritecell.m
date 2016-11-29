function A_out = csvwritecell(filename,A,delimiter)
% A_out = csvwritecell(filename,A,delimiter)
% alternative of csvwrite, applied to cells
%
% Wim van Ekeren, 2016

if ~exist('delimiter','var')
    delimiter = ',';
end

nn = size(A);

fid=fopen(filename,'w');
    
% strings:
idx_string  = cellfun(@ischar,A);
idx_numeric = cellfun(@isnumeric,A);
idx_nan     = [[~idx_string].*[~idx_numeric]]==1;

% convert other classes to NaN
for i=[find(idx_nan)]'
    A{i} = num2str(nan);
end

% convert numeric to strings
for i=[find(idx_numeric)]'
    A{i} = num2str(A{i},'%g');
end



for irow=1:nn(1)
    fprintf(fid,['%s' delimiter],A{irow,1:nn(2)-1});
    fprintf(fid,'%s\n',A{irow,nn(2)});
end


fclose(fid);
A_out=A;
