function [lat,lon] = m2latlon(north,east,lat0,lon0)
% [north,east] = latlon2m(lat,lon)
% lat:      latitude [rad]
% lon:      longitude [rad]
% north:    north distance [m]
% east:     east distance [m]

R0 = 6378e3;                                % radius earth
R1=R0*cos(lat0);      % lateral radius at current latitude

lat = lat0 + north/R0;
lon = lon0 + east/R1;
