% get_ovide_track Load OVIDE track
%
% [lat,lon,dist] = get_ovide_track()
% 
% Load the OVIDE track (lat,lon) of all stations and their distances to Cape Farewell, Greenland
%
% Created: 2010-03-02.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
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
%

function varargout = get_ovide_track(varargin)

if nargin == 0
	year = '06';
else
	year = varargin{1};
end

nc = netcdf(abspath(sprintf('~/data/OVIDE/data/ovid%2s_dep.nc',year)),'nowrite');
x = nc{'LONGITUDE_BEGIN'}(:,:);
x(x>=-180 & x<0) = 360 + x(x>=-180 & x<0); x=x'; % Move to longitude from 0 to 360
y = nc{'LATITUDE_BEGIN'}(:,:); y = y';
close(nc);

D = dfromo(x,y);

switch nargout
	case 1
		varargout(1) = {y};
	case 2
		varargout(1) = {y};
		varargout(2) = {x};
	case 3
		varargout(1) = {y};
		varargout(2) = {x};
		varargout(3) = {D};
end

end %functionget_ovide_track



function D = dfromo(x,y);
	
	O = [317.5 59.8];

	if length(x) ~= length(y)
		error('Latitude and Longitude must be of same dimensions')
	end

	for is = 1 : length(x)
		D(is) = m_lldist([O(1) x(is)],[O(2) y(is)])/1e3;
	end

end%function












