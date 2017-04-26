% diagHatisoC Compute iso-surface of a 3D field
%
% [H,[dH,h,dh]] = diagHatisoC(C,Z,isoC,[dC])
%
% Given the 3D field C(depth,n1,n2) and the vertical
% axis Z(<0,downward), this function computes the 2D 
% iso-surface such like C(H or h) = isoC
% Eventualy computes a thickness with parameter dC.
%
% OUTPUTS:
% H(n1,n2)  is the depth determined with the input resolution
% dH(n1,n2) is the thickness of the layer: isoC-dC < C < isoC+dC from H
% h(n1,n2)  is a more accurate depth (determined with interpolation)
% dh(n1,n2) is the interpolated thickness of the layer: isoC-dC < C < isoC+dC from h
%
% Created: 2007-06.
% Revised: 2016-08-17 (G. Maze) Added the case where isoC would bi-dimensional
% Copyright (c) 2007-2009 Guillaume Maze.
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or an1 later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = diagHatisoC(C,Z,isoC,varargin)

%- PREPROC
[nz,n1,n2] = size(C);
H  = zeros(n1,n2).*NaN;
dH = zeros(n1,n2).*NaN;
h  = zeros(n1,n2).*NaN;
dh = zeros(n1,n2).*NaN;
z  = [0:-1:Z(end)]; % Vertical axis of the interpolated depth

if nargin == 4
  dC = varargin{1};
end

%- COMPUTING
ws = warning;
warning off
switch numel(isoC)
	case 1 %-- Iso surface does not depend on n1/n2 (classic case)
		for i1 = 1 : n1
			for i2 = 1 : n2
				c = squeeze(C(:,i1,i2))';
				if isnan(c(1)) ~= 1
					if length(find(c>=isoC))>0 & length(find(c<=isoC))>0

						%-- Raw depth
						[cm icm] = min(abs(abs(c)-abs(isoC)));
						H(i1,i2) = Z(icm);

						if nargout >= 2 & nargin == 4
							%-- Raw thickness
							[cm icm1] = min(abs(abs(c)-abs(isoC+dC)));
							[cm icm2] = min(abs(abs(c)-abs(isoC-dC)));
							dH(i1,i2) = max(Z([icm1 icm2])) - min(Z([icm1 icm2]));
						end% if  

						if nargout >= 3
							%-- Interp depth
							cc = feval(@interp1,Z,c,z,'linear');
							[cm icm] = min(abs(abs(cc)-abs(isoC)));
							h(i1,i2) = z(icm);
						end% if  

						if nargout >= 4 & nargin == 4
							%-- Interp thickness
							[cm icm1] = min(abs(abs(cc)-abs(isoC+dC)));
							[cm icm2] = min(abs(abs(cc)-abs(isoC-dC)));
							dh(i1,i2) = max(z([icm1 icm2])) - min(z([icm1 icm2]));
						end% if  

					end % if found range value in the profile
				end % if point in the ocean
			end% for i2
		end% for i1
		
	otherwise %-- Iso surface depends on n1/n2
		for i1 = 1 : n1
			for i2 = 1 : n2
				c = squeeze(C(:,i1,i2))';
				if isnan(c(1)) ~= 1
					if length(find(c>=isoC(i1,i2)))>0 & length(find(c<=isoC(i1,i2)))>0

						%-- Raw depth
						[cm icm] = min(abs(abs(c)-abs(isoC(i1,i2))));
						H(i1,i2) = Z(icm);

						if nargout >= 2 & nargin == 4
							%-- Raw thickness
							[cm icm1] = min(abs(abs(c)-abs(isoC(i1,i2)+dC)));
							[cm icm2] = min(abs(abs(c)-abs(isoC(i1,i2)-dC)));
							dH(i1,i2) = max(Z([icm1 icm2])) - min(Z([icm1 icm2]));
						end% if  

						if nargout >= 3
							%-- Interp depth
							cc = feval(@interp1,Z,c,z,'linear');
							[cm icm] = min(abs(abs(cc)-abs(isoC(i1,i2))));
							h(i1,i2) = z(icm);
						end% if  

						if nargout >= 4 & nargin == 4
							%-- Interp thickness
							[cm icm1] = min(abs(abs(cc)-abs(isoC(i1,i2)+dC)));
							[cm icm2] = min(abs(abs(cc)-abs(isoC(i1,i2)-dC)));
							dh(i1,i2) = max(z([icm1 icm2])) - min(z([icm1 icm2]));
						end% if  

					end % if found range value in the profile
				end % if point in the ocean
			end% for i2
		end% for i1
warning(ws); % Restore warning state
end% switch 

%- OUTPUTS
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
end% switch 






end %function