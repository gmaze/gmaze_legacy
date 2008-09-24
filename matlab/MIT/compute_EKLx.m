%
% [EKL] = compute_EKLx(SNAPSHOT)
%
% Here we compute the Ekman Layer Depth as:
% EKL = 0.7 sqrt( TAUx/RHO )/f 
%
% where:
%  TAUx is the amplitude of the zonal surface wind-stress (N/m2)
%  RHO is the density of seawater (kg/m3)
%  f is the Coriolis parameter (kg/m3)
%  EKL is the Ekman layer depth (m)
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_RHO>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_TAUX>.<netcdf_domain>.<netcdf_suff>
% OUTPUT
% ./netcdf-files/<SNAPSHOT>/<netcdf_EKLx>.<netcdf_domain>.<netcdf_suff>
% 
% with netcdf_* as global variables
% netcdf_EKLx = 'EKLx' by default
%
% 12/04/06
% gmaze@mit.edu

function varargout = compute_EKLx(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_TAUX netcdf_RHO netcdf_EKLx
pv_checkpath
global EKL Tx Ty TAU RHO f


% NETCDF file name:
filTx  = netcdf_TAUX;
filRHO = netcdf_RHO;

% Path and extension to find them:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,filTx,'.',netcdf_domain,'.',ext);
ncTx    = netcdf(ferfile,'nowrite');
Tx      = ncTx{4}(1,:,:);

ferfile = strcat(pathname,sla,snapshot,sla,filRHO,'.',netcdf_domain,'.',ext);
ncRHO   = netcdf(ferfile,'nowrite');
RHO     = ncRHO{4}(1,:,:);
[RHOlon RHOlat RHOdpt] = coordfromnc(ncRHO);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get EKL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dim:
if toshow, disp('dim'), end
nx = length(RHOlon);
ny = length(RHOlat);
ynz = length(RHOdpt);

% Pre-allocate:
if toshow, disp('pre-allocate'), end
EKL = zeros(ny,nx);

% Planetary vorticity:
f = 2*(2*pi/86400)*sin(RHOlat*pi/180);
[a f c]=meshgrid(RHOlon,f,RHOdpt); clear a c
f = permute(f,[3 1 2]);
f = squeeze(f(1,:,:));

% Windstress amplitude:
TAU = sqrt( Tx.^2 );

% Ekman Layer Depth:
EKL = 0.7* sqrt(TAU ./ RHO) ./f;
%EKL = 1.7975 * sqrt( TAU ./ RHO ./ f );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
if ~isempty('netcdf_EKLx')
  netfil = netcdf_EKLx;
else
  netfil = 'EKLx';
end
units      = 'm';
ncid       = 'EKLx';
longname   = 'Ekman Layer Depth from TAUx';
uniquename = 'EKLx';

% Open output file:
nc = netcdf(strcat(pathname,sla,snapshot,sla,netfil,'.',netcdf_domain,'.',ext),'clobber');

% Define axis:
nx = length(RHOlon) ;
ny = length(RHOlat) ;
nz = 1 ;

nc('X') = nx;
nc('Y') = ny;
nc('Z') = nz;
 
nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = RHOlon;
 
nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = RHOlat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = RHOdpt(1);
 
% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = EKL;



% Close files:
close(ncTx);
close(ncRHO);
close(nc);



% Output:
output = struct('EKL',EKL,'lat',RHOlat,'lon',RHOlon);
switch nargout
 case 1
  varargout(1) = {output};
end
