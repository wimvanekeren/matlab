function setFontName(figh,FontName)

aa=findobj(gcf, '-depth', inf, '-property', 'FontName');
for j=1:length(aa)
    aa(j).FontName = FontName;
end
