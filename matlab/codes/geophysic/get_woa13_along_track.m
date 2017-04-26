function varargout = get_woa13_along_track(varargin)
% get_woa13_along_track H1LINE
%
% [val z] = get_woa13_along_track(x,y,'VAR')
%
% Inteprolate WOA13 with Bi-linear interpolation at each depth level

% 	TIME SPAN:
% 5564:  1955 - 1964 (First decade with sufficient data for climatological mean fields)
% 6574:  1965 - 1974
% 7584:  1975 - 1984
% 8594:  1985 - 1994
% 95A4:  1995 - 2004
% A5B2:  2005 - 2012 (Global coverage of Argo floats from 2005)
% decav: 1955 - 2012 (Average of six decadal means)
% all:   All available yeasr

%
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire d'Océanographie Physique et Spatiale).
% Created: 2016-07-04 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire d'Océanographie Physique et Spatiale nor the names of its contributors may be used 
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

%- Init parameters
pathi = '~/data/WOA/2013/netcdf';

gr = '01'; % Grid resolution
%gr = '04'; % Grid resolution

tp = '00'; % Averaging period
%tp = '0112';

%- Load track:
X = convX(varargin{1},1);
Y = varargin{2};

%- Identify the Variable name:
V = lower(strtrim(varargin{3}));
switch V
	case {'temp','temperature','sea_water_temperature','theta'}
		ncvarname = 'sea_water_temperature';
		fname = 't';
		ts = 'decav'; % Time span		
	case {'psal','sal','salinity'}
		ncvarname = 'salinity';
		fname = 's';
		ts = 'decav'; % Time span
	case {'oxy','diox','oxyl','oxygen'}
		ncvarname = 'volume_fraction_of_oxygen_in_sea_water';
		fname = 'o';
		ts = 'all'; % Time span
end% switch 

%- Load which climatology to use:
% 'tp' is the averaging period
% 00 - annual statistics, all data used;
% 01 to 12 - monthly statistics (starting with 01 - January, to 12 - December); 
% 13 to 16 - seasonal statistics:
% 	Season 13 - North Hemisphere winter (January - March); 
% 	Season 14 - North Hemisphere spring (April - June);
% 	Season 15 - North Hemisphere summer (July - September); 
% 	Season 16 - North Hemisphere autumn (October - December);

%- Load axis:
[t,dpt,lat,lon] = get_WOA13grid(gr);
ndpt = length(dpt);
lon = convX(lon,1);

%- Load the appropriate 3D field
ncfile = sprintf('woa13_%s_%s%s_%s.nc',ts,fname,tp,gr);
if ~exist(fullfile(pathi,ncfile),'file')
	error(sprintf('I can''t find file with requested data (%s)',fullfile(pathi,ncfile)))
end% if 

ncid = netcdf.open(fullfile(pathi,ncfile),'NC_NOWRITE');
[LongName_list VarName_list VarID_list] = netcdf.listVarLongName(ncid);
[a incvar] = intersect(LongName_list,sprintf('Objectively analyzed mean fields for %s at standard depth levels.',ncvarname)); clear a
missval = netcdf.getAtt(ncid,VarID_list(incvar),'_FillValue');

%- Interpolate field along track
dx = 1;
dy = 1;

for ip = 1 : length(X)

	ix = find(lon>=X(ip)-dx&lon<=X(ip)+dx); nx = length(ix);
	iy = find(lat>=Y(ip)-dy&lat<=Y(ip)+dy); ny = length(iy);

	C = netcdf.getVar(ncid,VarID_list(incvar),[ix(1) iy(1) 1 1]-1,[nx ny ndpt 1]);   % lon / lat / dpt
	C = double(C);C(abs(C)>=missval) = NaN;	

	for iz=1:ndpt
		c(ip,iz) = bilini(lon(ix),lat(iy),squeeze(C(:,:,iz)),X(ip),Y(ip));		
	end% for iz
	
end% for ip
netcdf.close(ncid);

%- Output
varargout(1) = {c};
varargout(2) = {dpt};

end %functionget_woa13_along_track

function P = bilini(x,y,Q,xi,yi)
	% Bi-linear interpolation
	
	x1 = x(1); % west 
	y1 = y(1); % north
	x2 = x(2); % east
	y2 = y(2); % south
	Q11 = Q(1,1); % south/west
	Q12 = Q(1,2); % north/west
	Q21 = Q(2,1); % south/east
	Q22 = Q(2,2); % north/east
	
	R1 = ((x2 - xi)/(x2 - x1))*Q11 + ((xi - x1)/(x2 - x1))*Q21;
	R2 = ((x2 - xi)/(x2 - x1))*Q12 + ((xi - x1)/(x2 - x1))*Q22;
	P = ((y2 - yi)/(y2 - y1))*R1 + ((yi - y1)/(y2 - y1))*R2;
	
end% function

function varargout = get_WOA13grid(varargin)
% get_WOA13grid H1LINE
%
% [t,z,y,x] = get_WOA13grid(GR)
% 
% Load the WOA13 3D grid given a grid resolution
%
% [gr]-[grlong] represents the grid size, two digit code as follows: 
%	04 - 0.25 (quarter-degree grid resolution)
%	01 - 1.00 (one-degree grid resolution)
%	5d - 5.00 (five-degree grid resolution)

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
	otherwise
		error('Unknown resolution');
end% switch 


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
end% switch 

end %functionget_WOA13grid