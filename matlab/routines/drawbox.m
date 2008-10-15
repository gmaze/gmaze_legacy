%DEF
%REQ
%
% Created by Guillaume Maze on 2008-10-14.
% Copyright (c) 2008 Guillaume Maze. 
% http://www.guillaumemaze.org/codes

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = drawbox(NW,SE,varargin)


hold on
if isempty(nargin)
	l = line([NW(1) SE(1) SE(1) NW(1) NW(1)],[NW(2) NW(2) SE(2) SE(2) NW(2)]);
else
	l = line([NW(1) SE(1) SE(1) NW(1) NW(1)],[NW(2) NW(2) SE(2) SE(2) NW(2)],varargin{:});
end


if nargout >= 1
	varargout(1) = {l};
end



	



