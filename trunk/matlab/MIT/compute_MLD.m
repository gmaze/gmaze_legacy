%
% [MLD] = compute_MLD(SNAPSHOT)
%
% Here we compute the Mixed Layer Depth as:
% MLD = min depth for which : ST > ST(SSS,SST-0.8,p0)  
%
% where:
%  ST is potential density (kg/m3)
%  SST the Sea Surface Temperature (oC)
%  SSS the Sea Surface Salinity (PSU-35)
%  p0  the Sea Level Pressure (mb)
%  EKL is the Ekman layer depth (m, positive)
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_SIGMATHETA>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_THETA>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_SALTanom>.<netcdf_domain>.<netcdf_suff>
% OUTPUT
% ./netcdf-files/<SNAPSHOT>/<netcdf_MLD>.<netcdf_domain>.<netcdf_suff>
% 
% with netcdf_* as global variables
% netcdf_MLD = 'MLD' by default
%
% Rq: This method leads to a MLD deeper than KPPmld in the middle of the 
% ocean, and shallower along the coast.
%
% 09/20/06
% gmaze@mit.edu

function varargout = compute_MLD(snapshot)

global sla toshow
global netcdf_suff netcdf_domain
global netcdf_SIGMATHETA netcdf_THETA netcdf_SALTanom netcdf_MLD
pv_checkpath


% NETCDF file name:
filST = netcdf_SIGMATHETA;
filT  = netcdf_THETA;
filS  = netcdf_SALTanom;

% Path and extension to find them:
pathname = strcat('netcdf-files',sla);
ext = netcdf_suff;

% Load files:
ferfile = strcat(pathname,sla,snapshot,sla,filST,'.',netcdf_domain,'.',ext);
ncST    = netcdf(ferfile,'nowrite');
ST      = ncST{4}(:,:,:);
[STlon STlat STdpt] = coordfromnc(ncST);

ferfile = strcat(pathname,sla,snapshot,sla,filT,'.',netcdf_domain,'.',ext);
ncT    = netcdf(ferfile,'nowrite');
SST      = ncT{4}(1,:,:);
[Tlon Tlat Tdpt] = coordfromnc(ncT);

ferfile = strcat(pathname,sla,snapshot,sla,filS,'.',netcdf_domain,'.',ext);
ncS   = netcdf(ferfile,'nowrite');
SSS     = ncS{4}(1,:,:);
[Slon Slat Sdpt] = coordfromnc(ncS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE The Mixed Layer Depth:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('pre-allocate'), end
nx = length(STlon);
ny = length(STlat);
SST08 = SST - 0.8;
SSS   = SSS + 35;
Surfadens08 = densjmd95(SSS,SST08,(0.09998*9.81*Tdpt(1))*ones(ny,nx))-1000;
MLD = zeros(size(ST,2),size(ST,3));

if toshow, disp('get MLD'), end
for iy = 1 : size(ST,2)
  for ix = 1 : size(ST,3)
      mm =  find( squeeze(ST(:,iy,ix)) > Surfadens08(iy,ix) );
      if ~isempty(mm)
        MLD(iy,ix) = STdpt(min(mm));
      end
    %end
  end
end

MLD(isnan(squeeze(ST(1,:,:)))) = NaN;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure we have the right sign (positive)
mm = nanmean(nanmean(MLD,1));
if mm <= 0
  MLD = -MLD;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Record
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('record'), end

% General informations: 
if ~isempty('netcdf_MLD')
  netfil = netcdf_MLD;
else
  netfil = 'MLD';
end
units      = 'm';
ncid       = 'MLD';
longname   = 'Mixed Layer Depth';
uniquename = 'MLD';

% Open output file:
nc = netcdf(strcat(pathname,sla,snapshot,sla,netfil,'.',netcdf_domain,'.',ext),'clobber');

% Define axis:
nx = length(STlon) ;
ny = length(STlat) ;
nz = 1 ;

nc('X') = nx;
nc('Y') = ny;
nc('Z') = nz;
 
nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = STlon;
 
nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = STlat;
 
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
nc{ncid}(:,:,:)        = MLD;

nc=close(nc);
close(ncST);
close(ncS);
close(ncT);


% Output:
output = struct('MLD',MLD,'lat',STlat,'lon',STlon);
switch nargout
 case 1
  varargout(1) = {output};
end
