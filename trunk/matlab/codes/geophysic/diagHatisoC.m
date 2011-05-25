% diagHatisoC Compute iso-surface of a 3D field
%
% [H,[dH,h,dh]] = diagHatisoC(C,Z,isoC,[dC])
%
% Given the 3D field C(depth,lat,lon) and the vertical
% axis Z(<0,downward), this function computes the 2D 
% iso-surface such like C(H or h) = isoC
% Eventualy computes a thickness with parameter dC.
%
% OUTPUTS:
% H(lat,lon)  is the depth determined with the input resolution
% dH(lat,lon) is the thickness of the layer: isoC-dC < C < isoC+dC from H
% h(lat,lon) is a more accurate depth (determined with interpolation)
% dh(lat,lon) is the interpolated thickness of the layer: isoC-dC < C < isoC+dC from h
%
% Created: 2007-06.
% Copyright (c) 2007-2009 Guillaume Maze.
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = diagHatisoC(C,Z,isoC,varargin)

% 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROC
[nz,ny,nx] = size(C);
H  = zeros(ny,nx).*NaN;
dH = zeros(ny,nx).*NaN;
h  = zeros(ny,nx).*NaN;
dh = zeros(ny,nx).*NaN;
z  = [0:-1:Z(end)]; % Vertical axis of the interpolated depth

if nargin == 4
  dC = varargin{1};
end

% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTING
warning off
 for ix = 1 : nx
   for iy = 1 : ny
     c = squeeze(C(:,iy,ix))';   
     if isnan(c(1)) ~= 1
     if length(find(c>=isoC))>0 & length(find(c<=isoC))>0
	
        % Raw value of depth:
	[cm icm] = min(abs(abs(c)-abs(isoC)));
        H(iy,ix) = Z(icm);
	
	if nargout >= 2 & nargin == 4
	  % raw thickness
   	   [cm icm1] = min(abs(abs(c)-abs(isoC+dC)));
   	   [cm icm2] = min(abs(abs(c)-abs(isoC-dC)));
           dH(iy,ix) = max(Z([icm1 icm2])) - min(Z([icm1 icm2]));
	end 
	
	if nargout >= 3
          % Interp guess of depth:
          cc = feval(@interp1,Z,c,z,'linear');
	  [cm icm] = min(abs(abs(cc)-abs(isoC)));
          h(iy,ix) = z(icm);
	end 
	
	if nargout >= 4 & nargin == 4
          % Interp guess of thickness:
   	      [cm icm1] = min(abs(abs(cc)-abs(isoC+dC)));
   	      [cm icm2] = min(abs(abs(cc)-abs(isoC-dC)));
              dh(iy,ix) = max(z([icm1 icm2])) - min(z([icm1 icm2]));
	end 
	
     end % if found value in the profile
     end % if point n ocean
   end
 end
warning on 
 
% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
switch nargout
 case 1
  varargout(1) = {H};
 case 2
  varargout(1) = {H};
  varargout(2) = {dH};
 case 3
  varargout(1) = {H};
  varargout(2) = {dH};
  varargout(3) = {h};
 case 4
  varargout(1) = {H};
  varargout(2) = {dH};
  varargout(3) = {h};
  varargout(4) = {dh};
end





end %function