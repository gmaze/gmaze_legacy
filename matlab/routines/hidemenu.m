% hidemenu Hide the menubar of a figure
%
% [] = hidemenu([gcf])
% 
% Hide the menubar of the figure with handle
% given by gcf or the current one.
%
%
% Created: 2009-04-27.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = hidemenu(varargin)

	if nargin ~= 0
		gc = varargin{1};	
		set(gc,'menubar','none');
	else	
		set(gcf,'menubar','none');
	end

end %function