clear all
close all

% a={'a','b';'aasd sd sd','c'};
b=1;
c = {'cat','dog'};
figure('Name','Just a graph with some nonsense');
plot(1:10)
xlabel('random label')

figure('Name','Sine and Cosine graphs');
plot([sin(0:0.1:10)' cos(0:0.1:10)'])
xlabel('time [years]')
ylabel('distance [lightyears]')
% 
% import autoreport.*
dbclear all
% getTemplateProps('autoreport.figmanage_template')% gives errors while starting

mydef.figwidth          = '0.6';
mydef.ws_variables      = {'a';'b';'c';'ss';'';''};
mydef.author            = 'Wim van Ekeren';
mydef.reporttag_base    = 'bleport';
% mydef.path.save         = './';

autoreport.AutoReport