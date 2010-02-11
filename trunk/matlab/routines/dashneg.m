% DASHNEG Make dashed negative contours
%
% DASHNEG(h)
% 
% Change linestyle of h for negative values
% to dashed.
%
%
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
function varargout = dashneg(varargin)
	
h = varargin{1};

if nargin==2
	styl = varargin{2};
else
	styl = '--';
end

us = get(h,'userdata');
for ii = 1 : length(us)
	val = get(h(ii),'userData');
	if us{ii} < 0
		set(h(ii),'linestyle',styl);
	end
end













