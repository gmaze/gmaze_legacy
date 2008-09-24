%
% [Q] = C_compute_potential_vorticity(SNAPSHOT,[WANTSPLPV])
% [Q1,Q2,Q3] = C_compute_potential_vorticity(SNAPSHOT,[WANTSPLPV])
%
% This file computes the potential vorticity Q from
% netcdf files of relative vorticity (OMEGAX, OMEGAY, ZETA)
% and potential density (SIGMATHETA) as
% Q = OMEGAX . dSIGMATHETA/dx + OMEGAY . dSIGMATHETA/dy + (f+ZETA).dSIGMATHETA/dz
% 
% The optional flag WANTSPLPV is set to 0 by defaut. If turn to 1,
% then the program computes the simple PV defined by:
% splQ = f.dSIGMATHETA/dz
%
% Note that none of the fields are defined on the same grid points.
% So, I decided to compute Q on the same grid as SIGMATHETA, ie. the 
% center of the c-grid.
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/OMEGAX.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/OMEGAY.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/ZETA.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/SIGMATHETA.<netcdf_domain>.<netcdf_suff>
% OUPUT:
% ./netcdf-files/<SNAPSHOT>/PV.<netcdf_domain>.<netcdf_suff>
% or 
% ./netcdf-files/<SNAPSHOT>/splPV.<netcdf_domain>.<netcdf_suff>
%
% 06/07/2006
% gmaze@mit.edu
%
  
function varargout = C_compute_potential_vorticity(snapshot,varargin)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sla netcdf_domain netcdf_suff
pv_checkpath

%% Flags to choose which term to compute (by default, all):
FLpv1 = 1;
FLpv2 = 1;
FLpv3 = 1;
if nargin==2  % case of optional flag presents:
  if varargin{1}(1) == 1 % Case of the simple PV:
    FLpv1 = 0;
    FLpv2 = 0;
    FLpv3 = 2;
  end
end %if
%[FLpv1 FLpv2 FLpv3]


%% Optionnal flags:
global toshow % Turn to 1 to follow the computing process


%% NETCDF files:

% Path and extension to find them:
pathname = strcat('netcdf-files',sla,snapshot,sla);
%pathname = '.';
ext      = strcat('.',netcdf_suff);

% Names:
if FLpv3 ~= 2 % We don't need them for splPV
  filOx = strcat('OMEGAX'    ,'.',netcdf_domain);
  filOy = strcat('OMEGAY'    ,'.',netcdf_domain);
  filOz = strcat('ZETA'      ,'.',netcdf_domain);
end %if
  filST = strcat('SIGMATHETA','.',netcdf_domain);

% Load files and coordinates:
if FLpv3 ~= 2 % We don't need them for splPV
  ferfile             = strcat(pathname,sla,filOx,ext);
  ncOx                = netcdf(ferfile,'nowrite');
  [Oxlon Oxlat Oxdpt] = coordfromnc(ncOx);
  ferfile             = strcat(pathname,sla,filOy,ext);
  ncOy                = netcdf(ferfile,'nowrite');
  [Oylon Oylat Oydpt] = coordfromnc(ncOy);
  ferfile             = strcat(pathname,sla,filOz,ext);
  ncOz                = netcdf(ferfile,'nowrite');
  [Ozlon Ozlat Ozdpt] = coordfromnc(ncOz);
end %if
  ferfile             = strcat(pathname,sla,filST,ext);
  ncST                = netcdf(ferfile,'nowrite');
  [STlon STlat STdpt] = coordfromnc(ncST);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Then, compute the first term:  OMEGAX . dSIGMATHETA/dx  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FLpv1
  
%%%%%  
%% 1: Compute zonal gradient of SIGMATHETA:

% Dim:
if toshow,disp('dim'),end
nx = length(STlon) - 1;
ny = length(STlat);
nz = length(STdpt);

% Pre-allocate:
if toshow,disp('pre-allocate'),end
dSIGMATHETAdx = zeros(nz,ny,nx-1)*NaN;
           dx = zeros(1,nx).*NaN;
         STup = zeros(nz,nx);
         STdw = zeros(nz,nx);

% Zonal gradient of SIGMATHETA:
if toshow,disp('grad'), end
for iy = 1 : ny
  if toshow
    disp(strcat('Computing dSIGMATHETA/dx at latitude : ',num2str(STlat(iy)),...
	        '^o (',num2str(iy),'/',num2str(ny),')'   ));
  end  
  [dx b] = meshgrid( m_lldist(STlon(1:nx+1),[1 1]*STlat(iy)), STdpt ) ; clear b
  STup   = squeeze(ncST{4}(:,iy,2:nx+1));
  STdw   = squeeze(ncST{4}(:,iy,1:nx));
  dSTdx  = ( STup - STdw ) ./ dx;
  % Change horizontal grid point definition to fit with SIGMATHETA:
  dSTdx  = ( dSTdx(:,1:nx-1) + dSTdx(:,2:nx) )./2; 
  dSIGMATHETAdx(:,iy,:) = dSTdx;
end %for iy


%%%%%
%% 2: Move OMEGAX on the same grid:
if toshow,disp('Move OMEGAX on the same grid as dSIGMATHETA/dx'), end

