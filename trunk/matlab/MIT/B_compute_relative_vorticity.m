%
% [OMEGA] = B_compute_relative_vorticity(SNAPSHOT)
%
% For a time snapshot, this program computes the 
% 3D relative vorticity field from 3D 
% horizontal speed fields U,V (x,y,z) as:
% OMEGA = ( -dVdz ; dUdz ; dVdx - dUdy )
%       = (   Ox  ;  Oy  ;     ZETA    )
% 3 outputs files are created.
%
% (U,V) must have same dimensions and by default are defined on
% a C-grid. 
% If (U,V) are defined on an A-grid (coming from a cube-sphere
% to lat/lon grid interpolation for example), ie at the same points
% as THETA, SALTanom, ... the global variable 'griddef' must
% be set to 'A-grid'. Then (U,V) are moved to a C-grid for the computation.
%
% ZETA is computed at the upper-right corner of the C-grid.
% OMEGAX and OMEGAY are computed at V and U locations but shifted downward
% by 1/2 grid. In case of a A-grid for (U,V), OMEGAX and OMEGAY are moved 
% to a C-grid according to the ZETA computation.
% 
%
% Files names are:
% INPUT:
% ./netcdf-files/<SNAPSHOT>/<netcdf_UVEL>.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/<netcdf_VVEL>.<netcdf_domain>.<netcdf_suff>
% OUPUT:
% ./netcdf-files/<SNAPSHOT>/OMEGAX.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/OMEGAY.<netcdf_domain>.<netcdf_suff>
% ./netcdf-files/<SNAPSHOT>/ZETA.<netcdf_domain>.<netcdf_suff>
%
% 2006/06/07
% gmaze@mit.edu
%
% Last update: 
% 2007/02/01 (gmaze) : Fix bug in ZETA grid and add compatibility with A-grid
%
  
% On the C-grid, U and V are supposed to have the same dimensions and are
% defined like this:
%
%  y
%  ^      -------------------------
%  |      |     |     |     |     |
%  | ny   U  *  U  *  U  *  U  *  |
%  |      |     |     |     |     |
%  |   ny -- V --- V --- V --- V --
%  |      |     |     |     |     |
%  |      U  *  U  *  U  *  U  *  |
%  |      |     |     |     |     |
%  |      -- V --- V --- V --- V --
%  |      |     |     |     |     |
%  |      U  *  U  *  U  *  U  *  |
%  |      |     |     |     |     |
%  |      -- V --- V --- V --- V --
%  |      |     |     |     |     |
%  |  1   U  *  U  *  U  *  U  *  |
%  |      |     |     |     |     |
%  |    1 -- V --- V --- V --- V --
%  |       
%  |      1                 nx
%  |         1                 nx
%--|-------------------------------------> x
%  | 
%
% On the A-grid, U and V are defined on *, so we simply shift U westward by 1/2 grid
% and V southward by 1/2 grid. New (U,V) have the same dimensions as original fields
% but with first col for U, and first row for V set to NaN. Values are computed by
% averaging two contiguous values.
%

function varargout = B_compute_relative_vorticity(snapshot)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global sla netcdf_UVEL netcdf_VVEL netcdf_domain netcdf_suff griddef
pv_checkpath


%% U,V files name:
filU = strcat(netcdf_UVEL,'.',netcdf_domain);
filV = strcat(netcdf_VVEL,'.',netcdf_domain);


%% Path and extension to find them:
pathname = strcat('netcdf-files',sla,snapshot,sla);
ext      = strcat('.',netcdf_suff);


%% Load files and axis:
ferfile          = strcat(pathname,sla,filU,ext);
ncU              = netcdf(ferfile,'nowrite');
[Ulon Ulat Udpt] = coordfromnc(ncU);

ferfile          = strcat(pathname,sla,filV,ext);
ncV              = netcdf(ferfile,'nowrite');
[Vlon Vlat Vdpt] = coordfromnc(ncV);

clear ext ferfile

%% Load grid definition:
global griddef
if length(griddef) == 0
  griddef = 'C-grid'; % By default
end
switch lower(griddef)
 case {'c-grid','cgrid','c'}
    % Nothing to do here
 case {'a-grid','agrid','a'}
    disp('Found (U,V) defined on A-grid')
    % Move Ulon westward by 1/2 grid point:
     Ulon = [Ulon(1)-abs(diff(Ulon(1:2))/2) ; (Ulon(1:end-1)+Ulon(2:end))/2];
    % Move V southward by 1/2 grid point:
     Vlat = [Vlat(1)-abs(diff(Vlat(1:2))/2); (Vlat(1:end-1)+Vlat(2:end))/2];
    % Now, (U,V) axis are defined as if they came from a C-grid
    % (U,V) fields are moved to a C-grid during computation...
 otherwise
    error('The grid must be: C-grid or A-grid');
    return
