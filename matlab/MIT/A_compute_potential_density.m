%
% [ST] = A_compute_potential_density(SNAPSHOT)
%
% For a time snapshot, this program computes the 
% 3D potential density from potential temperature and salinity.
% THETA and SALTanom are supposed to be defined on the same 
% domain and grid.
% SALTanom is by default a salinity anomaly vs 35.
% If not, (is absolute value) set the global variable is_SALTanom to 0
% 
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_THETA>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_SALTanom>.<netcdf_domain>.<netcdf_suff>
% OUPUT:
% ./netcdf-files/<SNAPSHOT>/SIGMATHETA.<netcdf_domain>.<netcdf_suff>
%
% 06/07/2006
% gmaze@mit.edu
%

  
function varargout = A_compute_potential_density(snapshot)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sla netcdf_THETA netcdf_SALTanom netcdf_domain netcdf_suff
pv_checkpath


%% THETA and SALTanom files name:
filTHETA = strcat(netcdf_THETA   ,'.',netcdf_domain);
filSALTa = strcat(netcdf_SALTanom,'.',netcdf_domain);

%% Path and extension to find them:
pathname = strcat('netcdf-files',sla,snapshot);
pathname = '.';
ext      = strcat('.',netcdf_suff);

%% Load netcdf files:
ferfile = strcat(pathname,sla,filTHETA,ext);
ncTHETA = netcdf(ferfile,'nowrite');
THETAvariables = var(ncTHETA);

ferfile = strcat(pathname,sla,filSALTa,ext);
ncSALTa = netcdf(ferfile,'nowrite');
SALTavariables = var(ncSALTa);

global is_SALTanom
if exist('is_SALTanom')
  if is_SALTanom == 1
    bS = 35;
  else
    bS = 0;
  end
end


%% Gridding:
% Don't care about the grid here !
% SALTanom and THETA are normaly defined on the same grid
% So we compute sigma_theta on it.

%% Flags:
global toshow % Turn to 1 to follow the computing process


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Now we compute potential density
%% The routine used is densjmd95.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Axis (usual netcdf files):
if toshow,disp('Dim');end
[lon lat dpt] = coordfromnc(ncTHETA);
nx = length(lon);
ny = length(lat);
nz = length(dpt);

% Pre-allocate:
if toshow,disp('Pre-allocate');end
SIGMATHETA = zeros(nz,ny,nx);

% Then compute potential density SIGMATHETA:
for iz = 1 : nz
  if toshow,disp(strcat('Compute potential density at level:',num2str(iz),'/',num2str(nz)));end
  
  S = SALTavariables{4}(iz,:,:) + bS; % Evantualy move the anom to an absolute field
  T = THETAvariables{4}(iz,:,:);
  SIGMATHETA(iz,:,:) = densjmd95(S,T,zeros(ny,nx)) - 1000;
   
  % Eventualy make a plot of the field:
  if 1 %& iz==1
    clf;pcolor(squeeze(SIGMATHETA(iz,:,:)));
    shading interp;caxis([20 30]);colorbar
    drawnow
    %M(iz)=getframe; % To make a video
  end %if1
end %for iz




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Record output:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% General informations: 
netfil     = strcat('SIGMATHETA','.',netcdf_domain,'.',netcdf_suff);
units      = 'kg/m^3-1000';
ncid       = 'ST';
longname   = 'Potential Density';
uniquename = 'potential_density';

% Open output file:
nc = netcdf(strcat(pathname,sla,netfil),'clobber');

% Define axis:
nc('X') = nx;
nc('Y') = ny;
nc('Z') = nz;

nc{'X'} = 'X';
nc{'Y'} = 'Y';
nc{'Z'} = 'Z';

nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = lon;

nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = lat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = dpt;

% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = SIGMATHETA;

nc=close(nc);
close(ncTHETA);
close(ncSALTa);

% Outputs:
output = struct('SIGMATHETA',SIGMATHETA,'dpt',dpt,'lat',lat,'lon',lon);
switch nargout
 case 1
  varargout(1) = {output};
end
