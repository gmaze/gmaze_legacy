% get_occa_along_track H1LINE
%
% [] = get_occa_along_track()
% 
% HELPTEXT
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

function CC = get_occaclim_along_track(varargin)

X = varargin{1};
Y = varargin{2};
F = varargin{3}; F =list2cell(F); nf = length(F);
if nargin == 4
	M = varargin{4};
else
	M = 112;
end
if M == 112
	m = [1:12]; 
else
	m = M;
end

%%%%
l = load('LSmask_MOA','LONmask','LATmask');
lon = l.LONmask; nlon = length(lon);
lat = l.LATmask; nlat = length(lat);
clear l

for ic = 1 : nf
	for ii = 1 : length(m)
		c = load_climOCCA(F{ic},m(ii));
		for ipt = 1 : length(X)
			ilon = find(lon>=X(ipt),1); ilon = [max([1 ; ilon-1]) ilon min([nlon ; ilon+1])];
			ilat = find(lat>=Y(ipt),1); ilat = [max([1 ; ilat-1]) ilat min([nlat ; ilat+1])];
			[ax ay] = meshgrid(lon(ilon),lat(ilat));
			cf(ipt) = interp2(ax,ay,c(ilat,ilon),X(ipt),Y(ipt));
		end
		C(ii,:) = cf;
	end
	if M == 112
		CC(ic,:) = nanmean(C,1);
	else
		CC(ic,:,:) = C;
	end
end
if length(m) == 1 & nf == 1
	CC = squeeze(CC(:,1,:))';
elseif length(m) == 1 & nf ~= 1
	CC = squeeze(CC(:,1,:));	
end

end %functionget_occa_along_track

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function REQUIREDfields = list2cell(tline);

tl = strtrim(tline);
if strmatch(';',tl(end)), tl = tl(1:end-1);end
tl = [';' tl ';']; pv = strmatch(';',tl');
for ifield = 1 : length(pv)-1
field(ifield).name = tl(pv(ifield)+1:pv(ifield+1)-1);
end
REQUIREDfields = squeeze(struct2cell(field));


end%function






