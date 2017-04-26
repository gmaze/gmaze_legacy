% QSTAT Return command qstat -u user outputs
%
% [tl] = qstat([USER])
%
% Execute the system command: qstat -u USER
% and give back the list
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

function varargout = qstat(varargin)
	
	
if nargin == 1
	user = varargin{1};
	system(sprintf('qstat -u %s > /tmp/qstat.txt',user));	
else	
	system(sprintf('qstat > /tmp/qstat.txt'));
end	
	
fid=fopen('/tmp/qstat.txt');
ii = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    disp(tline)
	ii = ii + 1;
	tl(ii).txt = tline;
end
fclose(fid);	
delete('/tmp/qstat.txt');

if nargout >= 1
	varargout(1) = {tl};
end






