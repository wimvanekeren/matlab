function export2base
w = evalin('caller','who');
n = length(w);
for i = 1:n
    assignin('base',w{i},evalin('caller',w{i}))
end