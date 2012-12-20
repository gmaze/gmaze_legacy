%move_axes Move an axis (plot) within a figure
%
% [] = move_axes(gc,[TYPE,PARAM])
% 
% Move the axes with handle gc according to TYPE and PARAM.
%
% TYPE:
%	'horizontalshift': Move the axis horizontally by an amount
%		given by PARAM.
%	'verticalshift': Move the axis vertically by an amount
%		given by PARAM.
%
%	'expandleft': Expand the axis toward the left by an amount
%		given by PARAM. The right axis position is preserved.
%	'setwidthleft': Change the axis width by extending/cropping it 
%		on the left side. The new width is given by PARAM.
%
%	'vshrink': Change the axis height without changing the vertical
%		position of the axis center position.
%	'hshrink': Change the axis width without changing the horizontal
%		position of the axis center position.
%
%	'reset': Set the axis back to its initial position
%
% WARNING:
%	For the 'reset' options to work nicely, please use move_axes only
%	when all figure's axes are plotted.
%
% Rev. by Guillaume Maze on 2011-03-29: Added the reset options
% Created: 2010-11-08.
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

function varargout = move_axes(varargin)

%- Load options:
axishl    = varargin{1};
move_type = varargin{2};

%- Store in the figure the axis position:
ph = get(axishl,'parent');
if ~strcmp(get(ph,'type'),'figure')
	error('This function only works if the parent of this axis is a figure !')
end% if 
switch isappdata(ph,'SubplotInitialPositions')
	case true
		SubplotInitialPositions = getappdata(ph,'SubplotInitialPositions');
	case false	
		SubplotInitialPositions.axlist = findall(get(ph,'children'),'type','axes');
		for ix = 1 : length(SubplotInitialPositions.axlist)
			SubplotInitialPositions.positions(ix,:) = get(SubplotInitialPositions.axlist(ix),'position');
		end% for ix
		setappdata(ph,'SubplotInitialPositions',SubplotInitialPositions);
end% switch Already set up

%- Move or reset the axis position:
switch move_type
	case 'hshrink'
		dx  = varargin{3};
		pos = get(axishl,'position');
		set(axishl,'position',[pos(1)-dx/2 pos(2) pos(3)+dx pos(4)]);

	case 'vshrink'
		dy  = varargin{3};
		pos = get(axishl,'position');
		set(axishl,'position',[pos(1) pos(2)-dy/2 pos(3) pos(4)+dy]);
		
	case {'horizontalshift'}
		dx  = varargin{3};
		pos = get(axishl,'position');
		set(axishl,'position',[pos(1)+dx pos(2) pos(3) pos(4)]);
	case {'verticalshift'}
		dy  = varargin{3};
		pos = get(axishl,'position');
		set(axishl,'position',[pos(1) pos(2)+dy pos(3) pos(4)]);
	case 'expandleft'
		dx  = varargin{3};
		pos = get(axishl,'position');
		set(axishl,'position',[pos(1)-dx pos(2) pos(3)+dx pos(4)]);
	case 'setwidthleft'
		wd  = varargin{3};
		if wd <= 0
			error('An axis width must be positive');
		end
		pos = get(axishl,'position');
		wd0 = pos(3);
		set(axishl,'position',[pos(1)+wd0-wd pos(2) wd pos(4)]);
		
	case 'reset'
		ix = find(SubplotInitialPositions.axlist==axishl);
		if isempty(ix)
			error('I couldn''t reset this axes position because I can''t find it in the figure''s database')
		end
		set(axishl,'position',SubplotInitialPositions.positions(ix,:));
end%switch


end %functionmove_axes












