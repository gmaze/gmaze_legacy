% convX Convert longitude convention
%
% lon = convX(lon,[idconv])
% 
% Convert longitude from one convention to another:
% Inputs:
% 	lon: The longitudes to convert (any dimensions)
% 	idconv:	One of the following:
% 		1 (default): Convert to longitude East, ie: 0 < lon < 360
% 		0: Convert to longitude East/West, ie: -180 < lon < 180
%
% Created: 2013-02-21.
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

function varargout = convX(x,varargin)

%- Default:
convention = 1;

%- User:
if nargin == 2
	if isempty(isin(varargin{1},[2 1 0]))
		error('Bad convention ID')
	else
		convention = varargin{1};
	end% if 
end% if 

%- Action:
switch convention
	% Move to longitude east: ie from 0 to 360
	case 1 
		x(x>=-180 & x<0) = 360 + x(x>=-180 & x<0); 		
		ix = 1 : length(x);
		
	% Move to longitude west/east: ie from -180 to 180	
	case 0 
		x(x>180 & x<=360) = x(x>180 & x<=360) - 360;
		ix = 1 : length(x);
		
	% Move to longitude east: ie from 0 to 360
	% and ensure long are sorted (so long can get higher than 360)
	case 2
		x(x>=-180 & x<0) = 360 + x(x>=-180 & x<0); 		
		[x ix] = sort(x);



end% switch

%- Return
varargout(1) = {x};
varargout(2) = {ix};

end %functionconvX