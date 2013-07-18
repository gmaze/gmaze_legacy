% getdV Compute 3D volume elements matrix
%
% dV = getdV(DEPTH,LATITUDE,LONGITUDE)
%
% Compute 3D volume elements matrix from geographical
% axis DEPTH(<0,downward), LATITUDE(northward) and
% LONGITUDE(eastward)
%
% Created: 2009-04-21.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function DV = getdV(Z,Y,X,varargin)

	nz = length(Z);
	ny = length(Y);
	nx = length(X);

	DV = zeros(nz,ny,nx);

	n = nargin - 3;
	if n >= 1 
		issym = varargin{1};
	else
		issym = 0;
	end% if 

	% Vertical elements:
	for iz = 1 : nz % Toward the deep ocean (because DPT<0)
		% Vertical grid length centered at Z(iy)
		if iz == 1
	  	  dz = abs(Z(1)) + abs(sum(diff(Z(iz:iz+1))/2));
		elseif iz == nz % We don't know the real ocean depth
	  	  dz = abs(sum(diff(Z(iz-1:iz))/2));
		else
	  	  dz = abs(sum(diff(Z(iz-1:iz+1))/2));
	    end
		DZ(iz) = dz;
	end

	% Surface and Volume elements:
	if 0
		for ix = 1 : nx
		  for iy = 1 : ny
		      % Zonal grid length centered in X(ix),Y(iY)
		      if ix == 1
	%	         dx = abs(m_lldist([X(ix) X(ix+1)],[1 1]*Y(iy)))/2;
		         dx = abs(lldist([1 1]*Y(iy),[X(ix) X(ix+1)]))/2;
		      elseif ix == nx 
	%	         dx = abs(m_lldist([X(ix-1) X(ix)],[1 1]*Y(iy)))/2;
		         dx = abs(lldist([1 1]*Y(iy),[X(ix-1) X(ix)]))/2;
		      else
	%	         dx = abs(m_lldist([X(ix-1) X(ix)],[1 1]*Y(iy)))/2+abs(m_lldist([X(ix) X(ix+1)],[1 1]*Y(iy)))/2;
		         dx = abs(lldist([1 1]*Y(iy),[X(ix-1) X(ix)]))/2 + abs(lldist([1 1]*Y(iy),[X(ix) X(ix+1)]))/2;
		      end	

		      % Meridional grid length centered in X(ix),Y(iY)
		      if iy == 1
	%	        dy = abs(m_lldist([1 1]*X(ix),[Y(iy) Y(iy+1)]))/2;
		        dy = abs(lldist([Y(iy) Y(iy+1)],[1 1]*X(ix)))/2;
		      elseif iy == ny
	%	        dy = abs(m_lldist([1 1]*X(ix),[Y(iy-1) Y(iy)]))/2;
		        dy = abs(lldist([Y(iy-1) Y(iy)],[1 1]*X(ix)))/2;
		      else	
	%	        dy = abs(m_lldist([1 1]*X(ix),[Y(iy-1) Y(iy)]))/2+abs(m_lldist([1 1]*X(ix),[Y(iy) Y(iy+1)]))/2;
		        dy = abs(lldist([Y(iy-1) Y(iy)],[1 1]*X(ix)))/2 + abs(lldist([Y(iy) Y(iy+1)],[1 1]*X(ix)))/2;
		      end

		      % Surface element:
		      DA = dx*dy.*ones(1,nz);

		      % Volume element:
		      DV(:,iy,ix) = DZ.*DA;
		  end %for iy
		end %for ix

	else
		x  = [X(1)-diff(X(1:2)) ; X ; X(end)+diff(X(end-1:end))];        x = x(1:end-1)+diff(x)/2;
		y  = [Y(1)-diff(Y(1:2)) ; Y(1:end) ; Y(end)+diff(Y(end-1:end))]; y = y(1:end-1)+diff(y)/2;		
		dS = getdS(y,x,issym); % dx*dy centered in X,Y

		[a b ] = meshgrid(dS,DZ);
		a = reshape(a,[nz ny nx]);
		b = reshape(b,[nz ny nx]);
		DV = a.*b;		
	end
end %function








