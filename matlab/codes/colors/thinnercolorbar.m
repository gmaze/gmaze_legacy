% thinnercolorbar Change colorbars thickness in groups
%
% [] = thinnercolorbar(CL,OPTIONS)
% 
% Change colorbars thickness in groups
%
% Inputs: 
%	CL: a list of colorbars handles
%	OPTIONS: a pair from:
%		'verticalAlignment' (string)   : 'b' (bottom) or 'm' (middle, default) or 't' (top)
%		'horizontalAlignment' (string) : 'l' (left)   or 'c' (center, default) or 'r' (right)
%		'factor' (double)
%		'offset' (double)
%			If the old colorbar thickness is L, the new one is given by:
%				L = L*factor + offset
%			By default, factor=0.9 and offset=0
%		'plothl' (handles): a list of plots (axes) handles to which correspond each of the colorbars
%			handles given by CL. This is used to ensure the function won't change the plot position.
%
%
% Created: 2010-07-07.
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

function varargout = thinnercolorbar(varargin)

cl = varargin{1};

verticalAlignment    = 'm'; %   bottom           middle    top       
horizontalAlignment  = 'c'; % center  left    right   
factor = 0.9;
offset = 0;
plothl = []; % Associated axes handles (to preserve position);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%- Load user options
if nargin > 1
	for in = 2 : 2 : nargin
		eval(sprintf('%s = varargin{in+1};',varargin{in}));
	end%for in
end
if exist('scale','var') % common mistake in arguments names
	factor = scale;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for icl = 1 : length(cl)	
	if strfind(get(cl(icl),'tag'),'Colorbar')
		
		% Initial colorbar position:
		pos = get(cl(icl),'position');
		
		% Initial associated axes position:
		if ~isempty(plothl)
			plpos = get(plothl(icl),'position');
		end
		
		% Determine orientation of the colorbar:
		or = getor(cl(icl));
		
		% Change thickness:
		switch or
			case 'v' % Vertical colorbar
			
				% New width:
				w = pos(3)*factor+offset;
				
				% Apply new width
				switch lower(horizontalAlignment) % Horizontal alignment:
					case 'c' % Stay centered:
						c = pos(1)+pos(3)/2;
						set(cl(icl),'position',[c-w/2 pos(2) w pos(4)]);
					case 'l' % Stick to the left:
						set(cl(icl),'position',[pos(1) pos(2) w pos(4)]);						
					case 'r' % Stick to the right:
						r = pos(1)+pos(3);
						set(cl(icl),'position',[r-w pos(2) w pos(4)]);
				end
				
			case 'h' % Horizontal colorbar
			
				% New height:
				h = pos(4)*factor+offset;
				
				switch lower(verticalAlignment)
					case 'm' % Stay centered to the middle line
						c = pos(2)+pos(4)/2;
						set(cl(icl),'position',[pos(1) c-h/2 pos(3) h]);						
					case 't' % Stick to the top		
						t = pos(2)+pos(4);
						set(cl(icl),'position',[pos(1) t-h pos(3) h]);						
					case 'b' % Stick to the bottom
						set(cl(icl),'position',[pos(1) pos(2) pos(3) h]);
				end
		end

		% Preserve associated plot position:
		if ~isempty(plothl)
			set(plothl(icl),'position',plpos);
		end
	end%if
end

end %functionthinnercolorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function or = getor(cl);
	
	if isempty(get(cl,'xtick'))
		or = 'v';
	elseif isempty(get(cl,'ytick'))	
		or = 'h';
	else
		error('');
	end

end%function







