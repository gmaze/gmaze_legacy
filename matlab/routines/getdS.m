% getdS Compute 3D volume elements matrix
%
% dS = getdS(LATITUDE,LONGITUDE)
%
% Compute 2D surface elements matrix from geographical
% axis LATITUDE(northward) and LONGITUDE(eastward)
%
% Created: 2009-09-14.
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

function DS = getdS(Y,X)
	
ny = length(Y);
nx = length(X);

DS = zeros(ny,nx);

% Surface elements:
for ix = 1 : nx
  for iy = 1 : ny
      % Zonal grid length centered in X(ix),Y(iY)
      if ix == 1
         dx = abs(m_lldist([X(ix) X(ix+1)],[1 1]*Y(iy)))/2;
      elseif ix == nx 
         dx = abs(m_lldist([X(ix-1) X(ix)],[1 1]*Y(iy)))/2;
      else
         dx = abs(m_lldist([X(ix-1) X(ix)],[1 1]*Y(iy)))/2+abs(m_lldist([X(ix) X(ix+1)],[1 1]*Y(iy)))/2;
      end	

      % Meridional grid length centered in X(ix),Y(iY)
      if iy == 1
        dy = abs(m_lldist([1 1]*X(ix),[Y(iy) Y(iy+1)]))/2;
      elseif iy == ny
        dy = abs(m_lldist([1 1]*X(ix),[Y(iy-1) Y(iy)]))/2;
      else	
        dy = abs(m_lldist([1 1]*X(ix),[Y(iy-1) Y(iy)]))/2+abs(m_lldist([1 1]*X(ix),[Y(iy) Y(iy+1)]))/2;
      end

      % Surface element:
      DS(iy,ix) = dx*dy;

  end %for iy
end %for ix






end %function