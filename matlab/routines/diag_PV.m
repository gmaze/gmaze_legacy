% PV = diag_PV(LON,LAT,DPT,SIGMATHETA,RHO)
%
% Compute a simple potential vorticity as:
% PV = -f/RHO * dSIGMATHETA/dz
%
% PV is given on the SIGMATHETA vertical grid
%
% 2008/02/14
% gmaze@mit.edu
%

function varargout = diag_PV(varargin)


% Axis:
lon = varargin{1};
lat = varargin{2};
dpt = varargin{3};
nlon = length(lon);
nlat = length(lat);
ndpt = length(dpt);

% Fields:
ST  = varargin{4};
RHO = varargin{5};

% Vertical grid differences:
% dpt contains negative values with dpt(1) at the surface
% and dpt(end) at the bottom of the ocean.
% So dz is positive with respect to z axis upward:
         dz = -diff(dpt); 
[a dz_3D c] = meshgrid(lat,dz,lon); clear a c


% Vertical gradient of potential density:
dSTdz = (ST(1:ndpt-1,:,:) - ST(2:ndpt,:,:) )./ dz_3D;


% Move it back to the ST vertical grid:
dSTdz = (dSTdz(1:ndpt-2,:,:)+dSTdz(2:ndpt-1,:,:))./2;
dSTdz = cat(1,ones(1,nlat,nlon).*NaN,dSTdz);
dSTdz = cat(1,dSTdz,ones(1,nlat,nlon).*NaN);


% Planetary vorticity:
f = 2*(2*pi/86400)*sin(lat*pi/180);
[a f c]=meshgrid(lon,f,dpt); clear a c
f = permute(f,[3 1 2]);


% Potential Vorticity:
PV = -f./RHO .* dSTdz;


% Output:
varargout(1) = {PV};