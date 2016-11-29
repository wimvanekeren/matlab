function x=deal_n_out(thisfcn,n_out,varargin)
% x=deal_n_out(thisfcn,n_out,varargin)
% assigns the n-outputs of function @thisfcn with given inputs to the cell
% elements of x.
%
% this function is convenient if you programatically want a variable number
% of outputs
%
% example:
%   mat_size = [3 4]
%   idx      = 5
%   
%   subidx   = deal_n_out(@ind2sub,2,mat_size,idx)


x={};
str_out = ['['];
for i=1:n_out-1
    str_out = [str_out 'x{' num2str(i) '},'];
end
str_out = [ str_out 'x{' num2str(n_out) '}]'];


evalstr = [str_out '=thisfcn(varargin{:});'];
eval(evalstr);