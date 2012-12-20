% footstamp Create the default footnote for figure
%
% STR = footstamp([TYP])
% 
% Create the default footnote string for figure
%
% TYP (optional):
%	1 (default) : 
%		>> footstamp
%		code@guillaumemaze.org (22-Jul-2009 14:09)
%		macbook://Users/gmaze/work/Postdoc/work/main/hydrolpo
%	2: 
%		>> footstamp(2,[mfilename('fullpath') '.m'])
%		code@guillaumemaze.org (22-Jul-2009 14:29)
%		(macbook) file://Users/gmaze/work/Postdoc/work/main/hydrolpo/hydro_selected_viewdates.m
%	3: Same as 2 but output is a cell of string
%	
%
% Rev. by Guillaume Maze on 2012-02-13: Added option 3 for cell outputs
% Created: 2009-07-22.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = footstamp(varargin)

if nargin == 0
	typ = 1;
else
	typ = varargin{1};
end
	
switch typ
	case 3
		we   = wherearewe;
		mfil = varargin{2};
		dte  = datestr(now,'dd-mmm-yyyy HH:MM');
		str(1) = {sprintf('code@guillaumemaze.org (%s)',dte)};
		str(2) = {sprintf('(%s) file:/%s',we,mfil)};
	case 2
		we   = wherearewe;
		mfil = varargin{2};
		str  = datestr(now,'dd-mmm-yyyy HH:MM');
		str  = sprintf(' code@guillaumemaze.org (%s)\n (%s) file:/%s',str,we,mfil);		
	otherwise	
		we  = wherearewe;
		str = datestr(now,'dd-mmm-yyyy HH:MM');
		str = sprintf(' code@guillaumemaze.org (%s)\n %s:/%s',str,we,pwd);
end


switch nargout
	case 1
		varargout(1) = {str};
	otherwise
		disp(str);
end


end %function