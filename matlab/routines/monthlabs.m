% MONTHLABS Get various labels of months
%
% TITLE = MONTHLABS(IMONTHS)
%
% Return a structure TITLE with various ways of
% calling the list of months given by IMONTHS as
% month indices (1 to 12)
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

function varargout = monthlabs(varargin)

wm = varargin{1};
r  = '';
r2 = '';
rlong = '';
if length(wm) > 4
	for ii = 1 : length(wm) -1 : length(wm) 
	r  = sprintf('%s to %s', r,datestr(datenum(1900,wm(ii),1,0,0,0),'mmm'));
	r2 = sprintf('%s_to_%s',r2,datestr(datenum(1900,wm(ii),1,0,0,0),'mmm'));
	rlong  = sprintf('%s to %s',rlong,datestr(datenum(1900,wm(ii),1,0,0,0),'mmmm'));
	end
	titM.noblank = r2(5:end);
	titM.short = r(5:end);
	titM.long  = rlong(5:end);
else
	for ii = 1 : length(wm)
	r  = sprintf('%s/%s',r,datestr(datenum(1900,wm(ii),1,0,0,0),'mmm'));
	r2 = sprintf('%s%s',r2,datestr(datenum(1900,wm(ii),1,0,0,0),'mmm'));
	rlong  = sprintf('%s/%s',rlong,datestr(datenum(1900,wm(ii),1,0,0,0),'mmmm'));
	end
	titM.short = r(2:end);
	titM.noblank = r2;
	titM.long = rlong(2:end);
end

if nargout  == 0
	disp(titM);
end

if nargout  == 1
	varargout(1) = {titM};
end

