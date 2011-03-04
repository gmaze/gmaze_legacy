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
function varargout = dashneg(h,varargin)
	
if nargin>1
	styl = varargin(:);
else
	styl = {'linestyle';'--'};
end


switch get(h(1),'type')
	case 'hggroup'
		hch = get(h,'children');
	otherwise
		hch = h;
end

method = 2;ii=0;d=[];
method = 1;

isonhold = ishold;
hold on
for ich = 1 : length(hch)
	us = get(hch(ich),'userdata');
	if us < 0
		switch method
			case 1
		%			set(hch(ich),'linestyle',styl);
				set(hch(ich),styl{:});
			case 2
				xdata = get(hch(ich),'xdata');
				ydata = get(hch(ich),'ydata');
				col   = get(hch(ich),'edgecolor');
				set(hch(ich),'edgecolor','none');
				if ischar(col)
					if strcmp(col,'flat')
						ii=ii+1;
						d(ii) = dashline(xdata,ydata,1,3,1,3);
						stophere
					%	set(d,'color',col);
					end
				end
%					stophere
%				stophere				
		end%swtich
	end%if negative
end%for ich
switch isonhold
	case 0
		hold off
	case 1
		hold on
end

if nargout==1 & method == 2
	varargout(1) = {d};
end











