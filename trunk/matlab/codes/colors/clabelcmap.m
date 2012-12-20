% clabelcmap Create labels for colorbar
%
% [yt ytl] = clabelcmap(hcb,cx,N,[C,F])
% 
% Create clean labels for a colorbar
% Inputs:
%	hcb: handle of the colorbar
%	cx: 2 values of the caxis
%	N:	Number of colors in the colormap
%	C = 0(default) or 1: specified if labels have to be centered on
%		each colors or placed on the edges
%	F: Indicate the format to use (default is: %0.0f)
%
% Example:
%	N = 12; cx = [-1 1]*250;
%	colormap(jet(N));
%	subplot(1,2,1);caxis(cx);cl=colorbar;clabelcmap(cl,cx,N,1);title('Labels centered');
%	subplot(1,2,2);caxis(cx);cl=colorbar;clabelcmap(cl,cx,N,0,'%g');title('Labels not centered');
%	
% Created: 2009-11-24.
% Rev. by Guillaume Maze on 2012-06-11: Added output handles
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = clabelcmap(varargin)

cl   = varargin{1};
if ~strcmp(get(cl,'Tag'),'Colorbar')
	error('clabelcmap: 1st argument must a colorbar handle !');
end
cx   = varargin{2};
if length(cx) ~= 2
	error('clabelcmap: 2nd argument must a 1x2 caxis value !');
end
N	 = varargin{3};

if nargin >= 4
	centered = varargin{4};
else
	centered = 0;
end
if nargin >= 5
	forma = varargin{5};
else
	forma = '%0.0f';
end

switch centered
	case 0
		yt = linspace(cx(1),cx(2),N+1);
	case 1
		l = linspace(cx(1),cx(2),N+1);
		yt = l(1)+diff(l(1:2))/2 : diff(l(1:2)) : l(end);
end

for ii = 1 : length(yt)
	ytl(ii) = {eval(['sprintf(''',forma,''',yt(ii))'])};
end

switch getor(cl)
	case 'v'
		set(cl,'ytick',yt,'yticklabel',ytl);
	case 'h'
		set(cl,'xtick',yt,'xticklabel',ytl);
end


switch nargout
	case 1
		varargout(1) = {yt};
	case 2
		varargout(1) = {yt};
		varargout(2) = {ytl};
end% switch 


end %functionclabelcmap



function or = getor(cl);
	
if isempty(get(cl,'xtick'))
	or = 'v';
elseif isempty(get(cl,'ytick'))	
	or = 'h';
else
	error('');
end

end%function






