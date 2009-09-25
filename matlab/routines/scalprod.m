% scalprod Cross or dot product of two 3D scalar fields
%
% [a1,a2,a3] = scalprod(DZ,DY,DX,A,B,WPROD)
% 
% Compute either the cross or dot products of the two
% scalar fields A and B.
% A and B are of dimensions: (NZ,NY,NX)
% DX,DY,DZ are distances between A,B grid points
% 	DX: DX(NZ,NY,NX-1)
% 	DY: DY(NZ,NY-1,NX)
% 	DZ: DZ(NZ-1,NY,NX)
%
% WPROD is 1 or 'x' for the cross product
% then:
% 	Jx =   d(A)/dy.*d(B)/dz - d(A)/dz.*d(B)/dy;
% 	Jy = -(d(A)/dx.*d(B)/dz - d(A)/dz.*d(B)/dx);
% 	Jz =   d(A)/dx.*d(B)/dy - d(A)/dy.*d(B)/dx;
%
% WPROD is 2 or '.' for the dot product
% then:
% 	Jx =   d(A)/dx.*d(B)/dx
% 	Jy =   d(A)/dy.*d(B)/dy
% 	Jz =   d(A)/dz.*d(B)/dz
%
% Vector components a1,a2 and a3 are given back on the 
% same grid as A and B.
% Outputs depend on the number of fields asked and on WPROD:
% For WPROD a CROSS PRODUCT:
% 	a1 only		: a1=Jz, ie the curl
% 	a1,a2 only	: a1=Jy, a2=Jx
% 	a1,a2,a3	: a1=Jz, a2=Jy, a3=Jx
% For WPROD a DOT PRODUCT:
% 	a1 only		: a1=Jx+Jy+Jz
% 	a1,a2 only	: a1=Jy, a2=Jx
% 	a1,a2,a3	: a1=Jz, a2=Jy, a3=Jx
%
% Created: 2008-12-14.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = scalprod(varargin)

%%%%%%%%%%%%%%%%%%% INPUTS:
ddpt  = varargin{1};
dlat  = varargin{2};
dlon  = varargin{3};
C1    = varargin{4};
C2    = varargin{5};
wprod = varargin{6};
if isnumeric(wprod)
	switch wprod
		case 1 % Cross product
			wprod = 'x';
		case 2 % Dot product
			wprod = '.';
	end
end

	missV = Inf;
	C1(isnan(C1)) = missV;
	C2(isnan(C2)) = missV;


%%%%%%%%%%%%%%%%%%% Product:
switch wprod
	case 'x'   % Cross product
		[Jx Jy Jz] = crossproduct(dlon,dlat,ddpt,C1,C2,missV);
	case '.'   % Dot product
		[Jx Jy Jz] = dotproduct(dlon,dlat,ddpt,C1,C2,missV);
end


%%%%%%%%%%%%%%%%%%% Output:
switch wprod
	case 'x'
		switch nargout
			case 1
				varargout(1) = {Jz};
			case 2
				varargout(1) = {Jy};
				varargout(2) = {Jx};
			case 3
				varargout(1) = {Jz};
				varargout(2) = {Jy};
				varargout(3) = {Jx};		
		end

	case '.'
		switch nargout
			case 1
				varargout(1) = {Jx+Jy+Jz};
			case 2
				varargout(1) = {Jy};
				varargout(2) = {Jx};
			case 3
				varargout(1) = {Jz};
				varargout(2) = {Jy};
				varargout(3) = {Jx};		
		end
end %switch
	
end %function







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Jx Jy Jz] = dotproduct(dlon,dlat,ddpt,C1,C2,missV)
	
	[ndpt nlat nlon] = size(C1);	
	
	% Gradient of field 1:
	[dC1dx dC1dy dC1dz] = grad(dlon,dlat,ddpt,C1);

	% Gradient of field 2:
	[dC2dx dC2dy dC2dz] = grad(dlon,dlat,ddpt,C2);

	% Components of the cross product on the Zeta-W grid:
	Jx = dC1dx.*dC2dx;
	Jy = dC1dy.*dC2dy;
	Jz = dC1dz.*dC2dz;
	
	% Move back to the tracer grid:
	Jx = ZETAWtoTT(ndpt,nlat,nlon,Jx);
	Jy = ZETAWtoTT(ndpt,nlat,nlon,Jy);
	Jz = ZETAWtoTT(ndpt,nlat,nlon,Jz);

	% Clean mask:
	mask = ones(ndpt,nlat,nlon);
	mask(C1==missV) = NaN;
	mask(C2==missV) = NaN;
	[a b c] = grad(ones(ndpt,nlat,nlon-1),ones(ndpt,nlat-1,nlon),ones(ndpt-1,nlat,nlon),mask);
	mask = ZETAWtoTT(ndpt,nlat,nlon,a+b+c);
	mask(mask==0) = 1;

	% Clean output:
	Jx = Jx.*mask;
	Jy = Jy.*mask;
	Jz = Jz.*mask;
	
