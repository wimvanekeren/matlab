function setFontSize(figh,FontSize)

aa=findobj(gcf, '-depth', inf, '-property', 'FontSize');
for j=1:length(aa)
    aa(j).FontSize = FontSize;
end
