%
% [EKL] = compute_EKL(SNAPSHOT)
%
% Here we compute the Ekmal Layer Depth as:
% EKL = 0.7 sqrt( |TAU|/RHO )/f 
%
% where:
%  TAU is the amplitude of the surface wind-stress (N/m2)
%  RHO is the density of seawater (kg/m3)
%  f is the Coriolis parameter (kg/m3)
%  EKL is the Ekman layer depth (m)
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_RHO>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_TAUX>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_TAUY>.<netcdf_domain>.<netcdf_suff>
% OUTPUT
% ./netcdf-files/<SNAPSHOT>/<netcdf_EKL>.<netcdf_domain>.<netcdf_suff>
% 
% with netcdf_* as global variables
% netcdf_EKL = 'EKL' by default
%
% 08/16/06
% gmaze@mit.edu

function varargout = compute_EKL(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_TAUX netcdf_TAUY netcdf_RHO netcdf_EKL
pv_checkpath
global EKL Tx Ty TAU RHO f


% NETCDF file name:
filTx  = netcdf_TAUX;
filTy  = netcdf_TAUY;
filRHO = netcdf_RHO;

% Path and extension to find them:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,filTx,'.',netcdf_domain,'.',ext);
ncTx    = netcdf(ferfile,'nowrite');
Tx      = ncTx{4}(1,:,:);
ferfile = strcat(pathname,sla,snapshot,sla,filTy,'.',netcdf_domain,'.',ext);
ncTy    = netcdf(ferfile,'nowrite');
Ty      = ncTy{4}(1,:,:);
[Tylon Tylat Tydpt] = coordfromnc(ncTy);

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
nz = length(RHOdpt);

% Pre-allocate:
if toshow, disp('pre-allocate'), end
EKL = zeros(ny,nx);

% Planetary vorticity:
f = 2*(2*pi/86400)*sin(RHOlat*pi/180);
[a f c]=meshgrid(RHOlon,f,RHOdpt); clear a c
f = permute(f,[3 1 2]);
f = squeeze(f(1,:,:));

% Windstress amplitude:
TAU = sqrt( Tx.^2 + Ty.^2 );

% Ekman Layer Depth:
EKL = 0.7* sqrt(TAU ./ RHO) ./f;
%EKL = 1.7975 * sqrt( TAU ./ RHO ./ f );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
if ~isempty('netcdf_EKL')
  netfil = netcdf_EKL;
else
  netfil = 'EKL';
end
units      = 'm';
ncid       = 'EKL';
longname   = 'Ekman Layer Depth';
uniquename = 'EKL';

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

nc=close(nc);



% Output:
output = struct('EKL',EKL,'lat',RHOlat,'lon',RHOlon);
switch nargout
 case 1
  varargout(1) = {output};
end
