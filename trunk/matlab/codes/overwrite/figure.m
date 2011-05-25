% FIGURE Create customized figure window
%
%    FIGURE, by itself, creates a new figure window, and returns
%    its handle.
%  
%    FIGURE(H) makes H the current figure, forces it to become visible,
%    and raises it above all other figures on the screen.  If Figure H
%    does not exist, and H is an integer, a new figure is created with
%    handle H.
% 
%    GCF returns the handle to the current figure.
% 
%    Execute GET(H) to see a list of figure properties and
%    their current values. Execute SET(H) to see a list of figure
%    properties and their possible values.
% 
%    See also SUBPLOT, AXES, GCF, CLF.
% 
% Created by Guillaume Maze on 2008-10-09.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = figure(varargin)

a = dbstack('-completenames');

mycall = true;
for ia = 1 : length(a)
%	a(ia).name
	if ~isempty(intersect(a(ia).name,{'listdlg','warndlg','msgbox','dialog','local_GUImenu','iconEditor','floatAxisX'}))
		mycall = false;
	end
end

fh_cb = @newfig; % Create function handle for newfig function

if ~ mycall
	f = builtin('figure',varargin{:});
	set(f,'ButtonDownFcn',fh_cb);	
	if nargout == 1
	       varargout(1) = {f};
	end
	
else

	% 
	posi = figure_central;
	co = 10;
		
	f = builtin('figure',varargin{:});
	set(f,'ButtonDownFcn',fh_cb);
	
	% Special figures:
	tag = get(f,'Tag');
	if ~strcmp(tag,'TMWWaitbar') | ~strcmp(tag,'floatAxisX')
		switch get(0,'DefaultFigureWindowStyle')
			case 'docked'
			otherwise
				set(f,'position',[posi(1)+co*(f-1) posi(2) posi(3:4)]);
		end
		set(f,'menubar','none');
		footnote;
	end

	if nargout==1
	       varargout(1) = {f};
	end

end %if



function newfig(src,evnt)
% 	if strcmp(get(src,'SelectionType'),'alt')
% %		figure('ButtonDownFcn',fh_cb)
% 		disp('Add a note');
% 	else
% 		disp('Use control-click to add a note')
% 	end
end% function

end%function











