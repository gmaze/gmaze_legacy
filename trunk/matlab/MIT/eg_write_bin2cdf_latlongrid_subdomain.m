%  Script to extract and write in netCDF format a subdomain
%  from the 1.8 global run 
%
clear
global sla
pv_checkpath

% Load grid
GRID_125

% Load list of all outputs
otab = latlon8grid_outputs_table;

% Setup standard grid variables
lon_c = lon125;
lon_u = [lon125(1)-360+lon125(end) (lon125(2:end)+lon125(1:end-1))/2];
lat_c = lat125;
lat_v = [lat125(1)-(lat125(2)-lat125(1))/2 (lat125(1:end-1)+lat125(2:end))/2];
z_c = (cumsum(thk125)-thk125/2);
z_w = [0 cumsum(thk125(1:end-1))];


% Set subrange - Longitude given as degrees east
subdomain = 4;

switch subdomain
  case 1
sub_name = 'western_north_atlantic';
lonmin = lon125(2209)-180;
lonmax = lon125(2497-1)-180; 
latmin = lat125(1225); 
latmax = lat125(1497-1); 
depmin = min(z_w); 
depmax = z_c(29);
m_proj('mercator','long',[270 365],'lat',[0 60]);
%clf;hold on;m_coast;m_grid;
LIMITS = [lonmin+180 lonmax+180 latmin latmax depmin depmax]
%m_line(LIMITS([1 2 2 1 1]),LIMITS([3 3 4 4 3]),'color','r','linewidth',2);
%title(sub_name);

  case 3
sub_name = 'north_atlantic';
lonmin = lon125(2209)-180;
lonmax = lon125(2881-1)-180; 
latmin = lat125(1157); 
latmax = lat125(1565-1); 
depmin = min(z_w);
depmax = z_c(29);
m_proj('mercator','long',[270 365],'lat',[0 60]);
clf;hold on;m_coast;m_grid;
LIMITS = [lonmin+180 lonmax+180 latmin latmax depmin depmax]
m_line(LIMITS([1 2 2 1 1]),LIMITS([3 3 4 4 3]),'color','k','linewidth',2);
title(sub_name);

  case 4
sub_name = 'global';
lonmin = lon125(1)-180;
lonmax = lon125(2881-1)-180; 
latmin = lat125(1); 
latmax = lat125(2177-1); 
depmin = min(z_w);
depmax = z_c(29); depmax = z_w(2);
m_proj('mercator','long',[0 360],'lat',[-90 90]);
clf;hold on;m_coast;m_grid;
LIMITS = [lonmin+180 lonmax+180 latmin latmax depmin depmax]
m_line(LIMITS([1 2 2 1 1]),LIMITS([3 3 4 4 3]),'color','k','linewidth',2);
title(sub_name);


  case 10
sub_name = 'KE';
lonmin = lon125(961)-180;
lonmax = lon125(1601-1)-180; 
latmin = lat125(1140); 
latmax = lat125(1523-1); 
depmin = min(z_w);
depmax = z_c(25);
m_proj('mercator','long',[0 360],'lat',[-90 90]);
%clf;hold on;m_coast;m_grid;
LIMITS = [lonmin+180 lonmax+180 latmin latmax depmin depmax]
%m_line(LIMITS([1 2 2 1 1]),LIMITS([3 3 4 4 3]),'color','k','linewidth',2);
%title(sub_name);


end

%refresh

% Path of the directory to find input binary files:
pathi = 'ecco2_cycle1_bin/';

% Path where the netcdf outputs will be stored:
patho = './ecco2_cycle1_netcdf/monthly/';
%patho = './ecco2_cycle1_netcdf/six_hourly/';

% Variables to analyse (index into otab):
wvar = [];
% 3D fields:
wvar = [wvar 34]; % THETA
wvar = [wvar 35]; % THETASQ
%wvar = [wvar 33]; % SALTanom
%wvar = [wvar 47]; % VVEL
%wvar = [wvar 31]; % RHOAnoma



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : length(wvar)
 ifield = wvar(i);
 fil = otab{ifield,1};
 l = dir(strcat(pathi,fil,sla));
 if ifield == 33, 
   l = dir(strcat(pathi,'SALT',sla));
 end
 if ifield == 35, 
   l = dir(strcat(pathi,'THETA',sla));
 end
 if ifield == 31, 
   l = dir(strcat(pathi,'RHO',sla));
 end
 it = 0;
 clear ll
 for il = 1 : size(l,1)
   if ~l(il).isdir & findstr(l(il).name,strcat(fil,'.')) % is'it the file type we want ?
     it = it + 1;
     ll(it).name = l(il).name;
   end %if
 end %for il
 
 if it ~= 0 % if we found any files to compute:
   
 % Create the timetable:
 for il = 1 : size(ll,2)
   filinprog = ll(il).name;
   stepnum=str2num(filinprog(findstr(filinprog,fil)+length(fil)+1:length(filinprog)- ...
			   length('.data')));
   TIME(il,:) = dtecco2(stepnum,0);
 end
   
 % Translate files:
 for il = 1 : size(ll,2)
 
 filinprog = ll(il).name;
 stepnum=str2num(filinprog(findstr(filinprog,fil)+length(fil)+1:length(filinprog)- ...
			   length('.data')));
 ID = datenum(1992,1,1)+stepnum*300/60/60/24;
 dte = datestr(ID,'yyyymmddHHMM');
 disp(strcat(fil,'->',datestr(ID,'yyyy/mm/dd/HH:MM'),'== Recorded in ==>',TIME(il,:)));
 dirout = strcat(patho,sla,TIME(il,:));
 
 if 1 % Want to record ?
 if ~exist(dirout,'dir')
     mkdir(dirout);
 end
 pathname = strcat(pathi,fil,sla);
 if ifield == 33, 
   pathname = strcat(pathi,'SALT',sla);
 end
 if ifield == 35, 
   pathname = strcat(pathi,'THETA',sla);
 end
 if ifield == 31, 
   pathname = strcat(pathi,'RHO',sla);
 end
 if ~exist(strcat(dirout,sla,sprintf('%s.%s.nc',otab{ifield,1},sub_name)),'file')
 %if 1
 latlon2ingrid_netcdf(pathname,strcat(dirout,sla),...
		    stepnum,otab{ifield,1},otab, ...
                    lon_c, lon_u,              ...
                    lat_c, lat_v,              ...
                    z_c, z_w,                  ...
                    sub_name,                  ...
                    lonmin,lonmax,latmin,latmax,depmin,depmax);
 else 
   disp(strcat('##### Skip file (already done):',dirout,sla,...
	       sprintf('%s.%s.nc',otab{ifield,1},sub_name)))
 end %if %file exist
 
 end %if 1/0 want to record ?
% if il==1,break,end;
 
  fclose('all');
  
 end %for il
 
 end %if it
 
end %for i
