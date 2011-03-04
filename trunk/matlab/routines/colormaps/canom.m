% CANOM Center the caxis on zero
%
% [] = CANOM()
%
% Center the coloraxis on zero
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

function varargout = canom(varargin)

% Look for contour values in the plot:
ch = get(gca,'children');
ch = setdiff(ch,findall(ch,'type','text'));

ct = findall(ch,'type','hggroup');
v  = cell2mat(get(get(ct,'children'),'userdata'));
	
if isempty(ct) % This is not a contour plot
	ct = findall(ch,'type','surface');
	if isempty(find(size(get(ct,'xdata'))==1))
		if isempty(find(size(get(ct,'ydata'))==1))
			if isempty(find(size(get(ct,'zdata'))==1))
				error('')
			else
				v = get(ct,'zdata');
			end
		else
			v = get(ct,'ydata');
		end
	else
		v = get(ct,'xdata');
	end
end

if isempty(v)
	% Let's if these are m_map stuff
	ct = findall(ch,'tag','m_contourf');
	v  = cell2mat(get(ct,'userdata'));
end	

%		stophere
	
%	v = cell2mat(get(get(gca,'children'),'userdata')); % Ok for contours
	if isempty(v)
%		v = get(get(gca,'children'),'cdata');
	end	
	if nargin==1
		v = varargin{1};
	end
	cx = max(abs(v(:)));
%	cx = abs(caxis);
	
	
	load mapanom2
	colormap(mapanom)
	caxis([-1 1]*max(cx));