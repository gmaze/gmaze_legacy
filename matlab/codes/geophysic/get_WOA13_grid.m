% get_WOA13grid H1LINE
%
% [t,z,y,x] = get_WOA13grid(GR)
% 
% Load the WOA13 3D grid given a grid resolution
%
% [gr]-[grlong] represents the grid size, two digit code as follows: 
%	04 – 0.25 (quarter-degree grid resolution)
%	01 – 1.00 (one-degree grid resolution)
%	5d – 5.00 (five-degree grid resolution)
% 
% Created: 2014-10-09
% Copyright (c) 2014, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = get_WOA13grid(varargin)

pathi = abspath('~/data/WOA/2013/netcdf/');
switch nargin
	case 0
		gr = '01'; % (one-degree grid resolution)
	case 1
		gr = lower(varargin{1});
end% switch 
switch gr
	case {'04' '01'}
fil = sprintf('woa13_decav_t00_%s.nc',gr);

%
ncid = netcdf.open(strcat(pathi,fil),'NC_NOWRITE');		
t = double(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'time')))'; 
z = double(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'depth')))'; 
y = double(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'lat')))'; 
x = double(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'lon')))'; 
netcdf.close(ncid);

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

end %functionget_WOA13grid