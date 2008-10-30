% TBCONT Create a simple Contents.html file from a directory
%
% [] = tbcont(PATH_TO_DIR)
%
% Created: 2008-10-30.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = tbcont(varargin)


pathd = varargin{1};

global diag_screen_default
diag_screen_default.PIDlist = [2];
fid = fopen('tbcont.html','w');
diag_screen_default.fid = fid;
diag_screen_default.forma = '%s\n';

di = dir(sprintf('%s/*.m',pathd));
ifct = 0;
for ifil = 1 : size(di,1)
	name = di(ifil).name;
	if isempty(strfind(lower(name),'content'))
		fid = fopen(sprintf('%s/%s',pathd,name),'r');
		if fid>0
			ifct = ifct + 1;
			tline = fgetl(fid);
			fclose(fid);
			% disp(tline);
			is = strfind(tline,' ');
			fctname = tline(is(1):is(2));
			fctdefi = tline(is(2)+1:end);
			TB(ifct).file = name;
			TB(ifct).name = fctname;
			TB(ifct).def  = fctdefi;
			%disp(sprintf('%20s: %s',fctname,fctdefi));
		end
	end % we exclude this one
end %for ifil
clear it,
for ij = 1 : size(TB,2)
	it(ij) = {TB(ij).name};
end % Name


% Header
link_pref = 'http://guillaumemaze.googlecode.com/svn/trunk/matlab/routines/';


[y,ord] = sort(it); clear y 
diag_screen(sprintf('<html><body><table border=1>'));
for ij = 1 : size(TB,2)
	ifct = ord(ij);
	disp(sprintf('%20s: %s',TB(ifct).name,TB(ifct).def));
	diag_screen(sprintf('%10s <tr><td><a href="%s%s">%s</a></td><td>%s</td></tr>',' ',link_pref,TB(ifct).file,TB(ifct).name,TB(ifct).def));
end
diag_screen(sprintf('</body></table></html>'));




fclose(diag_screen_default.fid);
if nargout == 1
	varargout(1) = {TB};
end







