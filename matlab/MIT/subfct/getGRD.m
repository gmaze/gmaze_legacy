% [dCdx dCdy] = getGRD(C,LAT,LON,[flag,grid])
%
% Compute horizontal gradient of a geographical field C(LAT,LON)
%
% OPTIONS:
%
% flag = 0: lat,lon are normal axis coordinates
% flag = 1: lat,lon specify the spacing between coordinates
%           ie,  length(LAT) = size(C,1) - 1
%           and, length(LON) = size(C,2) - 1
% grid = 0: if output fields are on the computation grid
% grid = 1: if output fields are moved backed on the input grid
%              (edges are filled with NaN)
% 
% 2007/07/01 gmaze@mit.edu
%

function [dCCdx dCCdy] = getGRD(C,LAT,LON,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS:
nar = nargin - 3;
ar_axes = 0; % Default option for axes definition
ar_grid = 0; % Default option for output grid
switch nar
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 1 % axis options
  ar = varargin{1};
  if ~isnumeric(ar)
    disp('getGRD.m: Error, option flag must be numeric')
    return
  elseif ar~=0 & ar~=1
    disp('getGRD.m: Warning, option flag must be 0 or 1')
    disp('getGRD.m: Set flag = 0');
  else
    ar_axes = ar;
  end
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 2 % axis option and grid option
  ar = varargin{1};
  if ~isnumeric(ar)
    disp('getGRD.m: Error, option flag must be numeric')
    return
  elseif ar~=0 & ar~=1
    disp('getGRD.m: Warning, option flag must be 0 or 1')
    disp('getGRD.m: Set flag = 0');
  else
    ar_axes = ar;
  end
  ar = varargin{2};
  if ~isnumeric(ar)
    disp('getGRD.m: Error, option grid must be numeric')
    return
  elseif ar~=0 & ar~=1
    disp('getGRD.m: Warning, option grid must be 0 or 1')
    disp('getGRD.m: Set grid = 0');
  else
    ar_grid = ar;
  end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GRADIENT:
switch ar_axes
 case 0
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAT,LON are coordinates:

% Dim:
nx = length(LON) ;
ny = length(LAT) - 1 ;

% Pre-allocate:
dCCdy = zeros(ny-1,nx).*NaN;
dy   = zeros(1,ny).*NaN;
Cup  = zeros(1,ny);
Cdw  = zeros(1,ny);

% Meridional gradient of C:
% Assuming the grid is regular, dy is independent of x:
dy = m_lldist([1 1]*LON(1),LAT(1:ny+1) );
for ix = 1 : nx
  Cup  = squeeze(C(2:ny+1,ix));
  Cdw  = squeeze(C(1:ny,ix));
  dCdy = ( Cup - Cdw ) ./ dy;
  % Change horizontal grid point definition to fit with original grid:
  if ar_grid == 1
    dCdy = ( dCdy(1:ny-1) + dCdy(2:ny) )./2; 
    dCCdy(:,ix) = dCdy;
  end %if ar_grid
end %for iy
% Fill with NaN at the edge:
if ar_grid == 1
  dCCdy = cat(1,dCCdy,ones(1,nx).*NaN);
  dCCdy = cat(1,ones(1,nx).*NaN,dCCdy);
end %if ar_grid

% Dim:
nx = length(LON) - 1;
ny = length(LAT) ;

% Pre-allocate:
dCCdx = zeros(ny,nx-1).*NaN;
dx    = zeros(1,nx).*NaN;
Cup   = zeros(1,nx);
Cdw   = zeros(1,nx);

% Zonal gradient of C:
for iy = 1 : ny
  dx      = m_lldist(LON(1:nx+1),[1 1]*LAT(iy))' ; 
  Cup    = squeeze(C(iy,2:nx+1));
  Cdw    = squeeze(C(iy,1:nx));
  dCdx   = ( Cup - Cdw ) ./ dx;
  % Change horizontal grid point definition to fit with original grid:
  if ar_grid == 1
    dCdx   = ( dCdx(1:nx-1) + dCdx(2:nx) )./2;
    dCCdx(iy,:) = dCdx;
  end %if ar_grid
end %for iy
% Fill with NaN at the edge:
if ar_grid == 1
  dCCdx = cat(2,dCCdx,ones(ny,1).*NaN);
  dCCdx = cat(2,ones(ny,1).*NaN,dCCdx);
end %if ar_grid



 case 1
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAT,LON are spacings:
  
% Dim:
nx = size(C,2);
ny = size(C,1);

% Zonal gradient:
 dCCdx = squeeze((C(:,2:end) - C(:,1:end-1)))./LON;
 
% Meridional gradient:
 dCCdy = squeeze((C(2:end,:) - C(1:end-1,:)))./LAT;
 
% Eventualy change horizontal grid point definition to fit with original grid:
if ar_grid == 1 
    dCCdx = ( dCCdx(:,1:end-1) + dCCdx(:,2:end) )./2;
    dCCdy = ( dCCdy(1:end-1,:) + dCCdy(2:end,:))./2; 
    % Fill with NaN at the edge:
    dCCdx = cat(2,dCCdx,ones(ny,1).*NaN);
    dCCdx = cat(2,ones(ny,1).*NaN,dCCdx);
    dCCdy = cat(1,dCCdy,ones(1,nx).*NaN);
    dCCdy = cat(1,ones(1,nx).*NaN,dCCdy);
end %if ar_grid
 
end %switch ar_axes  