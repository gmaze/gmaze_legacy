% datenumserie_forbins H1LINE
%
% [] = datenumserie_forbins()
% 
% HELPTEXT
%
% Created: 2013-12-19.
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

function varargout = datenumserie_forbins(BLEVEL,Y,MO,varargin)
stophere
D  = 1;
H  = 0;
MI = 0;
SE = 0;

switch nargin
	case 4
		D = varargin{1};
	case 5
		D = varargin{1};
		H = varargin{2};
	case 6
		D  = varargin{1};
		H  = varargin{2};
		MI = varargin{3};
	case 7
		D  = varargin{1};
		H  = varargin{2};
		MI = varargin{3};
		SE = varargin{4};
end% switch 

it = 0;
for iy = 1 : length(Y)
	for im = 1 : length(MO)
		for id = 1 : length(D)
			for ih = 1 : length(H)
				for imi = 1 : length(MI)
					for is = 1 : length(SE)
						it = it + 1;
						N(it) = datenum(Y(iy),MO(im),D(id),H(ih),MI(imi),SE(is));
					end% for is
				end% for imi
			end% for ih
		end% for id
	end% for im
end% for iy


end %functiondatenumserie_forbins