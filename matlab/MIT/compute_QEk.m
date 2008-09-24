%
% [QEk] = compute_QEk(SNAPSHOT)
%
% Here we compute the lateral heat flux induced by Ekman currents
% from JFz, the PV flux induced by frictional forces:
% QEk = - Cw * EKL * JFz / alpha / f
% where:
%  Cw = 4187 J/kg/K is the specific heat of seawater
%  EKL is the Ekman layer depth (m)
%  JFz is the PV flux (kg/m3/s2)
%  alpha = 2.5*E-4 1/K is the thermal expansion coefficient
%  f = 2*OMEGA*sin(LAT) is the Coriolis parameter
%
% This allows a direct comparison with the net surface heat flux Qnet
% which forces the surface Pv flux due to diabatic processes.
%   
% Remind that:
% JFz = ( TAUx * dSIGMATHETA/dy - TAUy * dSIGMATHETA/dx ) / RHO / EKL
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_JFz>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_EKL>.<netcdf_domain>.<netcdf_suff>
% OUPUT:
% ./netcdf-files/<SNAPSHOT>/QEk.<netcdf_domain>.<netcdf_suff>
%
% with netcdf_* as global variables
%
% 06/27/06
% gmaze@mit.edu

function varargout = compute_QEk(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_JFz netcdf_EKL
pv_checkpath


% NETCDF file name:
filJFz  = netcdf_JFz;
filEKL  = netcdf_EKL;

% Path and extension to find them:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,filJFz,'.',netcdf_domain,'.',ext);
ncJFz   = netcdf(ferfile,'nowrite');
JFz     = ncJFz{4}(1,:,:);
[JFzlon JFzlat JFzdpt] = coordfromnc(ncJFz);

ferfile = strcat(pathname,sla,snapshot,sla,filEKL,'.',netcdf_domain,'.',ext);
ncEKL   = netcdf(ferfile,'nowrite');
EKL     = ncEKL{4}(1,:,:);
[EKLlon EKLlat EKLdpt] = coordfromnc(ncEKL);

% Make them having same limits:
% (JFz is defined with first/last points removed from the EKL grid)
nx = length(JFzlon) ;
ny = length(JFzlat) ;
nz = length(JFzdpt) ;
EKL = squeeze(EKL(2:ny+1,2:nx+1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dim:
if toshow, disp('dim'), end
nx = length(JFzlon) ;
ny = length(JFzlat) ;
nz = length(JFzdpt) ;

% Pre-allocate:
if toshow, disp('pre-allocate'), end
QEk = zeros(nz,ny,nx).*NaN;

% Planetary vorticity:
f = 2*(2*pi/86400)*sin(JFzlat*pi/180);
[a f]=meshgrid(JFzlon,f); clear a c

% Coefficient:
Cw = 4187;
al = 2.5*10^(-4); % Average surface value of alpha
coef = - Cw / al;

% Compute flux:
QEk = coef.* EKL .* JFz ./ f;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
netfil     = 'QEk';
units      = 'W/m2';
ncid       = 'QEk';
longname   = 'Lateral heat flux induced by Ekman currents';
uniquename = 'QEk';

% Open output file:
nc = netcdf(strcat(pathname,sla,snapshot,sla,netfil,'.',netcdf_domain,'.',ext),'clobber');

% Define axis:
nx = length(JFzlon) ;
ny = length(JFzlat) ;
nz = 1 ;

nc('X') = nx;
nc('Y') = ny;
nc('Z') = nz;
 
nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = JFzlon;
 
nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = JFzlat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = JFzdpt(1);
 
% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = QEk;

nc=close(nc);



% Output:
output = struct('QEk',QEk,'lat',JFzlat,'lon',JFzlon);
switch nargout
 case 1
  varargout(1) = {output};
end