% Change vertical gridding of OMEGAX:
Ox = ncOx{4}(:,:,:);
Ox = ( Ox(2:nz-1,:,:) + Ox(1:nz-2,:,:) )./2;
% And horizontal gridding:
Ox = ( Ox(:,2:ny-1,:) + Ox(:,1:ny-2,:) )./2;

%%%%%
%% 3: Make both fields having same limits:
%%    (Keep points where both fields are defined)
           Ox = squeeze(Ox(:,:,2:nx));
dSIGMATHETAdx = squeeze( dSIGMATHETAdx (2:nz-1,2:ny-1,:) );

%%%%%
%% 4: Last, compute first term of PV:
PV1 = Ox.*dSIGMATHETAdx ; 

% and define axis fron the ST grid:
PV1_lon = STlon(2:length(STlon)-1);
PV1_lat = STlat(2:length(STlat)-1);
PV1_dpt = STdpt(2:length(STdpt)-1);

clear nx ny nz dx STup STdw iy dSTdx Ox dSIGMATHETAdx
end %if FLpv1




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the second term:  OMEGAY . dSIGMATHETA/dy  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FLpv2
  
%%%%%  
%% 1: Compute meridional gradient of SIGMATHETA:

% Dim:
if toshow,disp('dim'), end
nx = length(STlon) ;
ny = length(STlat) - 1 ;
nz = length(STdpt) ;

% Pre-allocate:
if toshow,disp('pre-allocate'), end
dSIGMATHETAdy = zeros(nz,ny-1,nx).*NaN;
           dy = zeros(1,ny).*NaN;
         STup = zeros(nz,ny);
         STdw = zeros(nz,ny);

% Meridional gradient of SIGMATHETA:
% (Assuming the grid is regular, dy is independent of x)
[dy b] = meshgrid( m_lldist([1 1]*STlon(1),STlat(1:ny+1) ), STdpt ) ; clear b
for ix = 1 : nx
  if toshow
    disp(strcat('Computing dSIGMATHETA/dy at longitude : ',num2str(STlon(ix)),...
	        '^o (',num2str(ix),'/',num2str(nx),')'   ));
  end
  STup  = squeeze(ncST{4}(:,2:ny+1,ix));
  STdw  = squeeze(ncST{4}(:,1:ny,ix));
  dSTdy = ( STup - STdw ) ./ dy;
  % Change horizontal grid point definition to fit with SIGMATHETA:
  dSTdy = ( dSTdy(:,1:ny-1) + dSTdy(:,2:ny) )./2; 
  dSIGMATHETAdy(:,:,ix) = dSTdy;
end %for iy

%%%%%
%% 2: Move OMEGAY on the same grid:
if toshow,disp('Move OMEGAY on the same grid as dSIGMATHETA/dy'), end

% Change vertical gridding of OMEGAY:
Oy = ncOy{4}(:,:,:);
Oy = ( Oy(2:nz-1,:,:) + Oy(1:nz-2,:,:) )./2;
% And horizontal gridding:
Oy = ( Oy(:,:,2:nx-1) + Oy(:,:,1:nx-2) )./2;

%%%%%
%% 3: Make them having same limits:
%%    (Keep points where both fields are defined)
           Oy = squeeze(Oy(:,2:ny,:));
dSIGMATHETAdy = squeeze( dSIGMATHETAdy (2:nz-1,:,2:nx-1) );

%%%%%
%% 4: Last, compute second term of PV:
PV2 = Oy.*dSIGMATHETAdy ; 

% and defined axis fron the ST grid:
PV2_lon = STlon(2:length(STlon)-1);
PV2_lat = STlat(2:length(STlat)-1);
PV2_dpt = STdpt(2:length(STdpt)-1);


clear nx ny nz dy STup STdw dy dSTdy Oy dSIGMATHETAdy
end %if FLpv2





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the third term: ( f + ZETA ) . dSIGMATHETA/dz  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FLpv3

%%%%%
%% 1: Compute vertical gradient of SIGMATHETA:

% Dim:
if toshow,disp('dim'), end
nx = length(STlon) ;
ny = length(STlat) ;
nz = length(STdpt) - 1 ;

% Pre-allocate:
if toshow,disp('pre-allocate'), end
dSIGMATHETAdz = zeros(nz-1,ny,nx).*NaN;
           ST = zeros(nz+1,ny,nx);
           dz = zeros(1,nz).*NaN;

% Vertical grid differences:
% STdpt contains negative values with STdpt(1) at the surface
% and STdpt(end) at the bottom of the ocean.
% So dz is positive with respect to z axis upward:
         dz = -diff(STdpt); 
[a dz_3D c] = meshgrid(STlat,dz,STlon); clear a c

% Vertical gradient:
if toshow,disp('Vertical gradient of SIGMATHETA'), end
           ST = ncST{4}(:,:,:);
	   % Z axis upward, so vertical derivative is upper-part
	   % minus lower-part:
dSIGMATHETAdz = ( ST(1:nz,:,:) - ST(2:nz+1,:,:) ) ./ dz_3D;
clear dz_3D ST

