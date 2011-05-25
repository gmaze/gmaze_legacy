% piston_velocity Compute a gaz air-sea interface transfer velocity (piston velocity)
%
% K = piston_velocity(GAZ,PARAMETERS)
% 
% Compute a gaz transfer velocitiy (piston velocity) for gaz GAZ.
% PARAMETERS depend on GAZ (see inputs here-after)
% 
% Inputs:
%	GAZ (string): the gaz to compute piston velocity for. In can be:
%		'OXY' for oxygen
%	PARAMETERS:
%		for GAZ = 'OXY':
%			SC: Schmidt number (see function schmidt_number)
%			U:  wind speed in m/s at 10m height
%			Here we use the Wanninkhof, 1992 formulation.
%
% Outputs:
%	K: gaz transfer velocity in m/s
%
% Created: 2010-06-28.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = piston_velocity(GAZ,varargin)

switch GAZ
	case 'OXY'
		k = piston_oxy(varargin{:});
		varargout(1) = {k};
	otherwise
		error('Unknown gaz')
end

end %functionpiston_velocity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Piston velocity following Wanninkhof, 1992
function kw = piston_oxy(varargin);
	
%%%%%% Load arguments:
% We expect:
%	'U' in m/s for the wind speed at 10m 	
%	'Sc' for the Schmidt number
for in = 1 : 2 : nargin
	eval(sprintf('%s = varargin{in+1};',varargin{in}));	
end%for in	

%%%%%% Constants:
% note that you may find cte = 0.39 cm/hour
K   = 0.31; % for short-term wind datas
%K   = 0.39; % for long-term climatological winds
cte = K/(3.6*1e5); % m/s

%%%%%% Piston velocity in m/s
kw = cte.*sqrt(Sc./660).*U.^2;


	
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



