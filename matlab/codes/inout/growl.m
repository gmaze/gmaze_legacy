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
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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



