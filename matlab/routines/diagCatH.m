% diagCatH Compute a 3D field projection on a 2D surface
%
% Ch = diagCatH(C,depth,h)
%
% Get field C(depth,lat,lon) on surface h(lat,lon)
%
% depth < 0 is the vertical axis
% h     < 0 is the surface
%
% Note: respect upper/lower case in the function name
%
% Created by Guillaume Maze on 2006/08
% Copyright (c) 2006-2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function varargout = diagCatH(C,Z,h)

% 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROC
[nz,ny,nx] = size(C);
Ch = zeros(ny,nx);

% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTING
warning off
 for ix = 1 : nx
   for iy = 1 : ny
		if ~isnan(C(1,iy,ix))
		     Ch(iy,ix) = interp1( Z, squeeze(C(:,iy,ix)) , h(iy,ix) , 'linear');
		end
   end
 end
warning on
 
% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
switch nargout
 case 1
  varargout(1) = {Ch};
end