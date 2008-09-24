%
% [JBz] = compute_JBz(SNAPSHOT)
%
% Here we compute the PV flux due to diabatic processes as
% JFz = - alpha * f * Qnet / MLD / Cw
% where:
%  alpha = 2.5*E-4 1/K is the thermal expansion coefficient
%  f = 2*OMEGA*sin(LAT) is the Coriolis parameter
%  Qnet is the net surface heat flux (W/m^2), positive downward
%  MLD is the mixed layer depth (m, positive)
%  Cw = 4187 J/kg/K is the specific heat of seawater
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_Qnet>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_MLD>.<netcdf_domain>.<netcdf_suff>
% OUTPUT:
% ./netcdf-files/<SNAPSHOT>/JBz.<netcdf_domain>.<netcdf_suff>
% 
% with: netcdf_* as global variables
%
% 06/27/06
% gmaze@mit.edu

function varargout = compute_JBz(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_Qnet netcdf_MLD
pv_checkpath


% Path and extension to find netcdf-files:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,netcdf_Qnet,'.',netcdf_domain,'.',ext);
ncQ     = netcdf(ferfile,'nowrite');
[Qlon Qlat Qdpt] = coordfromnc(ncQ);

ferfile = strcat(pathname,sla,snapshot,sla,netcdf_MLD,'.',netcdf_domain,'.',ext);
ncMLD   = netcdf(ferfile,'nowrite');
[MLDlon MLDlat MLDdpt] = coordfromnc(ncMLD);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% surface PV flux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define axis:
nx = length(Qlon) ;
ny = length(Qlat) ;
nz = length(Qdpt) ;


% Planetary vorticity:
f     = 2*(2*pi/86400)*sin(Qlat*pi/180);
[a f] = meshgrid(Qlon,f); clear a c


% Net surface heat flux:
Qnet = ncQ{4}(:,:,:);


% Mixed layer Depth:
MLD = ncMLD{4}(:,:,:);


% Coefficient:
alpha = 2.5*10^(-4); % Surface average value
Cw    = 4187;		  
coef  = - alpha / Cw;


% JBz:
JBz = zeros(nz,ny,nx).*NaN;
JBz(1,:,:) = coef*f.*Qnet./MLD;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
netfil     = 'JBz';
units      = 'kg/m3/s2';
ncid       = 'JBz';
longname   = 'Vertical PV flux due to diabatic processes';
uniquename = 'JBz';

% Open output file:
nc = netcdf(strcat(pathname,sla,snapshot,sla,netfil,'.',netcdf_domain,'.',ext),'clobber');

% Define axis:
nx = length(Qlon) ;
ny = length(Qlat) ;
nz = 1 ;

nc('X') = nx;
nc('Y') = ny;
nc('Z') = nz;
 
nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = Qlon;
 
nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = Qlat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = Qdpt(1);
 
% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = JBz;

nc=close(nc);
close(ncQ);
close(ncMLD);



% Output:
output = struct('JBz',JBz,'lat',Qlat,'lon',Qlon);
switch nargout
 case 1
  varargout(1) = {output};
end
