function varargout = pcolorsf(varargin)
% pcolorsf Pseudocolor (pcolor) plot with automatic flat shading
%
% [] = pcolorsf(C) 
% [] = pcolorsf(X,Y,C) 
% [] = pcolorsf(AX,C) 
% H = pcolorsf(...) 
% 
% Same as classic pcolor except that we immediatelly set shading to flat.
%
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-11-03 (G. Maze)

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

switch nargin
	case 3
		% Try to be cool on the size of the field to plot if we forget a squeeze !
		x = varargin{1};
		if ~isa(x,'axes')
			y = varargin{2};
			z = varargin{3};
			d = unique(size(z));		
			if length(find(d~=1)) % Only 2 non-null dimensions, the other set to 1 because we forget a squeeze, then:
				z = squeeze(z);
			end% if
			h = pcolor(x,y,z);
		end% if 
	case 1
		% Try to be cool on the size of the field to plot if we forget a squeeze !
		z = varargin{1};	
		d = unique(size(z));				
		if length(find(d~=1)) % Only 2 non-null dimensions, the other set to 1 because we forget a squeeze, then:
			z = squeeze(z);
		end% if
		h = pcolor(z);
	otherwise
		h = pcolor(varargin{:});		
end% switch 

shading flat

if nargout, varargout(1) = {h};end% if 

end %functionpcolorsf