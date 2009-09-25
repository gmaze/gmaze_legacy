% maxi Maximize figure size
%
% [] = maxi(gcf)
% 
% This function set a figure size to full screen
%
%
% Created: 2008-11-05.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = maxi(varargin)

if nargin >= 1
	gc = varargin{1};
else
	gc = gcf;
end

% Get static screen size:
si = get(0,'MonitorPositions');
if size(si,1) > 1
	si = si(end,:);
else
	si = si(1,:);
end
if si(2) == 0, si(2) = 1;end

ht = si(4)-si(2)+1;
wd = si(3)-si(1)+1;
dd = 10;	
%
[dd dd wd-2*dd ht-2*dd]
for ifig = 1 : length(gc)	
	set(gc(ifig),'position',[dd dd wd-2*dd ht-2*dd]);
end






