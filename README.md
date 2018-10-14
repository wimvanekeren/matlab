This is  my library of personal matlab functions I built up over the years

It's really a rough collection of functions and some classes by which I tried to make my life with matlab easier. Many of the functions can probably be found elsewhere with a much better implementation, and some may be even similar to matlab's built-in functions. 

Some parts use code from others; in this case, references are provided in the comments.

It is organized in the following folders:

mautoreport
-----------------------
Contains the module AutoReport, which can generate latex-reports with your open figures and workspace variables in it. Can for example be helpful if you quickly want to wrap up your results in a presentable way for a meeting with your professor.

mfigures
-----------------------
Utility functions for figures.

mlib
-----------------------
Library of general utility functions

msignals
-----------------------
Library of utility functions to analyse signals and systems

@SimPlot
-----------------------
Class definition for easy plotting of simulation results. Works conveniently with outputs from wimsim

wimsim
-----------------------
A Simulink wrapper to simulate your model in a scoped way, with an easy implementation to set your own parameters. Just call wimsim(). Especially usefull if you want to perform series of simulations with multiple parameters. Disclaimer: this is probably not optimized for computation time.