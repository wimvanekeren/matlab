function [north,east] = latlon2m(lat,lon,lat0,lon0)
% [north,east] = latlon2m(lat,lon)
% lat:      latitude [rad]
% lon:      longitude [rad]
% lat0:     gives position wrt this latitude
% lon0:     gives position wrt this latitude
% north:    north distance [m]
% east:     east distance [m]


if nargin==2
    lat0 = 0;
    lon0 = 0;
end

R0 = 6378e3;                                % radius earth
R1=R0*cos(lat(1));      % lateral radius at current latitude


north = lat * R0;
east = lon * R1;

north0 = lat0 * R0;
east0  = lon0 * R1;

north = north-north0;
east = east-east0;