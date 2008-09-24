%
% [Q] = D_compute_potential_vorticity(SNAPSHOT,[WANTSPLPV])
%
% For a time snapshot, this program multiplies the potential
% vorticity computed with C_COMPUTE_POTENTIAL_VORTICITY by the
% coefficient: -1/RHO
% Optional flag WANTSPLPV is turn to 0 by default. Turn it to 1
% if the PV computed is the simple one (f.dSIGMATHETA/dz). It's 
% needed for the output netcdf file informations.
% 
% CAUTION:
%% If all the PV computing procedure has been performed with routines
%% from the package, the PV field has less points than the RHO one, exactly
%% first and last in all directions have to be removed from RHO.
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_RHO>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_PV>.<netcdf_domain>.<netcdf_suff>
% OUPUT:
% ./netcdf-files/<SNAPSHOT>/PV.<netcdf_domain>.<netcdf_suff>
% or 
% ./netcdf-files/<SNAPSHOT>/splPV.<netcdf_domain>.<netcdf_suff>
%
% 06/21/2006
% gmaze@mit.edu
%

  
function varargout = D_compute_potential_vorticity(snapshot,varargin)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sla netcdf_RHO netcdf_PV netcdf_domain netcdf_suff
pv_checkpath

%% Flags to choose which term to compute (by default, all):
FLpv3 = 1;
if nargin==2  % case of optional flag presents:
  if varargin{1}(1) == 1 % Case of the simple PV:
    FLpv3 = 0;
  end
end %if

%% PV and RHO netcdf-files:
filPV  = strcat(netcdf_PV ,'.',netcdf_domain);
filRHO = strcat(netcdf_RHO,'.',netcdf_domain);

%% Path and extension to find them:
pathname = strcat('netcdf-files',sla,snapshot);
ext      = strcat('.',netcdf_suff);

%% Load netcdf files:
ferfile = strcat(pathname,sla,filPV,ext);
ncPV    = netcdf(ferfile,'nowrite');
[PV_lon PV_lat PV_dpt] = coordfromnc(ncPV);

ferfile = strcat(pathname,sla,filRHO,ext);
ncRHO   = netcdf(ferfile,'nowrite');
[RHO_lon RHO_lat RHO_dpt] = coordfromnc(ncRHO);

%% Flags:
global toshow % Turn to 1 to follow the computing process



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply the coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Pre-allocate:
if toshow,disp('Pre-allocate');end
nx = length(PV_lon);
ny = length(PV_lat);
nz = length(PV_dpt);
PV = zeros(nz,ny,nx).*NaN;

%% Apply:
if toshow,disp('Multiplying PV field by -1/RHO'),end
PV =  - ncPV{4}(:,:,:) ./ ncRHO{4}(2:nz+1,2:ny+1,2:nx+1) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow,disp('Now reccording PV file ...'),end

% General informations: 
%ncclose(ncPV);

if FLpv3 == 1
  netfil     = strcat('PV','.',netcdf_domain,'.',netcdf_suff);
  units      = '1/s/m';
  ncid       = 'PV';
  longname   = 'Potential vorticity';
  uniquename = 'potential_vorticity';
else
  netfil     = strcat('splPV','.',netcdf_domain,'.',netcdf_suff);
  units      = '1/s/m';
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
close(ncPV);
close(ncRHO);

% Outputs:
OUT = struct('PV',PV,'dpt',PV_dpt,'lat',PV_lat,'lon',PV_lon);
switch nargout
 case 1
  varargout(1) = {OUT};
end
