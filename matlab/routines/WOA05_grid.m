% WOA05_grid Read World Ocean Atlas 2005 grid
%
% [] = WOA05_grid(tp)
% 
% HELPTEXT
%
%
% Created: 2009-06-17.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = WOA05_grid(varargin)


pathi = abspath('~/data/WOA2005/netcdf/');
switch nargin
	case 0
		fil   = 'WOA05_THETA_0112an1.nc';		
	case 1
		switch lower(varargin{1})
			case '0112'
				fil   = 'WOA05_THETA_0112an1.nc';
			case '00'
				fil   = 'WOA05_THETA_00an1.nc';
		end
end	

nc = netcdf(strcat(pathi,fil),'nowrite');
t  = nc{'time'}(:);
z  = nc{'depth'}(:);
y  = nc{'lat'}(:);
x  = nc{'lon'}(:);
close(nc);

% I prefer z negative, downward
z = -z;

switch nargout
	case 1
		varargout(1) = {t};
	case 2
		varargout(1) = {t};
		varargout(2) = {z};
	case 3	
		varargout(1) = {t};
		varargout(2) = {z};
		varargout(3) = {y};
	case 4
		varargout(1) = {t};
		varargout(2) = {z};
		varargout(3) = {y};
		varargout(4) = {x};
end






end %function