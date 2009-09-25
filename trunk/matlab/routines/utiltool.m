% utiltool Create a standalone toolbar with my personnal buttons
%
% [] = utiltool()
% 
% Create a standalone toolbar with my personnal buttons from mytoolbar
%
%
% Created: 2008-11-19.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = utiltool(varargin)

	% Existing toolbars:
	tbh0 = findall(0,'Tag','utiltool');
	
	% We remove it and re-create it to update:
	if ~isempty(tbh0)
		delete(tbh0);
	end
	
	gf = builtin('figure');
	set(gf,'Tag','utiltool');
	set(gf,'visible','off');
	set(gf,'toolbar','none','menubar','none');
	set(gf,'resize','off');
	set(gf,'name','My toolbar','NumberTitle','off');
	
	% Get static screen size:
	si = get(0,'MonitorPositions');
	if size(si,1) > 1
		si = si(end,:);
	else
		si = si(1,:);
	end

	% New dimension:
	dx = 400; dy = 1; posi = [1 si(4)-30 dx dy];
	if si(3) == 1680 & si(4) == 1028 % Laptop 17''
		posi = [20 50 dx dy];
	end
	co = 10;
	set(gf,'position',posi);
	mytoolbar(gf);
	

	set(gf,'visible','on');
end %function





