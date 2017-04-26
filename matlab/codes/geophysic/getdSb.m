function dS = getdSb(lat,lon,varargin)
% getdSb Compute centered surface elements from latitude/longitude axis
%
% dS = getdSb(lat,lon) Compute centered surface elements from 
% 	lat/lon axis using quadrangles.
%
% Inputs:
% 	with N the number of latitude, M the number of longitude:
% 	lat [1xN] or [MxN] is latitude axis
% 	lon [Mx1] or [MxN] is longitude axis (0-360 convention)
%
% Outputs:
% 	dS [MxN] are surface elements in m2
%
% Copyright (c) 2014, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2014-10-10 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%- Check inputs
[my ny] = size(lat);
if ny == 1
	error('lat must be [1xN] or [MxN]');
end% if 

[mx nx] = size(lon);
if mx == 1
	error('lon must be [Mx1] or [MxN]');
end% if 

if my == 1
	M = mx;
elseif mx ~= my
	error('lat and lon must have the same 1st dimension')
else
	M = mx;
end% if 

if nx == 1
	N = ny;
elseif nx ~= ny
	error('lat and lon must have the same 2nd dimension')
else
	N = ny;
end% if 

if find(lon<0)
	error('lon must be between 0 and 360')
end% if 

%- process inputs:
if my == 1
	lat = repmat(lat,[M 1]);
end% if 
if nx == 1
	lon = repmat(lon,[1 N]);
end% if 

%stophere
%- Compute surface elements:
dS = zeros(M,N).*NaN;
for ix = 1 : M
	for iy = 1 : N
		%-- Identify cell corners:
		xc = lon(ix,iy);
		yc = lat(ix,iy);
		if (ix==M)
			dx = diff(lon([ix-1,ix],iy));
		else
			dx = diff(lon([ix,ix+1],iy));
		end% if 
		x_east = mean([xc,xc+dx]);

		if (ix==1)
			dx = diff(lon([ix,ix+1],iy));
		else
			dx = diff(lon([ix-1,ix],iy));
		end% if 
		x_west = mean([xc,xc-dx]);
		
		if (iy==1)
			dy = diff(lat(ix,[iy,iy+1]),1,2);
		else
			dy = diff(lat(ix,[iy-1,iy]),1,2);
		end% if 
		y_south = mean([yc-dy,yc]);

		if (iy==N)
			dy = diff(lat(ix,[iy-1,iy]),1,2);
		else
			dy = diff(lat(ix,[iy,iy+1]),1,2);
		end% if 
		y_north = mean([yc,yc+dy]);
		
		%-- Compute surface of the cell:
		%[x_east,x_west,y_north,y_south]
		
  		% use the direct formulae
		cell_area = quadarea(x_east,x_west,y_north,y_south); % Surface in m^2

		% Fill in the array
		dS(ix,iy) = cell_area;

	end% for iy
end% for ix

end %functiongetdSb

function s = quadarea(x_east,x_west,y_north,y_south)
	R=6378137;
	unit='deg';	
	s = R^2*abs(x_east-x_west)*pi/180*(sin(y_north*pi/180)-sin(y_south*pi/180));	
end% function