end %subfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Jx Jy Jz] = crossproduct(dlon,dlat,ddpt,C1,C2,missV)
	
	[ndpt nlat nlon] = size(C1);	
	
	% Gradient of field 1:
	[dC1dx dC1dy dC1dz] = grad(dlon,dlat,ddpt,C1);

	% Gradient of field 2:
	[dC2dx dC2dy dC2dz] = grad(dlon,dlat,ddpt,C2);

	% Components of the cross product on the Zeta-W grid:
	Jx =   dC2dy.*dC1dz - dC2dz.*dC1dy;
	Jy = -(dC2dx.*dC1dz - dC2dz.*dC1dx);
	Jz =   dC2dx.*dC1dy - dC2dy.*dC1dx;
	
	% Move back to the tracer grid:
	Jx = ZETAWtoTT(ndpt,nlat,nlon,Jx);
	Jy = ZETAWtoTT(ndpt,nlat,nlon,Jy);
	Jz = ZETAWtoTT(ndpt,nlat,nlon,Jz);

	% Clean mask:
	mask = ones(ndpt,nlat,nlon);
	mask(C1==missV) = NaN;
	mask(C2==missV) = NaN;
	[a b c] = grad(ones(ndpt,nlat,nlon-1),ones(ndpt,nlat-1,nlon),ones(ndpt-1,nlat,nlon),mask);
	mask = ZETAWtoTT(ndpt,nlat,nlon,a+b+c);
	mask(mask==0) = 1;

	% Clean output:
	Jx = Jx.*mask;
	Jy = Jy.*mask;
	Jz = Jz.*mask;
	
end %subfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dcdx dcdy dcdz] = grad(dlon,dlat,ddpt,c);

	
	dcdx = (c(:,:,2:end)-c(:,:,1:end-1))./dlon; % U-T grid
	dcdx = (dcdx(:,1:end-1,:) + dcdx(:,2:end,:))/2; % Zeta-T grid
	dcdx = (dcdx(1:end-1,:,:) + dcdx(2:end,:,:))/2; % Zeta-W grid

	dcdy = (c(:,2:end,:)-c(:,1:end-1,:))./dlat; % V-T grid
	dcdy = (dcdy(:,:,1:end-1) + dcdy(:,:,2:end))/2; % Zeta-T grid
	dcdy = (dcdy(1:end-1,:,:) + dcdy(2:end,:,:))/2; % Zeta-W grid

	dcdz = (c(1:end-1,:,:) - c(2:end,:,:))./ddpt; % T-W grid
	dcdz = (dcdz(:,1:end-1,:) + dcdz(:,2:end,:))/2; % V-W grid
	dcdz = (dcdz(:,:,1:end-1) + dcdz(:,:,2:end))/2; % Zeta-W grid


end %subfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C = ZETAWtoTT(ndpt,nlat,nlon,C);
	
	% C is in Zeta-W grid
	C = (C(:,1:end-1,:) + C(:,2:end,:))/2; % U-W grid
	C = (C(:,:,1:end-1) + C(:,:,2:end))/2; % T-W grid
	C = (C(1:end-1,:,:) + C(2:end,:,:))/2; % T-T grid
	
	% Concat with NaN to have same dimensions as in input
	C = cat(1,zeros(1,nlat-2,nlon-2).*NaN,C,zeros(1,nlat-2,nlon-2).*NaN);
	C = cat(2,zeros(ndpt,1,nlon-2).*NaN,C,zeros(ndpt,1,nlon-2).*NaN);
	C = cat(3,zeros(ndpt,nlat,1).*NaN,C,zeros(ndpt,nlat,1).*NaN);

end %subfunction







