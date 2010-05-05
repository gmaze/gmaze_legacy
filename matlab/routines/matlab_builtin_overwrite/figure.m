% FIGURE Create customized figure window
%
%    FIGURE, by itself, creates a new figure window, and returns
%    its handle.
%  
%    FIGURE(H) makes H the current figure, forces it to become visible,
%    and raises it above all other figures on the screen.  If Figure H
%    does not exist, and H is an integer, a new figure is created with
%    handle H.
% 
%    GCF returns the handle to the current figure.
% 
%    Execute GET(H) to see a list of figure properties and
%    their current values. Execute SET(H) to see a list of figure
%    properties and their possible values.
% 
%    See also SUBPLOT, AXES, GCF, CLF.
% 
% Created by Guillaume Maze on 2008-10-09.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = figure(varargin)

a = dbstack('-completenames');
fil_caller = a(end).file;
%if strfind(fil_caller,matlabroot)
if isempty(strfind(fil_caller,getenv('HOME')))
	f = builtin('figure',varargin{:});	
	if nargout == 1
	       varargout(1) = {f};
	end
	
else

		% We only run this script from the home directory

		% Get static screen size:
		si = get(0,'MonitorPositions');
 		ii = find(si(:,3)==max(si(:,3)));
		si = si(ii,:);

		% New dimension:
		dx = 620; dy = 440;
		dx = 570; dy = 440;
		posi = [si(3)/2-dx/2 si(4)/2-dy/2 dx dy];
		if si(3) == 1680 & si(4) == 1028 % Laptop 17''
			posi = [20 50 dx dy];
		elseif si(3) == 1680 & si(4) == 1050 % Cinema Display Ifremer
			posi = [1 1 dx dy];
		elseif si(3) == 1280 & si(4) == 778 % MacBook 13.1''
%			posi = [1 50 dx dy];
			posi = [1 50 450 450/1.2955];
		end
		co = 10;
%		posi(1) = 1;
%		posi(2) = si(4)-posi(4);
		si = get(0,'MonitorPositions');
		if si(1,2) > 2
			posi(2) = max(si(:,2));
		end
		

		if isempty(nargin)     

		else
			f = builtin('figure',varargin{:});
		end

		% Special figures:
		tag = get(f,'Tag');
		if ~strcmp(tag,'TMWWaitbar')
			set(f,'position',[posi(1)+co*(gcf-1) posi(2) posi(3:4)]);
			set(gcf,'menubar','none');
			footnote;
		end

		if nargout==1
		       varargout(1) = {f};
		end

end %if














