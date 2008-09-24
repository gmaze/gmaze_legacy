% Here we define as global variables grids for u, v, theta and salt
% and also sub domain for the CLIMODE North Atlantic study


function grid_setup

global domain subdomain1 subdomain2 subdomain3 subdomain4


% Load grid

GRID_125

% Setup standard grid variables:

lon_salt=lon125;
lon_thet=lon125;
lon_u=[lon125(1)-360+lon125(end) (lon125(2:end)+lon125(1:end-1))/2];
lon_v=lon125;

lat_salt=lat125';
lat_thet=lat125';
lat_u=lat125';
lat_v=[lat125(1)-(lat125(2)-lat125(1))/2 (lat125(1:end-1)+lat125(2:end))/2]';

dpt_salt=dpt125;
dpt_thet=dpt125;
dpt_u=dpt125;
dpt_v=dpt125;
dpt_w=[0 cumsum(thk125(1:end-1))];


% Define the domain with structure:
domain = struct(...
                'SALTanom',struct('lon',lon_salt,'lat',lat_salt','dpt',dpt_salt),...
                'THETA',   struct('lon',lon_thet,'lat',lat_thet','dpt',dpt_thet),...
                'UVEL',   struct('lon',lon_u,'lat',lat_u','dpt',dpt_u),...
                'VVEL',   struct('lon',lon_v,'lat',lat_v','dpt',dpt_v),...
                'WVEL',   struct('lon',lon_salt,'lat',lat_salt','dpt',dpt_w)...
	        );



% And here we define the subdomain global structure containing 3D limits
% of the studied region, defined on the central grid.

sub_name='western_north_atlantic';
lonmin=lon125(2209); 
lonmax=lon125(2401); 
latmin=lat125(1225); 
latmax=lat125(1497); 
dptmin=dpt125(1);    
dptmax=dpt125(29);   

subdomain1=struct('name',sub_name,...
		 'limlon',[lonmin lonmax],...
		 'limlat',[latmin latmax],...
		 'limdpt',[dptmin dptmax]);


sub_name='climode';
lonmin=lon125(2312); % = 332E
lonmax=lon125(2384); % = 306E
latmin=lat125(1368); % = 27N
latmax=lat125(1414); % = 50N
dptmin=dpt125(1);    % = 5m
dptmax=dpt125(29);   % = 1105.9m

subdomain2=struct('name',sub_name,...
		 'limlon',[lonmin lonmax],...
		 'limlat',[latmin latmax],...
		 'limdpt',[dptmin dptmax]);


sub_name='north_atlantic';
lonmin=lon125(2209); 
lonmax=lon125(2880); 
latmin=lat125(1157); 
latmax=lat125(1564); 
dptmin=dpt125(1);    
dptmax=dpt125(29);   

subdomain3=struct('name',sub_name,...
                 'limlon',[lonmin lonmax],...
                 'limlat',[latmin latmax],...
                 'limdpt',[dptmin dptmax]);


sub_name='global';
lonmin=lon125(1); 
lonmax=lon125(2880); 
latmin=lat125(1); 
latmax=lat125(2176); 
dptmin=dpt125(1);    
dptmax=dpt125(29);   

subdomain4=struct('name',sub_name,...
                 'limlon',[lonmin lonmax],...
                 'limlat',[latmin latmax],...
                 'limdpt',[dptmin dptmax]);
