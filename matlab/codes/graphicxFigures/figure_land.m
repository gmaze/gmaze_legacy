% FIGURE_LAND White background landscape figure
% 
%  figure_land([H])
%
%	Set current figure, or with handle H, to a landscape format.
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

function figure_land(varargin);
		
switch nargin
	case 0
		num = gcf;
	case 1
		num = varargin{1};
end% switch

orient(num,'landscape');

posi = get(num,'position');
set(num,'Position',[posi(1:2) 720 450])

% switch wherearewe
% 	case {'macbook','nowhere'}
% 		set(num,'Position',[posi(1:2) 720 450]);
% 	otherwise
% 		set(num,'Position',[posi(1:2) 800 620]);
% end% switch 
	
if get(num,'color') == [.8 .8 .8]
	set(num,'Color', [ 1 1 1 ]);
end