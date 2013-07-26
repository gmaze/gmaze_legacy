% jvmwaitbar Progress wait bar for Matlab running with Java on console
%
% jvmwaitbar(N,i,[TITLE])
% 
% Display a progress waitbar of fractional length i versus N
% with an optional message TITLE.
% 
% Eg:
%	for ii=1:100
%		jvmwaitbar(100,ii,sprintf('single line text'));
%		pause(1/20);
%	end
%
% Created: 2013-03-11.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
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

function varargout = jvmwaitbar(varargin)

%- Params:
switch nargin
	case 0
		clear global ConsoleProgressBar_instance
		return
	otherwise
		N     = varargin{1};
		iprog = varargin{2};
		tit = 'default';
		if nargin >= 3
			tit = varargin{3};
		end
end% switch 

%- Init progress bar:
global ConsoleProgressBar_instance
if ~isa(ConsoleProgressBar_instance,'ConsoleProgressBar')
	ConsoleProgressBar_instance = ConsoleProgressBar();
	ConsoleProgressBar_instance.setMinimum(0); 
	ConsoleProgressBar_instance.setMaximum(N);
	ConsoleProgressBar_instance.setElapsedTimeVisible(1); 
	ConsoleProgressBar_instance.setRemainedTimeVisible(1); 
	ConsoleProgressBar_instance.start();
end% if 	
	
%- Make it progress:
% update progress value:
ConsoleProgressBar_instance.setValue(iprog);   
% update user text:
if strcmp(tit,'default')
	%str = sprintf('Progress: [%d/%d]', iprog, N);
	str = ' ';
else	
	str = tit;
end% if 
ConsoleProgressBar_instance.setText(str);   

%- Close progress bar:
if iprog == N
	ConsoleProgressBar_instance.stop();
	disp(sprintf(' T %s',ConsoleProgressBar_instance.getElapsedTimeStr('HH:MM:SS.FFF')));
	clear global ConsoleProgressBar_instance
end% if 

end %functionjvmwaitbar