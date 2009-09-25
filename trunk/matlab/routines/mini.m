% mini Reduce figure size to a mini standard
%
% [] = mini(gcf)
% 
% This function dramatically reduces a figure size
% (Note that it removes the footnote if it exists)
%
% Copyright (c) 2007 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function [] = mini(varargin)

if nargin >= 1
	gc = varargin{1};
else
	gc = gcf;
end
	
% Size of the new figure:	
wd = 250;
ht = 230;
	  
	
for ifig = 1 : length(gc)	
	posi = get(gc(ifig),'position');
	xc = posi(1) + posi(3)/2;
	yc = posi(2) + posi(4)/2;
	set(gc(ifig),'position',[xc-wd/2 yc-ht/2 wd ht]);
	set(gc(ifig),'MenuBar','none');
	
	h = findobj(gc(ifig),'Type','axes'); 
	oldtitle = 0;
	for i = 1 : length(h),
		if strcmp(get(h(i),'Tag'),'footnote')
			delete(h(i));
		end
	end	
	
end
