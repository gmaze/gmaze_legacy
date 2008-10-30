% SHOWMENU Ensure the menu bar is shown on a figure
%
% showmenu(GCF)
%
% Created by Guillaume Maze on 2008-10-14.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = showmenu(varargin)
	
if nargin ~= 0
	gc = varargin{1};	
	set(gc,'menubar','figure');
else	
	set(gcf,'menubar','figure');
end