end %switch griddef
  
  
%% Optionnal flags
computeZETA = 1; % Compute ZETA or not ?
global toshow % Turn to 1 to follow the computing process


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VERTICAL COMPONENT: ZETA %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% U field is on the zonal side of the c-grid and
% V field on the meridional one.
% So computing meridional gradient for U and 
% zonal gradient for V makes the relative vorticity
% zeta defined on the corner of the c-grid.

%%%%%%%%%%%%%%
%% Dimensions of ZETA field:
if toshow,disp('Dim'),end
  ny = length(Ulat)-1; 
  nx = length(Vlon)-1; 
  nz = length(Udpt); % Note that Udpt=Vdpt
  
%%%%%%%%%%%%%%
%% Pre-allocation:
if toshow,disp('Pre-allocate'),end
ZETA = zeros(nz,ny-1,nx-1).*NaN;
dx   = zeros(ny-1,nx-1);
dy   = zeros(ny-1,nx-1);

ZETA_lon = Ulon(2:nx+1);
ZETA_lat = Vlat(2:ny+1);

%%%%%%%%%%%%%%
%% Compute relative vorticity for each z-level:
if computeZETA
for iz = 1 : nz
  if toshow
    disp(strcat('Computing \zeta at depth : ',num2str(Udpt(iz)),...
	        'm (',num2str(iz),'/',num2str(nz),')'   ));
  end
  
  % Get velocities:
  U = ncU{4}(iz,:,:);
  V = ncV{4}(iz,:,:);
  switch lower(griddef)
   case {'a-grid','agrid','a'}
    % Move U westward by 1/2 grid point:
    % (1st col is set to nan, but axis defined)
    U = [ones(ny+1,1).*NaN  (U(:,1:end-1) + U(:,2:end))/2];
    % Move V southward by 1/2 grid point:
    % (1st row is set to nan but axis defined)
    V = [ones(1,nx+1).*NaN;  (V(1:end-1,:) + V(2:end,:))/2];
    % Now, U and V are defined as if they came from a C-grid
  end  
  
  % And now compute the vertical component of relative vorticity:
  % (TO DO: m_lldist accepts tables as input, so this part may be
  % done without x,y loop ...)
  for iy = 1 : ny
    for ix = 1 : nx
      if iz==1 % It's more efficient to make this test each time than
              % recomputing distance each time. m_lldist is a slow routine.
         % ZETA axis and grid distance:
         dx(iy,ix) = m_lldist([Vlon(ix+1) Vlon(ix)],[1 1]*Vlat(iy));
         dy(iy,ix) = m_lldist([1 1]*Vlon(ix),[Ulat(iy+1) Ulat(iy)]);
      end %if 
      % Horizontal gradients and ZETA:
      dVdx        = ( V(iy,ix+1)-V(iy,ix) ) / dx(iy,ix) ;
      dUdy        = ( U(iy+1,ix)-U(iy,ix) ) / dy(iy,ix) ;
      ZETA(iz,iy,ix) = dVdx - dUdy;      
    end %for ix
  end %for iy
end %for iz

%%%%%%%%%%%%%%
%% Netcdf record:

% General informations: 
netfil     = strcat('ZETA','.',netcdf_domain,'.',netcdf_suff);
units      = '1/s';
ncid       = 'ZETA';
longname   = 'Vertical Component of the Relative Vorticity';
uniquename = 'vertical_relative_vorticity';

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
nc{'X'}(:)         = ZETA_lon;

nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = ZETA_lat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = Udpt;

% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = ZETA;

nc=close(nc);

clear x y z U V dx dy nx ny nz DVdx dUdy

end %if compute ZETA


%%%%%%%%%%%%%%%%%%%%%%%%%
% HORIZONTAL COMPONENTS %
%%%%%%%%%%%%%%%%%%%%%%%%%
if toshow, disp('')
           disp('Now compute horizontal components of relative vorticity ...'); end

% U and V are defined on the same Z grid.

%%%%%%%%%%%%%%
%% Dimensions of OMEGA x and y fields:
if toshow,disp('Dim'),end
  O_nx = [length(Vlon) length(Ulon)];
  O_ny = [length(Vlat) length(Ulat)];
  O_nz = length(Udpt) - 1; % Idem Vdpt
  
%%%%%%%%%%%%%%
%% Pre-allocations:
if toshow,disp('Pre-allocate'),end
Ox = zeros(O_nz,O_ny(1),O_nx(1)).*NaN;
Oy = zeros(O_nz,O_ny(2),O_nx(2)).*NaN;

%%%%%%%%%%%%%%
%% Computation:

%% Vertical grid differences:
dZ   = diff(Udpt); 
Odpt = Udpt(1:O_nz) + dZ/2;

