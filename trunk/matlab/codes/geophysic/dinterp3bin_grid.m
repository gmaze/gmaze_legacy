% DINTERP3BIN_GRID Compute the new grid for DINTERP3BIN interpolated fields
%
% [xHR,yHR,zHR] = DINTERP3BIN_GRID(x,y,z,subdomain,Rfact)
%
% subdomain = [ix1 ix2 iy1 iy2 iz1 iz2] is the domain for which the new grid
% is computed. 
% x positive eastward
% y positive northward
% z<0, from top to bottom 
%
% Created by Guillaume Maze on 2008-10-28.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = dinterp3bin_grid(varargin)

lon = varargin{1};
lat = varargin{2};
dpt = varargin{3};
subdomain = varargin{4};
Rfact     = varargin{5};

lon_hr  = [lon(subdomain(1))-0.5+1/Rfact/2 : 1/Rfact : lon(subdomain(2))+0.5-1/Rfact/2];
lat_hr  = [lat(subdomain(3))-0.5+1/Rfact/2 : 1/Rfact : lat(subdomain(4))+0.5-1/Rfact/2];
dpt_hr  = interp1([subdomain(5)-1:subdomain(6)],dpt([subdomain(5):subdomain(6)+1]),[1:Rfact*(subdomain(6)-subdomain(5)+1)]/Rfact);


switch nargout
	case 1
		varargout(1) = {lon_hr};
	case 2
		varargout(1) = {lon_hr};
		varargout(2) = {lat_hr};
	case 3
		varargout(1) = {lon_hr};
		varargout(2) = {lat_hr};
		varargout(3) = {dpt_hr};	
end




