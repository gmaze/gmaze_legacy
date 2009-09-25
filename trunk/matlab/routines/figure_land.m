% FIGURE_LAND White background landscape figure
% 
% Copyright (c) 2004 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function figure_land(num);
	
if nargin == 0;
	num = gcf;
else
%  builtin('figure',num); num = gcf;
	num = figure;
end

orient landscape
posi = get(num,'position');
set(gcf,'Position',[posi(1:2) 800 620])
%set(gcf,'Position',[2+10*(num-1) 225-10*(num-1) 800 620])

set(gcf,'Color', [ 1 1 1 ] );
