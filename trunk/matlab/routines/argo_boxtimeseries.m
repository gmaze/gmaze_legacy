% argo_boxtimeseries Average Argo profiles over a box
%
% [profiles,timeAX,presAX,ndata,raw_profiles] = argo_boxtimeseries(DOMAIN,PERIOD,[PRES_OUT,DT])
% 
% Average all available Argo profiles within the rectangular 
% box delimited by DOMAIN and give back the time serie for the time
% interval defined by PERIOD.
% 
% The rectangular box is given by DOMAIN, a 1x4 array:
% 	DOMAIN = [Xmin Xmax Ymin Ymax];
% where Xmin, Xmax are the Western and Eastern longitudes of the 
% box (from 0 to 360) and where Ymin, Ymax are the Southern
% and Northern latitudes of the box (from -90 to 90).
%
% The avalable time period goes from 2003/01/01 to the current date (as far as
% the Argo data are downloaded). PERIOD is 1x2 array like:
% 	PERIOD = [startnum endnum];
% where startnum, endnum are the starting and ending serial date
% numbers of the required time serie (as given by datenum, see
% example bellow).
%
% To allow average of several profiles, they are linearly
% inteprolated onto a regular vertical pressure axis.
% By default, this pressure axis is:
% 	PRES_OUT = 0:10:2500; % In db=hPa
% But it can also be specified in the argument list.
%
% DT is an optional parameter which sets the time interval of the output.
% It is a string which can be:
% 'd' (default), 'w' or 'm' for daily, weekly and monthly outputs.
% 
%
% EXAMPLE:
% 	PERIOD   = [datenum(2008,1,1,0,0,0) now];
% 	DOMAIN   = [360-55-10/2 360-55+10/2 35-5/2 35+5/2]; % For the North Atl. Eighteen Degree Water
% 	DOMAIN   = [360-55 360-50 55 60]; % For the Labrador Sea Water
% 	DOMAIN   = [360-31.5 360-27.5 55.5 59.5]; % For the Reykjanes Ridge Mode Sea Water
% 	[profiles timeax presax nprofiles] = argo_boxtimeseries(DOMAIN,PERIOD,0:20:1500,'w');
% 	figure;iw=2;jw=2;figure_land;
% 	subplot(iw,jw,1); hold on
%		m_proj('equid','lon',[360-80 359],'lat',[10 80]);
% 		m_drawbox([DOMAIN(1) DOMAIN(3)],[DOMAIN(2) DOMAIN(4)],'color','r');
%		m_coast('patch','k');m_grid;m_elev('contour',[-2 -1]*1e3,'edgecolor','k');
%	subplot(iw,jw,2); hold on
%	 	plot(PERIOD(1):PERIOD(2),nprofiles,'+');datetick('x','yyyy');set(gca,'xlim',PERIOD);
%		grid on;box on; xlabel('time'); title('Number of validated profiles');
%		set(gca,'xlim',PERIOD);
% 	subplot(iw,jw,3); hold on
% 		pcolor(timeax,-presax*1e4/1035/9.81,squeeze(profiles(1,:,:))');shading flat;colorbar;
% 		datetick('x','yyyy');set(gca,'xlim',PERIOD);box on
%		ylabel('Depth (m)'); xlabel('time'); title('Temperature');
% 	subplot(iw,jw,4); hold on
% 		pcolor(timeax,-presax*1e4/1035/9.81,squeeze(profiles(2,:,:))');shading flat;colorbar;
% 		datetick('x','yyyy');set(gca,'xlim',PERIOD);box on
%		ylabel('Depth (m)'); xlabel('time'); title('Salinity');
%
% NOTES: 
% 	- As of now, this function only works with the North Atlantic geographic
% 	domain as defined by Argo.
% 	- Argo data are supposed to be at:
% 	~/data/ARGO/ftp.ifremer.fr/ifremer/argo/geo/atlantic_ocean
%
% Created: 2009-06-03.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

% Rev. by Guillaume Maze on 2009-06-04: Add pres_out argument
%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% 
function varargout = argo_boxtimeseries(varargin)

global sla

domain = varargin{1};
period = varargin{2};
%year  = datestr(period,'yyyy');
%month = datestr(period,'mm');
%day   = datestr(period,'dd');
per   = period(1):period(2);
data_path = '~/data/ARGO/ftp.ifremer.fr/ifremer/argo/geo/atlantic_ocean';
data_path = abspath(data_path);

if nargin >= 3
	pres_out = varargin{3};
else
	pres_out = 0:10:2500;
end
nlevels  = length(pres_out);

if nargin == 4
	DT = varargin{4};
else
	DT = 'd';
end

if nargin == 5
	qc_level = varargin{5};
else
	qc_level = 1;
end

%%%%%%% Get the list of nc files and load profiles within the domain:
ii = 0;
blk = ' ';
h = waitbar(0,'Please wait...');
data  = zeros(3,length(per),nlevels)*NaN;
ndata = zeros(1,length(per)); 
%try 
	for id = 1 : length(per);
		%disp(['=> ' datestr(per(id))]);
		waitbar(id/length(per),h,sprintf('Scanning %s',datestr(per(id))));
		year  = str2num(datestr(per(id),'yyyy'));
		month = str2num(datestr(per(id),'mm'));
		day   = str2num(datestr(per(id),'dd'));
		file  = sprintf('%0.4i%s%0.2i%s%0.4i%0.2i%0.2i_prof.nc',year,sla,month,sla,year,month,day);
		file  = sprintf('%s%s%s',data_path,sla,file);
		if exist(file,'file')
			% Open the netcdf file with all the profiles of that day:
			nc = netcdf(file,'nowrite');
			% Select profiles within the domain:
			[ip x y] = argo_selectD(nc,domain);
			if ~isnan(ip)
				%disp(sprintf('%5s Found %i profile(s)',blk,length(ip)))
				%times = argo_date(nc,ip);
				dat   = argo_data(nc,ip,qc_level);
				if isstruct(dat)
					rawdata(id).val = dat;
					%disp(sprintf('%5s Found %i profile(s) OK',blk,size(rawdata(id).val,2)));
					ndata(id) = size(rawdata(id).val,2);
					% Now we take the average of all these profiles:
					data(1,id,:) = argo_avr(rawdata(id).val,pres_out,'TEMP');
					data(2,id,:) = argo_avr(rawdata(id).val,pres_out,'PSAL');
					data(3,id,:) = argo_avr(rawdata(id).val,pres_out,'DOXY');
				else
					%disp(sprintf('%5s None OK',blk));
					data(1,id,:) = NaN.*ones(1,length(pres_out));
					data(2,id,:) = NaN.*ones(1,length(pres_out));
					data(3,id,:) = NaN.*ones(1,length(pres_out));
				end
			else
				data(1,id,:) = NaN.*ones(1,length(pres_out));
				data(2,id,:) = NaN.*ones(1,length(pres_out));
				data(3,id,:) = NaN.*ones(1,length(pres_out));
				%disp(sprintf('%5s No profiles',blk));
			end%if we found profiles within the domain
			close(nc);clear nc
		else
			%disp('No files');
			data(1,id,:) = NaN.*ones(1,length(pres_out));
			data(2,id,:) = NaN.*ones(1,length(pres_out));
			data(3,id,:) = NaN.*ones(1,length(pres_out));
		end
	end%for id
	close(h);	
%catch
%	disp('Error !');
%	close(h);
%end
	

%%%%% Now we move to the timestep required:
if ~strcmp(DT,'d')
	[data per] = change_dt(data,per,DT);
end

%%%%% Now we remove time step with only NaNs:
idkeep = ones(length(per),size(data,3));
iv = 1;
for id = 1 : length(per);
	if length(find(isnan(squeeze(data(iv,id,:)))==1)) == size(data,3)
		idkeep(id,:) = 0;
	end
end%for id	
dat1 = data(1,:,:); dat1 = dat1(idkeep==1);
dat2 = data(2,:,:); dat2 = dat2(idkeep==1);
dat3 = data(3,:,:); dat3 = dat3(idkeep==1);
clear data
data(1,:,:) = reshape(dat1,[size(dat1,1)/nlevels nlevels]);
data(2,:,:) = reshape(dat2,[size(dat2,1)/nlevels nlevels]);
data(3,:,:) = reshape(dat3,[size(dat3,1)/nlevels nlevels]);
per  = per(idkeep(:,1)==1);


%%%%% OUTPUT:	
switch nargout
	case 1
		varargout(1) = {data};
	case 2
		varargout(1) = {data};
		varargout(2) = {per};
	case 3	
		varargout(1) = {data};
		varargout(2) = {per};
		varargout(3) = {pres_out};	
	case 4
		varargout(1) = {data};
		varargout(2) = {per};
		varargout(3) = {pres_out};
		varargout(4) = {ndata};			
	case 5
		varargout(1) = {data};
		varargout(2) = {per};
		varargout(3) = {pres_out};
		varargout(4) = {ndata};
		varargout(5) = {rawdata};			
end
	
end %function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%% 

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%
% Take the average of all the profiles by linear
% interpolation on the same vertical pressure grid
function data = argo_avr(rawdata,preso,VAR);
	switch VAR
		%%%%%%% %%%%%%%
		case 'TEMP'
			for ip = 1 : size(rawdata,2)
				presi = rawdata(ip).PRES;
				tempi = rawdata(ip).TEMP;
				presi(presi==99999) = NaN;
				tempi(tempi==99999) = NaN;
				tempi(presi>12e3) = NaN;   presi(presi>12e3) = NaN;
				tempi(presi<0)    = NaN;      presi(presi<0) = NaN;
				presi(tempi<-2)   = NaN;     tempi(tempi<-2) = NaN;
				presi(tempi>40)   = NaN;     tempi(tempi>40) = NaN;
				ii = ~isnan(presi) & ~isnan(tempi);
				if ~isempty(ii) 
					if length(ii) > 5
						presi = presi(ii);
						tempi = tempi(ii);
						data(ip,:) = interp1(presi,tempi,preso,'linear');
					else
						data(ip,:) = NaN.*ones(1,length(preso));
					end	
				else
					data(ip,:) = NaN.*ones(1,length(preso));
				end
			end	

		%%%%%%% %%%%%%%
		case 'PSAL'
			for ip = 1 : size(rawdata,2)
				presi = rawdata(ip).PRES;
				salti = rawdata(ip).PSAL;
				presi(presi==99999) = NaN;
				salti(salti==99999) = NaN;
				salti(presi>12e3) = NaN;   presi(presi>12e3) = NaN;
				salti(presi<0)    = NaN;      presi(presi<0) = NaN;
				presi(salti<0)    = NaN;     salti(salti<0)  = NaN;
				presi(salti>42)   = NaN;     salti(salti>42) = NaN;
				ii = ~isnan(presi) & ~isnan(salti);
				if ~isempty(ii) 
					if length(ii) > 2
						presi = presi(ii);
						salti = salti(ii);
						data(ip,:) = interp1(presi,salti,preso,'linear');
					else
						data(ip,:) = NaN.*ones(1,length(preso));
					end	
				else
					data(ip,:) = NaN.*ones(1,length(preso));
				end
			end	
	
		%%%%%%% %%%%%%%
		case 'DOXY'
			for ip = 1 : size(rawdata,2)
				presi = rawdata(ip).PRES;
				doxyi = rawdata(ip).DOXY;
				if length(doxyi) == 0
					data(ip,:) = NaN.*ones(1,length(preso));
				else
					presi(presi==99999) = NaN;
					doxyi(doxyi==99999) = NaN;
					doxyi(presi>12e3) = NaN;   presi(presi>12e3)  = NaN;
					doxyi(presi<0)    = NaN;      presi(presi<0)  = NaN;
					presi(doxyi<0)    = NaN;     doxyi(doxyi<0)   = NaN;
					presi(doxyi>650)  = NaN;     doxyi(doxyi>650) = NaN;
					ii = ~isnan(presi) + ~isnan(doxyi);
					ii = find(ii==2);
					if ~isempty(ii) 
						if length(ii) > 5
							presi = presi(ii);
							doxyi = doxyi(ii);
							data(ip,:) = interp1(presi,doxyi,preso,'linear');
						else
							data(ip,:) = NaN.*ones(1,length(preso));
						end	%if points ok
					else
						data(ip,:) = NaN.*ones(1,length(preso));
					end %if points
				end %if doxyi OK
			end	%for ip

		%%%%%%% %%%%%%%
	end %switch VAR
	if ~exist('data')
		data = NaN.*ones(1,length(preso));
	else
		data = nanmean(data,1);
	end
end%function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%
% Load profiles from netcdf files
function data = argo_data(cdf,ip,qc_level);
	ipok = 0;
	for ii = 1 : length(ip)
		iprof   = ip(ii);
		temp    = cdf{'TEMP'}(iprof,:);
		nlevels = size(temp,2);clear temp
		
		% Quality control:
		icok = argo_qc(cdf,iprof,nlevels,qc_level);

		% Load fields ok:
		if ~isempty(icok)
			ipok = ipok + 1;
			if 1
				% Pressure:
				data(ipok).PRES    = cdf{'PRES'}(iprof,icok);
				% Temperature:
				data(ipok).TEMP    = cdf{'TEMP'}(iprof,icok);
				% Salinity:
				data(ipok).PSAL    = cdf{'PSAL'}(iprof,icok);
				% Oxygen:
				data(ipok).DOXY    = cdf{'DOXY'}(iprof,icok);
			else
				% Pressure:
				data(ipok).PRES    = cdf{'PRES_ADJUSTED'}(iprof,icok);
				% Temperature:
				data(ipok).TEMP    = cdf{'TEMP_ADJUSTED'}(iprof,icok);
				% Salinity:
				data(ipok).PSAL    = cdf{'PSAL_ADJUSTED'}(iprof,icok);
			end
		end%if QC passed 		
	end%for iprof
	if ~exist('data')
		data = NaN;
	end	
end%function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%
% Quality control of each profiles
function icok = argo_qc(cdf,iprof,nlevels,qc_level);
	cok      = zeros(1,nlevels);		
	v1=double('1');
	v2=double('2');
	v5=double('5');
	PRES_QC  = double(cdf{'PRES_QC'}(iprof,1:nlevels));
	TEMP_QC  = double(cdf{'TEMP_QC'}(iprof,1:nlevels));
	PSAL_QC  = double(cdf{'PSAL_QC'}(iprof,1:nlevels));
	
%	qc_level = 1;
	switch qc_level
		case 1
			cok(   (TEMP_QC == v1 | TEMP_QC == v2 | TEMP_QC == v5) & ...
			       (PSAL_QC == v1 | PSAL_QC == v2 | PSAL_QC == v5) & ...
			 	   (PRES_QC == v1 | PRES_QC == v2 | PRES_QC == v5)) = 1;
		case 2
			cok(   (TEMP_QC == v1 | TEMP_QC == v2) & ...
			       (PSAL_QC == v1 | PSAL_QC == v2) & ...
			 	   (PRES_QC == v1 | PRES_QC == v2)) = 1;
		case 3
			cok(   (TEMP_QC == v1) & ...
			       (PSAL_QC == v1) & ...
			 	   (PRES_QC == v1)) = 1;
	end%switch
	icok = find(cok==1);
end%function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%
% Select profiles within the domain required
function [ip x y] = argo_selectD(cdf,domain);
	x = cdf{'LONGITUDE'}(:); 				   % Longitude from -180 to 180
	x(x>=-180 & x<0) = 360 + x(x>=-180 & x<0); % Move to longitude from 0 to 360
	y = cdf{'LATITUDE'}(:);
	ip = find(x>=domain(1) & x<=domain(2) & y>=domain(3) & y<=domain(4));
	if ~isempty(ip) % is longitude/latitude into the domain ?
		x = x(ip);
		y = y(ip);
	else
		ip = NaN;
		x  = NaN;
		y  = NaN;
	end%if long/lat ok
end%function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%
% Compute the absolute time of each profiles
function dat = argo_date(cdf,ip);
	REFERENCE_DATE_TIME = cdf{'REFERENCE_DATE_TIME'};
	ref = datenum(str2num(REFERENCE_DATE_TIME(1:4)),...
			str2num(REFERENCE_DATE_TIME(5:6)),...
			str2num(REFERENCE_DATE_TIME(7:8)),...
			str2num(REFERENCE_DATE_TIME(9:10)),...
			str2num(REFERENCE_DATE_TIME(11:12)),...
			str2num(REFERENCE_DATE_TIME(13:14)));
	for ii = 1 : length(ip)
		iprof   = ip(ii);
		dat(ii) = cdf{'JULD_LOCATION'}(iprof) + ref;
	end
end%function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%

%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%
% [data per] = change_dt(data,per,DT);
function [data per] = change_dt(C,t,dt)
	[nv nt nz] = size(C);
	for iv = 1 : nv
		switch dt
			case 'w'
				to = t(1):7:t(end);
				for it = 1 : length(to)-1
					ii = find(t>=to(it) & t<to(it+1));
					data(iv,it,:) = nanmean(C(iv,ii,:),2);
				end%for it
				ii = find(t>=to(it));
				data(iv,length(to),:) = nanmean(C(iv,ii,:),2);
			case 'm'
				ii = 0;
				for iy = str2num(datestr(t(1),'yyyy')) : str2num(datestr(t(end),'yyyy'))
					for im = 1 : 12
				    	ii = ii + 1;
				    	TI(ii,1:12) = sprintf('%0.4d%2.2d150000',iy,im);
					end, %for im
				end, clear ii iy im
				to = datenum(TI,'yyyymmddHHMM');
				for it = 1 : length(to)-1
					ii = find(t>=to(it) & t<to(it+1));
					data(iv,it,:) = nanmean(C(iv,ii,:),2);
				end%for it
				ii = find(t>=to(it));
				data(iv,length(to),:) = nanmean(C(iv,ii,:),2);
		end%switch
	end%for iv
	per = to;
	
end%function
%%%%%%% %%%%%%% %%%%%%% %%%%%%% %%%%%%%



