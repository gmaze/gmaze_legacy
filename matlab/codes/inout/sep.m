% sep Draw/Create a horizontal line on the terminal
%
% STRING = sep([TYPE,TITLE])
% 
% Draw a horizontal block separator line on the terminal.
% By use the character TYPE: '-'.
% Eventually center a title in the line with string TITLE.
% If no output, directly display the line.
%
% Created: 2011-11-28.
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

function varargout = sep(varargin)

n = get(0,'CommandWindowSize');
nc = n(1); nl = n(2); clear n

car = '-';
label = '';

switch nargin
	case 1
		car = varargin{1};
	case 2
		car = varargin{1};
		label = varargin{2};
end% switch 

if nc < length(label)+2
	% The Command window is not lerge enough for this label !
	str = label;
else
	
	n = length(label)+2;
	str = '';
	for ii = 1 : fix( (nc - n)/2 )
		str = sprintf('%s%s',str,car);
	end
	str = sprintf('%s%s',str,label);		
	for ii = 1 : fix( (nc - n)/2 ) + rem(nc - n,2)
		str = sprintf('%s%s',str,car);
	end
	
end

switch nargout
	case 1
		varargout(1) = {str};
	otherwise
		disp(str);
end% switch 


end %functionsep