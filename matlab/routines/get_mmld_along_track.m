% get_mmld_along_track Get Boyer-Montegut MLD climatology along a track
%
% H = get_mmld_along_track(x,y,[M])
% 
% Compute the MLD from the de Boyer Montegut Argo monthly climatology along a set of stations.
%
% Inputs:
%	x,y: longitude,latitude coordinates of the stations
%	M: from 1 to 12 for a single month or 112 for the annual mean
%
% Outputs:
%	H: Mixed Layer Depth
%
% Created: 2010-02-23.
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

function MLD = get_mmld_along_track(varargin)

X = varargin{1};
Y = varargin{2};
if nargin == 3
	M = varargin{3};
else
	M = 112;
end	
if M == 112
	m = [1:12]; 
else
	m = M;
end


%%%%
ncfile = abspath('~/data/MONTEGUT_MLD/netcdf/mldT02_sk.nc');
nc     = netcdf(ncfile,'nowrite');
lon    = nc{'lon'}(:); nlon = length(lon);
lat    = nc{'lat'}(:); nlat = length(lat);

%%%%
for ipt = 1 : length(X)
	ilon = find(lon>=X(ipt),1); ilon = [max([1 ; ilon-1]) ilon min([nlon ; ilon+1])];
	ilat = find(lat>=Y(ipt),1); ilat = [max([1 ; ilat-1]) ilat min([nlat ; ilat+1])];
	[ax ay] = meshgrid(lon(ilon),lat(ilat));
	
	for ii = 1 : length(m)
		mld = nc{'mld'}(m(ii),ilat,ilon);
		mld(mld<=-9999) = NaN; mld(mld==1e9) = NaN;
		H(ii) = interp2(ax,ay,mld,X(ipt),Y(ipt));
	end
	MLD(:,ipt) = H;
end
close(nc);

if M == 112
	MLD = nanmean(MLD,2);
end



end %functionget_mmld_along_track












