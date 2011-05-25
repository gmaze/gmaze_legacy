% vline Draw a vertical line on a plot
%
% h = vline([X,STYLE])
% 
% Draw a vertical line on the current plot
%
% Inputs:
%	X: Intersection of the line with the x-axis
%		By default it is set to: x=0
% 	STYLE: is any pair of properties for a line object
%		Default is plain black 
%
% Outputs:
%	h: line handle
% 	
% See also:
%	hline, refline
%
% Created: 2010-11-04.
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

function varargout = vline(varargin)

% Default line style:
style = {'color';'k'};

% Default position on the x-axis:
x0 = 0;
	
switch nargin
	case 0
		% Nothing to do
	case 1
		x0    = varargin{1};
	otherwise
		if mod(nargin,2) ~= 0
			x0    = varargin{1};
			style = varargin(2:end);
		else
			style = varargin(:);
		end
end

for ix = 1 : length(x0)
	l(ix) = line([1 1]*x0(ix),get(gca,'ylim'));
	set(l(ix),style{:})
	set(l(ix),'tag','vline');
end

if nargout
	varargout(1) = {l};
end

end %functionvline


















