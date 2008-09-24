% NEWFIELD = diag_interpallREQ(FIELD,LON,LAT,netcdf_domain,resolution)
%
% We interpolate linearly FIELD(LAT,LON) on a grid, independant of the dataset
% with a resolution on the domain netcdf_domain.
%
% 

function varargout = diag_interpallREQ(varargin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Resolution:
dresol = varargin{5};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Domain:
netcdf_domain = varargin{4};
switch netcdf_domain
 case 'global'
  Xmin = 0;
  Xmax = 360;
  Ymin = -90;
  Ymax = 90;
 case 'north_atlantic'
  Xmin = 270;
  Xmax = 360;
  Ymin = 10;
  Ymax = 80;
 case 'north_pacific'
  Xmin = 120;
  Xmax = 260;
  Ymin = 10;
  Ymax = 65;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load or create the grid:
filGRID = sprintf('GRID_COMMON_%s_%3.4g.mat',netcdf_domain,dresol);
if exist(filGRID,'file')
  load(filGRID);
  LON = LON(:);
  LAT = LAT(:);
else
  disp(sprintf('Common grid file over the domain: %s with a %3.4g resolution not found \n%s',...
	       netcdf_domain,dresol,'Generating a new one ...'));
  [LON,LAT,xf,yf,DXF,DYF,zA] = grid_sphere(dresol,dresol);  
  LON = LON(find(LON<=Xmin,1,'last'):find(LON<=Xmax,1,'last'));
  LAT = LAT(find(LAT<=Ymin,1,'last'):find(LAT<=Ymax,1,'last'));
  LON = LON(:);
  LAT = LAT(:);
  save(filGRID,'LON','LAT','-v6');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Interpolate the field:
lon = varargin{2};
lat = varargin{3};
lon = lon(:);
lat = lat(:);
field = varargin{1};

[lo la]  = meshgrid(lon,lat);
[LO LA]  = meshgrid(LON,LAT);
newfield = interp2(lo,la,field,LO,LA,'linear');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output:
varargout(1) = {newfield};
varargout(2) = {LON};
varargout(3) = {LAT};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB FUNCTION

function [xc,yc,xf,yf,DXF,DYF,zA]=grid_sphere(dlon,dlat,varargin)
% Calculate surface area of grid-cell on fixed spherical grid
%
% [xc,yc,xf,yf,DXF,DYF,zA]=grid_sphere(dlon,dlat,lon0,lat0);
% I get this at: http://mitgcm.org/cgi-bin/viewcvs.cgi/preprocess/

% Constants
Aearth=6370e3;

if nargin <=2
 lon0=0;
else
 lon0=varargin{1};
end
if nargin <= 3
 lat0=-90;
else
 lat0=varargin{2};
end
if prod(size(dlon)) == 1
 nx=round( 360/dlon );
 ddlon=dlon*ones([nx 1]);
else
 nx=prod(size(dlon));
 ddlon=reshape( dlon ,[nx 1]);
end
if prod(size(dlat)) == 1
 ny=round( (90-lat0)/dlat );
 ddlat=dlon*ones([1 ny]);
else
 ny=prod(size(dlat));
 ddlat=reshape( dlat ,[1 ny]);
end

% Coordinates
xf=cumsum([lon0 ddlon']');
yf=cumsum([lat0 ddlat]);
xc=(xf(1:end-1)+xf(2:end))/2;
yc=(yf(1:end-1)+yf(2:end))/2;

if nargout <=4
 return
end

% Convert to radians
ddlon=ddlon*pi/180;
ddlat=ddlat*pi/180;

% Physical lengths only grid-cell edges
[DXF,DYF]=ndgrid(Aearth*ddlon,Aearth*ddlat);
DXF=Aearth*(ddlon*cos(pi/180*yc));

if nargout <=5
 return
end

% Surface area of grid-cell
zA=Aearth^2*( ddlon * ( sin( pi/180*yf(2:end) )-sin( pi/180*yf(1:end-1) ) ) );

xf=xf(1:end-1);
yf=yf(1:end-1);
