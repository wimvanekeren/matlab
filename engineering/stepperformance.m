function [t_rise,t_set,has_settled] = stepperformance(y,t,t0,f_rise,f_set,f_setmax,doplot)
% calculates rise time and settling time

% f_set  = abs(y_set-y_final)/(y_final-y_first)
% f_rise = (f_rise-y_first)/(y_final-y_first)


y_first = y(1);
y_final = y(end);

do_reverse=0;
if y_final < y_first
    % reverse y
    y=-y;
    y_first = -y_first;
    y_final = -y_final;    
    do_reverse=1;
end

delta_y = y_final-y_first;

y_rise = y_first + f_rise*delta_y;
dy_set = f_set*delta_y;


i_rise  = find(y > y_rise,1,'first');
t_rise  = t(i_rise)-t0;

i_set = find(abs(y-y_final) > dy_set,1,'last');
t_set = t(i_set)-t0;


has_settled=1;
if (t0+t_set)/t(end) > f_setmax
    has_settled = 0;
end

if doplot
    if do_reverse
        plotresp(t,-y,t0,t_rise,t_set,dy_set,-y_rise,-y_final)
    else
        plotresp(t,y,t0,t_rise,t_set,dy_set,y_rise,y_final)
    end
end

function plotresp(t,y,t0,tr,ts,dy_set,y_rise,y_final)

figure;
plot(t,y)
hold on

ylimits = ylim(gca);
xlimits = xlim(gca);


plot(t0+[tr tr],[ylimits],'k-')
plot(t0+[ts ts],[ylimits],'r-')
legend('y','rise','set')
plot(xlimits,y_final+[dy_set dy_set],'r--')
plot(xlimits,y_final+[-dy_set -dy_set],'r--')
plot(xlimits,[y_rise y_rise],'k--')

