% getdH Compute Layer thickness from a vertical axis
%
% dH = getdH(Z) Return the layer thickness for each level as
% the sum of half the upper and half the lower layers.
% 
% Created: 2013-07-22.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
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
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
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

function H = getdH(varargin)

Z = varargin{1};

%- Format input data as expected:
% negative and oriented from bottom to surface
Z = sort(-abs(Z(:)));

%-
nz  = length(Z);
Hup = zeros(nz,1)*NaN;
Hdw = zeros(nz,1)*NaN;

for iz = 1 : nz
	
	if iz < nz
		% Upper layer half thickness:
		Hup(iz) = (Z(iz+1)-Z(iz))/2;
	end% if 
	
	if iz > 1
		% Lower layer half thickness:
		Hdw(iz) = (Z(iz) - Z(iz-1))/2;
	end% if 

end% for iz
	
%- Layer thickness:
H = nansum([Hup , Hdw],2);

%-
H = reshape(H,size(varargin{1}));

end %functiongetdH












