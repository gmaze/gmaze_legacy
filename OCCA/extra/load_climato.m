%DEF
%REQ
%
% Created by Guillaume Maze on 2008-10-01.
% Copyright (c) 2008 Guillaume Maze. 
% http://www.guillaumemaze.org/codes

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% Load climatological fields and put them on the same grid
disp('Load climato ...');

pathclim = '~/data/OCCA/clim/';


fid  = fopen(strcat(pathclim,'DDtheta.0406clim.data'),'r','ieee-be');
fid2 = fopen(strcat(pathclim,'DKPPmld.0406clim.data'),'r','ieee-be');
fid3 = fopen(strcat(pathclim,'DDuvel.0406clim.data'),'r','ieee-be');
fid4 = fopen(strcat(pathclim,'DDvvel.0406clim.data'),'r','ieee-be');
fid5 = fopen(strcat(pathclim,'DDetan.0406clim.data'),'r','ieee-be');
fid6  = fopen(strcat(pathclim,'DDtheta.0406clim.data'),'r','ieee-be');



nlon = 360; nlat = 160; ndpt = 50; recl = 4*nlon*nlat; load('LSmask_MOA.mat');
axm = [1:12];
wm = [1:12]; % Which months to load ?
THETA = zeros(length(wm),ndpt,nlat,nlon);
SST = zeros(length(wm),nlat,nlon);
MLD   = zeros(length(wm),nlat,nlon);
UVEL  = zeros(length(wm),ndpt,nlat,nlon);
VVEL  = zeros(length(wm),ndpt,nlat,nlon);
ETA   = zeros(length(wm),nlat,nlon);
for im = 1 : length(wm)
  list = find(axm==wm(im));

	if 1
	  fseek(fid,(list-1)*recl*ndpt,'bof');
	  c = fread(fid,[nlon*nlat ndpt],'float32');
	  c = reshape(c,nlon,nlat,ndpt); c = permute(c,[3 2 1]);
	  THETA(im,:,:,:) = c.*LSmask3D;  
	end
	
	if 1
	  fseek(fid6,(list-1)*recl*ndpt,'bof');
	  c = fread(fid6,[nlon*nlat 1],'float32');
	  c = reshape(c,nlon,nlat); c = c';
	  SST(im,:,:) = c.*squeeze(LSmask3D(1,:,:));
	end
	
  fseek(fid2,(list-1)*recl,'bof');
  c = fread(fid2,[nlon nlat],'float32')';
  MLD(im,:,:) = c.*squeeze(LSmask3D(1,:,:));

	if 1
	  fseek(fid3,(list-1)*recl*ndpt,'bof');
	  c = fread(fid3,[nlon*nlat ndpt],'float32');
	  c = reshape(c,nlon,nlat,ndpt); c = permute(c,[3 2 1]);
	  UVEL(im,:,:,:) = c;

	  fseek(fid4,(list-1)*recl*ndpt,'bof');
	  c = fread(fid4,[nlon*nlat ndpt],'float32');
	  c = reshape(c,nlon,nlat,ndpt); c = permute(c,[3 2 1]);
	  VVEL(im,:,:,:) = c;
	end

	fseek(fid5,(list-1)*recl,'bof');
	c = fread(fid5,[nlon nlat],'float32')';
	ETA(im,:,:) = c.*squeeze(LSmask3D(1,:,:));

end

fclose('all'); clear fid c im
lon = LONmask; nlon = length(lon);
lat = LATmask; nlat = length(lat);
dpt = DPTmask; ndpt = length(dpt);

if 0
	THETA = squeeze(nanmean(THETA,1));
	mydomain=[1 25 90 135 130 180];
	THETA=THETA(mydomain(1):mydomain(2),mydomain(3):mydomain(4),mydomain(5):mydomain(6));
	SST = squeeze(THETA(1,:,:));
	% Move it to the good grid:
	T = zeros(jpj*nb_in,jpi*nb_in);
	for icur=1:nb_in
		for jcur=1:nb_in
			T(jcur:nb_in:jpj*nb_out,icur:nb_in:jpi*nb_out) = SST;
		end
	end
end


disp('done');


