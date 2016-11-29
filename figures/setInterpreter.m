function setInterpreter(figh,interpreter)

% set all interpreters to latex
ha=findobj(figh,'type','axes');

for i=1:length(ha);
    ha(i).TickLabelInterpreter  = interpreter;
    ha(i).Title.Interpreter     = interpreter;
    
    % labels
    if isprop(ha(i),'Xlabel')
        ha(i).XLabel.Interpreter    = interpreter;
    end
    
    if isprop(ha(i),'YLabel')
        ha(i).YLabel.Interpreter    = interpreter;
    end
    
    if isprop(ha(i),'ZLabel')
        ha(i).ZLabel.Interpreter    = interpreter;
    end    
    
end

aa=findobj(gcf, '-depth', inf, '-property', 'Interpreter');
for j=1:length(aa)
    aa(j).Interpreter = interpreter;
end
