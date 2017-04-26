% SERVERADDRESS Display nslookup output
%
% [server,addserver,name,addnam] = serveraddress()
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


function varargout = serveraddress(varargin)
	
	
if nargin == 1
	mach = varargin{1};
else
	mach = getcomputername;
end
[ret res] = system(sprintf('nslookup %s',mach));

if strfind(res,';;')
	disp('Connection timed out, no servers could be reached');
else

iserv = strfind(res,'Server:');
iadd  = strfind(res,'Address:');
inam  = strfind(res,'Name:');

server = res(iserv:iadd(1)-1);
addser = res(iadd(1):inam-1);
name   = res(inam:iadd(2)-1);
addnam = res(iadd(2):end);

server = cleanstr(server);
addser = cleanstr(addser);
name   = cleanstr(name);
addnam = cleanstr(addnam);

switch nargout
	case 0
		disp(sprintf('%s\n%s\n%s\n%s',server,addser,name,addnam'));
	case 1
		varargout(1) = {server};
	case 2
		varargout(1) = {server};
		varargout(2) = {addser};
	case 3
		varargout(1) = {server};
		varargout(2) = {addser};
		varargout(3) = {name};
	case 4
		varargout(1) = {server};
		varargout(2) = {addser};
		varargout(3) = {name};
		varargout(4) = {addnam};
end


end % if connected









function out = cleanstr(str)
	
n = length(str);
out = 'A';
for ii = 1 : n
	if length(strtrim(str(ii))) == 1
		out = [out str(ii)];
	end		
end	
out = out(2:end);





function name = getcomputername()
% GETCOMPUTERNAME returns the name of the computer (hostname)
% name = getComputerName()
%
% WARN: output string is converted to lower case
%
%
% See also SYSTEM, GETENV, ISPC, ISUNIX
%
% m j m a r i n j (AT) y a h o o (DOT) e s
% (c) MJMJ/2007
%

[ret, name] = system('hostname');   

if isempty('name')
   if ispc
      name = getenv('COMPUTERNAME');
   else      
      name = getenv('HOSTNAME');
      if strcmp(name,'hostname')
	name = getenv('HOST');
      end	
   end
end
name = lower(name);
name = strtrim(name);


