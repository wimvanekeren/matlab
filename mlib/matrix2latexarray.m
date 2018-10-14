function matrix2latexarray(matrix, filename, format, sparse)
% Usage:
% matrix2latexmatrix(matrix, filename, varargs)
% where
%   - matrix is a 2 dimensional numerical or cell array
%   - filename is a valid filename, in which the resulting latex code will
%   be stored
%   - sparse=1 will replace 0's by empty strings
%
% Wim van Ekeren, 2016

% default format
if ~exist('format','var')
    format = '%g'; 
end

if ~exist('sparse','var')
    sparse = 0;
end

fid = fopen(filename, 'w');


width = size(matrix, 2);
height = size(matrix, 1);

% If matrix, then convert to cell
if isnumeric(matrix)
    matrix = num2cell(matrix);
end
    

for h=1:height
    % Table cell 1 to n-1
    for w=1:width-1
        % if is numeric entry, then convert to string
        if isnumeric(matrix{h, w})
            if matrix{h, w}==0 && sparse
                matrix{h, w} = '';
            else
                matrix{h, w} = num2str(matrix{h, w},format);
            end
        end
        fprintf(fid, '%s&', matrix{h, w});
    end
    
    % Table cell n
    if isnumeric(matrix{h, width})
        if matrix{h, width}==0 && sparse
            matrix{h, width} = '';
        else
            matrix{h, width} = num2str(matrix{h, width},format);
        end
    end
    fprintf(fid, '%s\\\\\r\n', matrix{h, width});
end

fclose(fid);
    