%
% [JFz] = compute_JFz(SNAPSHOT)
%
% Here we compute the PV flux due to frictionnal forces as
% JFz = ( TAUx * dSIGMATHETA/dy - TAUy * dSIGMATHETA/dx ) / RHO / EKL
%
% where:
%  TAU is the surface wind-stress (N/m2)
%  SIGMATHETA is the potential density (kg/m3)
%  RHO is the density (kg/m3)
%  EKL is the Ekman layer depth (m, positive)
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_SIGMATHETA>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_TAUX>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_TAUY>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_RHO>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_EKL>.<netcdf_domain>.<netcdf_suff>
% OUTPUT:
% ./netcdf-files/<SNAPSHOT>/JFz.<netcdf_domain>.<netcdf_suff>
% 
% with netcdf_* as global variables
%
% 06/27/06
% gmaze@mit.edu

function varargout = compute_JFz(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_TAUX netcdf_TAUY netcdf_SIGMATHETA netcdf_EKL netcdf_RHO
pv_checkpath


% NETCDF file name:
filST  = netcdf_SIGMATHETA;
filTx  = netcdf_TAUX;
filTy  = netcdf_TAUY;
filRHO = netcdf_RHO;
filH   = netcdf_EKL;

% Path and extension to find them:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,filST,'.',netcdf_domain,'.',ext);
ncST     = netcdf(ferfile,'nowrite');
[STlon STlat STdpt] = coordfromnc(ncST);

ferfile = strcat(pathname,sla,snapshot,sla,filTx,'.',netcdf_domain,'.',ext);
ncTx    = netcdf(ferfile,'nowrite');
ferfile = strcat(pathname,sla,snapshot,sla,filTy,'.',netcdf_domain,'.',ext);
ncTy    = netcdf(ferfile,'nowrite');

ferfile = strcat(pathname,sla,snapshot,sla,filRHO,'.',netcdf_domain,'.',ext);
ncRHO   = netcdf(ferfile,'nowrite');
RHO     = ncRHO{4}(1,:,:);

ferfile = strcat(pathname,sla,snapshot,sla,filH,'.',netcdf_domain,'.',ext);
ncH     = netcdf(ferfile,'nowrite');
EKL     = ncH{4}(1,:,:);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dim:
if toshow, disp('dim'), end
nx = length(STlon) ;
ny = length(STlat) - 1 ;
nz = length(STdpt);

% Pre-allocate:
if toshow, disp('pre-allocate'), end
dSIGMATHETAdy = zeros(nz,ny-1,nx).*NaN;
dy       = zeros(1,ny).*NaN;
STup      = zeros(nz,ny);
STdw      = zeros(nz,ny);

% Meridional gradient of SIGMATHETA:
if toshow, disp('grad'), end
% Assuming the grid is regular, dy is independent of x:
[dy b] = meshgrid( m_lldist([1 1]*STlon(1),STlat(1:ny+1) ), STdpt ) ; clear b
for ix = 1 : nx
  if toshow, disp(strcat(num2str(ix),'/',num2str(nx))), end
  STup  = squeeze(ncST{4}(:,2:ny+1,ix));
  STdw  = squeeze(ncST{4}(:,1:ny,ix));
  dSTdy = ( STup - STdw ) ./ dy;
  % Change horizontal grid point definition to fit with SIGMATHETA:
  dSTdy = ( dSTdy(:,1:ny-1) + dSTdy(:,2:ny) )./2; 
  dSIGMATHETAdy(:,:,ix) = dSTdy;
end %for iy

% Make TAUx having same limits:
TAUx = ncTx{4}(1,2:ny,:);

% Compute first term: TAUx * dSIGMATHETA/dy
iz    = 1;
JFz_a = TAUx .* squeeze(dSIGMATHETAdy(iz,:,:)) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second term
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dim:
if toshow, disp('dim'), end
nx = length(STlon) - 1;
ny = length(STlat) ;
nz = length(STdpt) ;

% Pre-allocate:
if toshow, disp('pre-allocate'), end
dSIGMATHETAdx = zeros(nz,ny,nx-1).*NaN;
dx       = zeros(1,nx).*NaN;
STup      = zeros(nz,nx);
STdw      = zeros(nz,nx);

% Zonal gradient of SIGMATHETA
if toshow, disp('grad'), end
for iy = 1 : ny
  if toshow, disp(strcat(num2str(iy),'/',num2str(ny))), end
  [dx b] = meshgrid( m_lldist(STlon(1:nx+1),[1 1]*STlat(iy)), STdpt ) ; clear b
  STup    = squeeze(ncST{4}(:,iy,2:nx+1));
  STdw    = squeeze(ncST{4}(:,iy,1:nx));
  dSTdx   = ( STup - STdw ) ./ dx;
  % Change horizontal grid point definition to fit with SIGMATHETA:
  dSTdx   = ( dSTdx(:,1:nx-1) + dSTdx(:,2:nx) )./2;
  dSIGMATHETAdx(:,iy,:) = dSTdx;
end %for iy

% Make TAUy having same limits:
TAUy  = ncTy{4}(1,:,2:nx);

% Compute second term: TAUy * dSIGMATHETA/dx
iz    = 1;
JFz_b = TAUy .* squeeze(dSIGMATHETAdx(iz,:,:)) ;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finish ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Then make all terms having same limits:
nx = length(STlon) ;
ny = length(STlat) ;
nz = length(STdpt) ;
JFz_a   = squeeze(JFz_a(:,2:nx-1));
JFz_b   = squeeze(JFz_b(2:ny-1,:));
delta_e = squeeze(EKL(2:ny-1,2:nx-1));
rho     = squeeze(RHO(2:ny-1,2:nx-1));

% and finish:
JFz = (JFz_a - JFz_b)./delta_e./rho;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
netfil     = 'JFz';
units      = 'kg/m3/s2';
ncid       = 'JFz';
longname   = 'Vertical PV flux due to frictional forces';
uniquename = 'JFz';

% Open output file:
nc = netcdf(strcat(pathname,sla,snapshot,sla,netfil,'.',netcdf_domain,'.',ext),'clobber');

% Define axis:
nx = length(STlon) ;
ny = length(STlat) ;
nz = 1 ;

nc('X') = nx-2;
nc('Y') = ny-2;
nc('Z') = nz;
 
nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = STlon(2:nx-1);
 
nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = STlat(2:ny-1);
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = STdpt(1);
 
% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = JFz;

nc=close(nc);


% Output:
output = struct('JFz',JFz,'lat',STlat(2:ny-1),'lon',STlon(2:nx-1));
switch nargout
 case 1
  varargout(1) = {output};
end
