% rotatepolygon H1LINE
%
% [PX PY] = rotatepolygon(px,py,alpha,[X0,Y0])
% 
% HELPTEXT
%
% Created: 2010-08-25.
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

function [PX PY] = rotatepolygon(varargin)

px = varargin{1};
py = varargin{2};
alpha = varargin{3};
if nargin == 4
	CENTER = varargin{4};
else
	CENTER = [0 0];
end

% Change coordinates:
px = px - CENTER(1);
py = py - CENTER(2);

alpha = alpha*pi/180; % deg 2 rad
for ip = 1 : length(px)
	PX(ip) = px(ip)*cos(alpha) + py(ip)*sin(alpha);
	PY(ip) = -px(ip)*sin(alpha) + py(ip)*cos(alpha);
end%for ip	

% Back to reference frame:
PX = PX + CENTER(1);
PY = PY + CENTER(2);	

end %functionrotatepolygon