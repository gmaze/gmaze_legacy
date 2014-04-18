% distsphere Compute the angle between two points on the sphere 
%
% ALPHA = DISTSPHERE(LON1,LAT1,LON2,LAT2,[FLAG])
% 
% Compute the angle ALPHA on the sphere between two points given
% by (LON1,LAT1) and (LON2,LAT2).
% If FLAG = 0, angles are in radian (default)
% If FLAG = 1, angles are in degree,
%
% Created by Guillaume Maze on 2013-09-05
% Based on script from Guillaume Roullet.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function arc = distsphere(lon1,lat1,lon2,lat2,flag)

if nargin==4
  flag=0;
end

if flag==1 % angles in degrees
  lon1=lon1*pi/180;
  lon2=lon2*pi/180;
  lat1=lat1*pi/180;  
  lat2=lat2*pi/180;  
end

dlon=lon1-lon2;
dlat=lat1-lat2;

z = sin(dlat*.5).^2 + cos(lat1).*cos(lat2).*sin(dlon*.5).^2.;

arc = 2*asin( sqrt( z ) );

%d2 = sqrt( dlat.^2 + dlon.^2);

if flag==1
  arc=arc*180/pi;
%  d2=d2*180/pi;
end