%% Zonal component of OMEGA:
if toshow,disp('Zonal direction ...'); end
[a dZ_3D c] = meshgrid(Vlat,dZ,Vlon); clear a c
V = ncV{4}(:,:,:);
switch lower(griddef)
   case {'a-grid','agrid','a'}
    % Move V southward by 1/2 grid point:
    % (1st row is set to nan but axis defined)
    V = cat(2,ones(O_nz+1,1,O_nx(1)).*NaN,(V(:,1:end-1,:) + V(:,2:end,:))/2);
    % Now, V is defined as if it came from a C-grid
end
Ox = - ( V(2:O_nz+1,:,:) - V(1:O_nz,:,:) ) ./ dZ_3D;
clear V dZ_3D % For memory use

%% Meridional component of OMEGA:
if toshow,disp('Meridional direction ...'); end
[a dZ_3D c] = meshgrid(Ulat,dZ,Ulon); clear a c
U = ncU{4}(:,:,:);
switch lower(griddef)
   case {'a-grid','agrid','a'}
    % Move U westward by 1/2 grid point:
    % (1st col is set to nan, but axis defined)
    U = cat(3,ones(O_nz+1,O_ny(2),1).*NaN,(U(:,:,1:end-1) + U(:,:,2:end))/2);
    % Now, V is defined as if it came from a C-grid
end  
Oy = ( U(2:O_nz+1,:,:) - U(1:O_nz,:,:) ) ./ dZ_3D;
clear U dZ_3D % For memory use

clear dZ


%%%%%%%%%%%%%%
%% Record Zonal component:
if toshow,disp('Records ...'); end

% General informations: 
netfil     = strcat('OMEGAX','.',netcdf_domain,'.',netcdf_suff);
units      = '1/s';
ncid       = 'OMEGAX';
longname   = 'Zonal Component of the Relative Vorticity';
uniquename = 'zonal_relative_vorticity';

% Open output file:
nc = netcdf(strcat(pathname,sla,netfil),'clobber');

% Define axis:
nc('X') = O_nx(1);
nc('Y') = O_ny(1);
nc('Z') = O_nz;

nc{'X'} = 'X';
nc{'Y'} = 'Y';
nc{'Z'} = 'Z';

nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = Vlon;

nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = Vlat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = Odpt;

% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = Ox;

nc=close(nc);

%%%%%%%%%%%%%%
%% Record Meridional component:
% General informations: 
netfil     = strcat('OMEGAY','.',netcdf_domain,'.',netcdf_suff);
units      = '1/s';
ncid       = 'OMEGAY';
longname   = 'Meridional Component of the Relative Vorticity';
uniquename = 'meridional_relative_vorticity';

% Open output file:
nc = netcdf(strcat(pathname,sla,netfil),'clobber');

% Define axis:
nc('X') = O_nx(2);
nc('Y') = O_ny(2);
nc('Z') = O_nz;

nc{'X'} = 'X';
nc{'Y'} = 'Y';
nc{'Z'} = 'Z';

nc{'X'}            = ncfloat('X');
nc{'X'}.uniquename = ncchar('X');
nc{'X'}.long_name  = ncchar('longitude');
nc{'X'}.gridtype   = nclong(0);
nc{'X'}.units      = ncchar('degrees_east');
nc{'X'}(:)         = Ulon;

nc{'Y'}            = ncfloat('Y'); 
nc{'Y'}.uniquename = ncchar('Y');
nc{'Y'}.long_name  = ncchar('latitude');
nc{'Y'}.gridtype   = nclong(0);
nc{'Y'}.units      = ncchar('degrees_north');
nc{'Y'}(:)         = Ulat;
 
nc{'Z'}            = ncfloat('Z');
nc{'Z'}.uniquename = ncchar('Z');
nc{'Z'}.long_name  = ncchar('depth');
nc{'Z'}.gridtype   = nclong(0);
nc{'Z'}.units      = ncchar('m');
nc{'Z'}(:)         = Odpt;

% And main field:
nc{ncid}               = ncfloat('Z', 'Y', 'X'); 
nc{ncid}.units         = ncchar(units);
nc{ncid}.missing_value = ncfloat(NaN);
nc{ncid}.FillValue_    = ncfloat(NaN);
nc{ncid}.longname      = ncchar(longname);
nc{ncid}.uniquename    = ncchar(uniquename);
nc{ncid}(:,:,:)        = Oy;

nc=close(nc);
close(ncU);
close(ncV);

% Outputs:
OMEGA = struct(...
    'Ox',struct('value',Ox,'dpt',Odpt,'lat',Vlat,'lon',Vlon),...
    'Oy',struct('value',Oy,'dpt',Odpt,'lat',Ulat,'lon',Vlon),...
    'Oz',struct('value',ZETA,'dpt',Udpt,'lat',ZETA_lat,'lon',ZETA_lon)...
    );
switch nargout
 case 1
  varargout(1) = {OMEGA};
end
