%
% [ALPHA] = compute_alpha(SNAPSHOT)
%
% This function computes the thermal expansion coefficient from
% files of potential temperature THETA and salinity anomaly 
% SALTanom.
% SALTanom is by default a salinity anomaly vs 35PSU.
% If not, (is absolute value) set the global variable is_SALTanom to 0
%
% Files name are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_THETA>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_SALTanom>.<netcdf_domain>.<netcdf_suff>
% OUTPUT:
% ./netcdf-files/<SNAPSHOT>/ALPHA.<netcdf_domain>.<netcdf_suff>
%
% with: netcdf_* as global variables
%
% Alpha is computed with the subroutine sw_alpha from package SEAWATER
%
% 06/27/06
% gmaze@mit.edu

function varargout = compute_alpha(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_SALTanom netcdf_THETA
pv_checkpath


% Path and extension to find netcdf-files:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,netcdf_THETA,'.',netcdf_domain,'.',ext);
ncT     = netcdf(ferfile,'nowrite');
[Tlon Tlat Tdpt] = coordfromnc(ncT);

ferfile = strcat(pathname,sla,snapshot,sla,netcdf_SALTanom,'.',netcdf_domain,'.',ext);
ncS   = netcdf(ferfile,'nowrite');
[Slon Slat Sdpt] = coordfromnc(ncS); % but normaly is the same grid as T

% Salinity field ref;
global is_SALTanom
if exist('is_SALTanom')
  if is_SALTanom == 1
    bS = 35;
  else
    bS = 0;
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% surface PV flux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define axis:
nx = length(Tlon) ;
ny = length(Tlat) ;
nz = length(Tdpt) ;


% Pre-allocation:
if toshow,disp('Pre-allocate');end
ALPHA = zeros(nz,ny,nx).*NaN;

% Compute alpha:
for iz = 1 : nz
  if toshow,disp(strcat('Compute alpha for level:',num2str(iz),'/',num2str(nz)));end
  TEMP = ncT{4}(iz,:,:);
  SALT = ncS{4}(iz,:,:) + bS;
  PRES = (0.09998*9.81*Tdpt(iz))*ones(ny,nx);
  ALPHA(iz,:,:) = sw_alpha(SALT,TEMP,PRES,'ptmp');
end %for iz


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
netfil     = 'ALPHA';
units      = '1/K';
ncid       = 'ALPHA';
longname   = 'Thermal expansion coefficient';
uniquename = 'ALPHA';

% Open output file:
nc = netcdf(strcat(pathname,sla,snapshot,sla,netfil,'.',netcdf_domain,'.',ext),'clobber');

% Define axis:
nx = length(Tlon) ;
ny = length(Tlat) ;
nz = length(Tdpt) ;

nc('X') = nx;
nc('Y') = ny;
nc('Z') = nz;
 
nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = Tlon;
 
nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = Tlat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = Tdpt;
 
% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = ALPHA;

nc=close(nc);
close(ncS);
close(ncT);

% Output:
output = struct('ALPHA',ALPHA,'dpt',Tdpt,'lat',Tlat,'lon',Tlon);
switch nargout
 case 1
  varargout(1) = {output};
end