% Change vertical gridding:
dSIGMATHETAdz = ( dSIGMATHETAdz(1:nz-1,:,:) + dSIGMATHETAdz(2:nz,:,:) )./2;

if FLpv3 == 1 % Just for full PV
  
  %%%%%
  %% 2: Move ZETA on the same grid:
  if toshow,disp('Move ZETA on the same grid as dSIGMATHETA/dz'), end
  Oz = ncOz{4}(:,:,:);
  % Change horizontal gridding:
  Oz = ( Oz(:,:,2:nx-1) + Oz(:,:,1:nx-2) )./2;
  Oz = ( Oz(:,2:ny-1,:) + Oz(:,1:ny-2,:) )./2;

end %if FLpv3=1

%%%%%
%% 3: Make them having same limits:
%%    (Keep points where both fields are defined)
if FLpv3 == 1
           Oz = squeeze(Oz(2:nz,:,:));	   
end %if	   
dSIGMATHETAdz = squeeze( dSIGMATHETAdz (:,2:ny-1,2:nx-1) );


%%%%%
%% 4: Last, compute third term of PV:
% and defined axis fron the ST grid:
PV3_lon = STlon(2:length(STlon)-1);
PV3_lat = STlat(2:length(STlat)-1);
PV3_dpt = STdpt(2:length(STdpt)-1);

% Planetary vorticity:
f = 2*(2*pi/86400)*sin(PV3_lat*pi/180);
[a f c]=meshgrid(PV3_lon,f,PV3_dpt); clear a c
f = permute(f,[3 1 2]);

% Third term of PV:
if FLpv3 == 2
  % Compute simple PV, just with planetary vorticity:
  PV3 = f.*dSIGMATHETAdz ;
else
  % To compute full PV:
  PV3 = (f+Oz).*dSIGMATHETAdz ; 
end
 


clear nx ny nz dz ST Oz dSIGMATHETAdz f
end %if FLpv3



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Then, compute potential vorticity:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow,disp('Summing terms to get PV:'),end
% If we had computed the first term:
if FLpv1
  if toshow,disp('First term alone'),end
  PV = PV1;
  PV_lon=PV1_lon;PV_lat=PV1_lat;PV_dpt=PV1_dpt;
end
% If we had computed the second term:
if FLpv2
  if exist('PV') % and the first one:
    if toshow,disp('Second term added to first one'),end
    PV = PV + PV2; 
  else           % or not:
    if toshow,disp('Second term alone'),end
    PV = PV2; 
    PV_lon=PV2_lon;PV_lat=PV2_lat;PV_dpt=PV2_dpt;  
  end
end
% If we had computed the third term:
if FLpv3
  if exist('PV') % and one of the first or second one:
    if toshow,disp('Third term added to first and/or second one(s)'),end
    PV = PV + PV3; 
  else           % or not:
    if toshow,disp('Third term alone'),end
    PV = PV3;
    PV_lon=PV3_lon;PV_lat=PV3_lat;PV_dpt=PV3_dpt;  
  end
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow,disp('Now reccording PV file ...'),end

% General informations: 
if FLpv3 == 1
  netfil     = strcat('PV','.',netcdf_domain,'.',netcdf_suff);
  units      = 'kg/s/m^4';
  ncid       = 'PV';
  longname   = 'Potential vorticity';
  uniquename = 'potential_vorticity';
else
  netfil     = strcat('splPV','.',netcdf_domain,'.',netcdf_suff);
  units      = 'kg/s/m^4';
  ncid       = 'splPV';
  longname   = 'Simple Potential vorticity';
  uniquename = 'simple_potential_vorticity';
end %if  

% Open output file:
nc = netcdf(strcat(pathname,sla,netfil),'clobber');

% Define axis:
nc('X') = length(PV_lon);
nc('Y') = length(PV_lat);
nc('Z') = length(PV_dpt);

nc{'X'} = 'X';
nc{'Y'} = 'Y';
nc{'Z'} = 'Z';

nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = PV_lon;

nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = PV_lat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = PV_dpt;

% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = PV;

nc=close(nc);
if FLpv3 ~= 2
   close(ncOx);
   close(ncOy);
   close(ncOz);
end
close(ncST);

% Outputs:
OUT = struct('PV',PV,'dpt',PV_dpt,'lat',PV_lat,'lon',PV_lon);
switch nargout
 case 1
  varargout(1) = {OUT};
 case 2
  varargout(1) = {struct('PV1',PV1,'dpt',PV1_dpt,'lat',PV1_lat,'lon',PV1_lon)};
  varargout(2) = {struct('PV2',PV2,'dpt',PV2_dpt,'lat',PV2_lat,'lon',PV2_lon)};
 case 3
  varargout(1) = {struct('PV1',PV1,'dpt',PV1_dpt,'lat',PV1_lat,'lon',PV1_lon)};
  varargout(2) = {struct('PV2',PV2,'dpt',PV2_dpt,'lat',PV2_lat,'lon',PV2_lon)};
  varargout(3) = {struct('PV3',PV3,'dpt',PV3_dpt,'lat',PV3_lat,'lon',PV3_lon)};
end
