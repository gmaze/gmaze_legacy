% growl Send a notification to Growl
%
% [] = growl(MESSAGE,[TITLE,STICKY,PRIORITY])
% 
% Send a notification to Growl.
%
% Inputs:
%	MESSAGE (double or string): 1 single line message
%	TITLE (double or string): Title of the notification
%	STICKY: 0 (default) or 1 to indicate if the notification should stick on screen
%	PRIORITY (double): Priority of the notification (0 by default)
%		Priority is not supported by all displays, so this may be ignored.
%
% If no title is specified, the routine caller is indicated.
%
% Example:
%	growl('routine starts');
%	% Your routine here
%	growl('routine ends');
%
% Created: 2009-09-25.
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

function varargout = growl(varargin)

error(nargchk(1,4,nargin,'struct'));
mess = varargin{1};
if isnumeric(mess)
	mess = num2str(mess);
elseif ischar(mess)
	% void
else
	error('Only numeric and string types are supported for the message');
end

if nargin >= 2
	titl = varargin{2};
	if isnumeric(titl)
		titl = num2str(titl);
	elseif ischar(titl)
		% void
	else
		error('Only numeric and string types are supported for the title');
	end	
	if isempty(titl)
		% 28 blank spaces otherwise growl fills with the message
		titl = '                            '; 
	end
else
	a = dbstack;
	titl = a(end).file;
	if strcmp(titl,'growl.m')
		titl = 'Matlab prompt';
	end
	titl = sprintf('A message from: %s',titl);
end

% The message icon:
%icon = '~/matlab/routines/data/matlab.tiff';

% Does the message will stick on screen ?
if nargin >= 3
	do_stick = varargin{3};
	if do_stick
		sticky = '-s';
	else
		sticky = '';
	end
else
	sticky = '';
end

% Priority of the message:
if nargin >= 4
	prior = varargin{4};
	if ~isnumeric(prior)
		error('Priority must be an integre >=0 ');
	end
else
	prior = 0;
end

% Run system command:
%str = sprintf('growlnotify %s -p %i --image %s -m ''%s'' -t ''%s''',sticky,prior,icon,mess,titl);
str = sprintf('growlnotify %s -p %i --appIcon Matlab -m ''%s'' -t ''%s''',sticky,prior,mess,titl);
[status,result] = system(str);
if status ~= 0
	error('Please verify your installation of growlnotify');
end



end %function



