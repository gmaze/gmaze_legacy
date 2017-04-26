% getdH Compute Layer thickness from a vertical axis
%
% [dH Zw dZw] = getdH(Z) Return the layer thickness of each level
% assuming that centers are at middle between interfaces.
% 
% Also return the interface depth (Zw) and interface distance (dZw)
% 
% Created: 2013-07-22.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org
% Revised: 2014-10-08 (G. Maze) Now ensure that the output is sorted like the input
% Revised: 2016-04-28 (G. Maze) Modified the code to assume centers at middle between interfaces

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

function varargout = getdH(varargin)


if 0 %- Classic old method
	
	Z = varargin{1};

	%-- Format input data as expected:
	% negative and oriented from bottom to surface
	[Z isort] = sort(-abs(Z(:)));
	
	
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
	
	%-- Layer thickness:
	H = nansum([Hup , Hdw],2);

	%-- 
	H = H(isort);
	H = reshape(H,size(varargin{1}));
	varargout(1) = {H};
	return
	
else %- Correct method assuming centers at middle between interfaces
	
	RC = varargin{1};
	% assume axis negative and oriented from bottom to surface
	[Z isort] = sort(-abs(RC(:)));
	nr = length(RC);

	% Compute drc and rc from dpt:
	drc = [abs(RC(1));RC(1:end-1)-RC(2:end)]; 
	rc(1)=drc(1); for k=2:nr, rc(k) = rc(k-1) + drc(k); end 

	% Assume centers at middle between interfaces
	rf(1) = 0; % Sea level
	rf(2) = 2*drc(1);
	for k=2:nr
		drf(k) = 2*(rc(k) - rf(k));
		rf(k+1) = rc(k) + 0.5*drf(k);
	end% for k

	% The other choice is to assume interface at middle between 2 centers:
	% rf(1) = 0; % Sea Level
	% for k = 2 : nr
	% 	rf(k) = rc(k) - 0.5*drc(k);
	% end% for k
	% rf(k+1) = rc(k) + drc(k) - 0.5*drc(k); % from RF.data = DPTW
	% drf = abs([rf(1),rf(1:end-1)-rf(2:end)]); % from DRF.data = DDPTW

	varargout(1) = {drc};
	varargout(2) = {rf'};
	varargout(3) = {drf'};
	
end% if 

end %functiongetdH












