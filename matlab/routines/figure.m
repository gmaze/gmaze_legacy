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

% Get static screen size:
si = get(0,'ScreenSize' );

% New dimension:
dx = 620;
dy = 440;
posi = [si(3)/4-dx/2 si(4)/2-dy/2 dx dy];

if isempty(nargin)     
	f = builtin('figure');
%	posi = get(gcf,'position'); posi = [posi(1)-dx/2 posi(2)-dy/2 posi(3)+dx posi(4)+dy];
	set(gcf,'position',posi);
else
	f = builtin('figure',varargin{:});
%	posi = get(gcf,'position'); posi = [posi(1)-dx/2 posi(2)-dy posi(3)+dx posi(4)+dy];
	set(gcf,'position',posi)
end
set(gcf,'menubar','none');

footnote;

if nargout==1
       varargout(1) = {f};
end

