% project3don2d Project a 3D field on a 2D surface
%
% C = projetc3don2d(Z,THREEDFIELD,TWODSURFACE)
% [Cup Cdw] = projetc3don2d(Z,THREEDFIELD,TWODSURFACE)
% [C Cup Cdw] = projetc3don2d(Z,THREEDFIELD,TWODSURFACE)
%
% Given the vertical axis Z, project the 3D variable THREEDFIELD on the
% 2D surface variable TWODSURFACE.
%
% Inputs:
%	'Z' is positive and oriented from the surface to the bottom.
%	'THREEDFIELD' is of size (NZ,N1,N2).
%	'TWODSURFACE' is of size (N1,N2) with positive values defined along 'Z'.
%
% Outputs:
%	'C' is the projected field.
%	'Cup' is the projection of the upper index.
%	'Cdw' is the projection of the lower index.
%
% Rq:
%	For any given point, the TWODSURFACE falls in between two index of the
%	Z axis (iZup and iZdw). 'Cup' and 'Cdw' are the THREEDFIELD values on 
%	these indeces and C is the linear interpolation at the TWODSURFACE level.
%
% Created: 2011-06-23.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = project3don2d(z,THREEDFIELD,TWODSURFACE)

%- Inputs:
z = z(:);
[nz n1 n2] = size(THREEDFIELD);
[n1b n2b]  = size(TWODSURFACE);

if n1~= n1b | n2~=n2b
	error('THREEDFIELD and TWODSURFACE must have similar horizontal dimensions')
end% if 
clear n1b n2b

%- Move vertical index and axis in 3D:
H = meshgrid(TWODSURFACE,1:nz); H = reshape(H,[nz n1 n2]);
[Z a a] = meshgrid(z,1:n1,1:n2); clear a; Z = permute(Z,[2 1 3]);

%- Find upper index of the surface:
[izup a a] = meshgrid(ones(1,nz),1:n1,1:n2);clear a; izup = permute(izup,[2 1 3]);
izup(Z>H) = 0;
izup = circshift(izup,-1) + izup;
izup(nz,:,:) = 0;
izup(izup~=1) = NaN;

%- Find lower index of the surface:
[izdw a a] = meshgrid(ones(1,nz),1:n1,1:n2);clear a; izdw = permute(izdw,[2 1 3]);
izdw(Z<=H) = 0;
izdw = circshift(izdw,1) + izdw;
izdw(1,:,:) = 0;
izdw(izdw~=1) = NaN;

%- Projet 3D field on 2D surface:
Cup = squeeze(nanmean(THREEDFIELD.*izup));
Cdw = squeeze(nanmean(THREEDFIELD.*izdw));

%- Interpolate:
switch nargout
	case {1,3}
		dZ = cat(1,diff(Z),ones(1,n1,n2)*NaN);
		dZ = squeeze(nanmean(dZ.*izup));
		a = squeeze(nanmean(H-Z.*izup));
		b = squeeze(nanmean(abs(H-Z.*izdw)));
		C = (Cup.*b + Cdw.*a)./dZ;
	otherwise
		% Don't need to interpolate
end% switch 


%- Outputs:
switch nargout
	case 1
		varargout(1) = {C};
	case 2
		varargout(1) = {Cup};
		varargout(2) = {Cdw};
	case 3
		varargout(1) = {C};
		varargout(2) = {Cup};
		varargout(3) = {Cdw};
end% switch 


end %functionprocjet3don2d



























