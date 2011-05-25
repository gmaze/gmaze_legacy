% sphgrad Compute zonal/meridional gradients on the sphere
%
% [dCdx dCdy dCsq dx dy] = sphgrad(C,Cy,Cx,inplace,xper)
% 
% Compute zonal/meridional gradients on the sphere of field C
%
% Inputs: 
%	- C(length(Cy),length(Cx)) is the 2D field
%	- Cy(1,size(C,1)) is the latitude
%	- Cx(1,size(C,2)) is the longitude
%	- inplace is 0 or 1. This option indicates if the outputs are
%	the be moved back on the original grid or not
%	- xper is 0 or 1. This option indicates if the domain is periodic
%	in the zonal (Cx) direction. In this case, the distance between the first
%	and the last point of the axis is computed between Cx(end) and Cx(1)+360.
%
% Outputs with:
% 		NY = size(C,1)
% 		NX = size(C,2)
%	- dCdx is the zonal gradient.
%		If xper = 0:
%			If inplace = 0: dCdx = [NY,NX-1]
%			If inplace = 1: dCdx = [NY NX] with dCdx(:,[1 END]) = 9999
%		If xper = 1: dCdx = [NY,NX]
%
%	- dCdy is the meridional gradient.
%		If inplace = 0: dCdy = [NY-1,NX]
%		If inplace = 1: dCdy = [NY,NX] with dCdy([1 END],:) = 9999
%
%	- dCsq[NY,NX] = dCdx^2 + dCdy^2 is filled with 9999 except when inplace = 1
%	- dx[NY,NX-1] is the zonal distance between points ([NY,NX] if xper=1)
%	- dy[NY-1,NX] is the meridional distance between points
%
% Rq: This function is a MEX-file, see mymex/sphgrad.F90 for more details	
%
% Created: 2009-10-20.
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specifi% prior 
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