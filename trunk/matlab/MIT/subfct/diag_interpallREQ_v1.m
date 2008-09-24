% NEWFIELD = diag_interpallREQ(FIELD,LON,LAT,netcdf_domain,resolution,...
%                              [grid])
%
% We interpolate linearly FIELD(LAT,LON) on a grid, independant of the dataset
% with a resolution on the domain netcdf_domain.
%
% [grid] = 'T' or 'U' or 'V'
% Indicate where the field is on the C-grid
% Default is 'T'
%
% Output is:
% [NEWFIELD,LON,LAT,DLON,DLAT]
%
% 2008/02/13
% gmaze@mit.edu

function varargout = diag_interpallREQ(varargin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Resolution:
dresol = varargin{5};
if nargin >= 6
  gridty = lower(varargin{6});
else
  gridty = 't';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Domain:
netcdf_domain = lower(varargin{4});
switch netcdf_domain
 case 'global'
  Xmin = 0.5;
  Xmax = 359.5;
  Ymin = -89.5;
  Ymax = 89.5;
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
 case 'kess'
  Xmin = 130.5;
  Xmax = 179.5;
  Ymin = 10.5;
  Ymax = 49.5;
 case 'southern_ocean'
  Xmin = 0.5;
  Xmax = 359.5;
  Ymin = -70.5;
  Ymax = -9.5;
end
%[Xmin Xmax Ymin Ymax]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load or create the grid:
filGRID = sprintf('GRIDC_COMMON_%s_%0.4g.mat',netcdf_domain,dresol);
if exist(filGRID,'file')
  switch gridty
   case 't'
    switch nargout
      case {1,2,3}
        load(filGRID,'LON','LAT');
      case {4,5}
        load(filGRID,'LON','LAT','DLON','DLAT');
    end	
   case 'u'
    switch nargout
      case {1,2,3}
        load(filGRID,'LONG','LAT');
      case {4,5}
        load(filGRID,'LONG','LAT','DLONG','DLAT');
    end	
   case 'v'
    switch nargout
      case {1,2,3}
        load(filGRID,'LON','LATG');
      case {4,5}
        load(filGRID,'LON','LATG','DLON','DLATG');
    end	
  end
  
else
  disp(sprintf('Common grid file over the domain: %s with a %3.4g resolution not found \n%s',...
	       netcdf_domain,dresol,'Generating a new one ...'));
  [LON,LAT,LONG,LATG,DLON,DLAT,zA,DLONG,DLATG] = mygrid_sphere(dresol,dresol);  
  ix1 = find(LON<=Xmin,1,'last');
  ix2 = find(LON<=Xmax,1,'last');
  if isempty(ix1)
    ix1 = find(LON>=Xmin,1,'first');
    if isempty(ix1)
      error('Couldn''t find domain limits in zonal direction, lower bound');
      return
    end
  end
  if isempty(ix2)
    ix2 = find(LON>=Xmax,1,'first');
    if isempty(ix2)
      error('Couldn''t find domain limits in zonal direction, upper bound');
      return
    end
  end  
  
  iy1 = find(LAT<=Ymin,1,'last');
  iy2 = find(LAT<=Ymax,1,'last');
  if isempty(iy1)
    iy1 = find(LAT>=Ymin,1,'first');
    if isempty(iy1)
      error('Couldn''t find domain limits in meridional direction, lower bound');
      return
    end
  end
  if isempty(iy2)
    iy2 = find(LAT>=Ymax,1,'first');
    if isempty(iy2)
      error('Couldn''t find domain limits in meridional direction, upper bound');
      return
    end
  end
  ixc = ix1:1:ix2;
  iyc = iy1:1:iy2;

  LAT   =  LAT(iyc);
  DLAT  = DLAT(ixc,iyc(1:end-1))';
  LATG  =  LATG(iyc(1):iyc(end)+1);
  DLATG = DLATG(ixc,iyc)'; 
  LON   =  LON(ixc); LON = LON';
  DLON  = DLON(ixc(1:end-1),iyc)';
  LONG  =  LONG(ixc(1):ixc(end)+1); LONG = LONG';
  DLONG = DLONG(ixc,iyc)';

  save(filGRID,'LON','LAT','DLON','DLAT','LONG','LATG','DLONG','DLATG','-v6');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Interpolate the field:
% Old grid:
lon = varargin{2};
lat = varargin{3};
lon = lon(:);
lat = lat(:);
field = varargin{1};
[lo la]  = meshgrid(lon,lat);

% New one:
switch gridty
  case 't'
    [LO LA]  = meshgrid(LON,LAT);
  case 'u'
    [LO LA]  = meshgrid(LONG,LAT);
  case 'v'
    [LO LA]  = meshgrid(LON,LATG);
end  

% Interpolation:
newfield = interp2(lo,la,field,LO,LA,'linear');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output:
varargout(1) = {newfield};
if nargout > 1

switch gridty
 case 't'
   if nargout>=2,varargout(2) = {LON}; end
   if nargout>=3,varargout(3) = {LAT}; end
   if nargout>=4,varargout(4) = {DLON}; end
   if nargout>=5,varargout(5) = {DLAT}; end
 case 'u'
   if nargout>=2,varargout(2) = {LONG}; end
   if nargout>=3,varargout(3) = {LAT};  end
   if nargout>=4,varargout(4) = {DLONG}; end
   if nargout>=5,varargout(5) = {DLAT}; end
 case 'v'
   if nargout>=2,varargout(2) = {LON}; end
   if nargout>=3,varargout(3) = {LATG}; end
   if nargout>=4,varargout(4) = {DLON}; end
   if nargout>=5,varargout(5) = {DLATG}; end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB FUNCTION

function [xc,yc,xf,yf,DXF,DYF,zA,DXC,DYC] = mygrid_sphere(dlon,dlat,varargin)

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
DXC=Aearth*(ddlon*cos(pi/180*yf));

% DYC ?
DYC = (DYF(:,1:end-1)+DYF(:,2:end))/2;
DYC = DYF;

if nargout <=5
 return
end

% Surface area of grid-cell
zA = Aearth^2*( ddlon * ( sin( pi/180*yf(2:end) )-sin( pi/180*yf(1:end-1) ) ) );

%xf=xf(1:end-1);
%yf=yf(1:end-1);
