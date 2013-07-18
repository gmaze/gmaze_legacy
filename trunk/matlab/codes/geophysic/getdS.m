% getdS Compute 2D surface elements matrix
%
% [dS, dx, dy] = getdS(LATITUDE,LONGITUDE,[ISSYM,METHOD])
%
% Compute 2D surface elements matrix from geographical
% axis LATITUDE(northward) and LONGITUDE(eastward)
% 
% Options:
%	ISSYM = 0/1 indicates if the longitudinal axis is zonaly
%		symetric or not (by default it's not: 0)
%	METHOD = 1/2 indicates the method to use when computing
%		distances between points (see routine lldist). By
%		default it's 2.
%
% Created: 2009-09-14.
% Rev. by Guillaume Maze on 2009-09-30: Added dx,dy optional output
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = getdS(Y,X,varargin)
	
X = sort(X);
Y = sort(Y);
	
ny = length(Y);
nx = length(X);

DS = zeros(ny,nx);
DX = zeros(ny,nx);
DY = zeros(ny,nx);

n = nargin - 2;
if n >= 1 
	issym = varargin{1};
else
	issym = 0;
end
if n >= 2
	method = varargin{2};
else
	method = 2;
end

% Move to longitude east from 0 to 360	
X(X>=-180 & X<0) = 360 + X(X>=-180 & X<0);

% Is this grid regular ?
if sum(diff(X))/(nx-1) == diff(X(1:2)) && sum(diff(Y))/(ny-1) == diff(Y(1:2)) % yep !
	warning('This grid is regular')
	[DS DY DX] = go_method2(X,Y,diff(X(1:2)),diff(Y(1:2)),issym);
else
	warning('This grid is not regular')
	[DS DY DX] = go_method1(X,Y,issym,method);
end		
	

switch nargout
	case 1
		varargout(1) = {DS};
	case 2
		varargout(1) = {DS};
		varargout(2) = {DX};
	case 3
		varargout(1) = {DS};
		varargout(2) = {DX};
		varargout(3) = {DY};
end		




end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DS DY DX] = go_method2(X,Y,DX,DY,issym);
		
	Xmin = X(1);
	Xmax = X(end);
	Ymin = Y(1);
	Ymax = Y(end);	
		
  [LON,LAT,LONG,LATG,DLON,DLAT,zA,DLONG,DLATG] = mygrid_sphere(DX,DY);  
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
  [ix1 ix2 iy1 iy2];
  ixc = ix1:1:ix2;
  iyc = iy1:1:iy2;

  LAT   =  LAT(iyc);
  DLAT  = DLAT(ixc,iyc(1:end-1))';
  LATG  =  LATG(iyc(1):iyc(end)+1);
  DLATG = DLATG(ixc,iyc)'; 
  LON   =  LON(ixc); LON = LON';
%  DLON  = DLON(ixc(1:end-1),iyc)';

	if issym
		DX = DLON(ixc,iyc)';
	else
		DX = DLON(ixc(1:end-1),iyc)';
	end
  LONG  =  LONG(ixc(1):ixc(end)+1); LONG = LONG';
  DLONG = DLONG(ixc,iyc)';
	
%	DX = DLON;
	DY = DLAT;
	if issym		
		DS = zA(ixc,iyc)';
	else
		DS = zA(ixc(1:end-1),iyc(1:end-1))';
	end
%	DS = zA(:,iyc)';
	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DS DY DX] = go_method1(X,Y,issym,method);
	
ny = length(Y);
nx = length(X);

DS = zeros(ny,nx);
DX = zeros(ny,nx);
DY = zeros(ny,nx);

% Surface elements:
for ix = 1 : nx
	for iy = 1 : ny
		
		% Zonal grid size centered in X(ix),Y(iY)
		if ix == 1
			switch issym
				case 0
					dx = abs(lldist([1 1]*Y(iy),[X(1) X(2)],method));					
				case 1
					dx = abs(lldist([1 1]*Y(iy),[X(end) X(1)+360],method))/2 + abs(lldist([1 1]*Y(iy),[X(1) X(2)],method))/2 ;
			end
		elseif ix == nx 
			switch issym
				case 0
					dx = abs(lldist([1 1]*Y(iy),[X(nx-1) X(nx)],method));
				case 1
					dx = abs(lldist([1 1]*Y(iy),[X(end) X(1)+360],method))/2 + abs(lldist([1 1]*Y(iy),[X(nx-1) X(nx)],method))/2 ;
			end
		else
			dx = abs(lldist([1 1]*Y(iy),[X(ix-1) X(ix)],method))/2+abs(lldist([1 1]*Y(iy),[X(ix) X(ix+1)],method))/2;
		end	
		DX(iy,ix) = dx;

		% Meridional grid size centered in X(ix),Y(iY)
		if iy == 1
			dy = abs(lldist([Y(iy) Y(iy+1)],[1 1]*X(ix),method));
		elseif iy == ny
			dy = abs(lldist([Y(iy-1) Y(iy)],[1 1]*X(ix),method));
		else	
			dy = abs(lldist([Y(iy-1) Y(iy)],[1 1]*X(ix),method))/2+abs(lldist([Y(iy) Y(iy+1)],[1 1]*X(ix),method))/2;
		end
		DY(iy,ix) = dy;
		
		% Surface element:
		DS(iy,ix) = dx*dy;

	end %for iy
end %for ix

end%function