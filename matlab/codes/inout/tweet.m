% tweet Send tweets !
%
% [] = tweet(MESSAGE,[PROP,VAL]);
% 
% Send tweets using the system command 'ttytter'.
% 
% Inputs:
% 	MESSAGE: A string with the tweet.
% 	PROP:
% 		- 'to': Send a direct message to VAL
% 		- 'id': Define the account to use to send the tweet.
% 				In this case, VAL is such that the keyfile ttytter will use
% 				is here: ~.ttytterkeyVAL.
% 				Type: ls ~/.ttytterkey* to see what's available
%
% Eg:
% 	tweet('Hello world !');
% 	tweet('Check this out ! http://code.google.com/p/guillaumemaze/source/browse/trunk/matlab/codes/inout/tweet.m A tweet from #matlab','to','MATLAB')
%
% Info:
% 'ttytter' is a perl code to use twitter from script and command line. Check it out at:
% 	http://www.floodgap.com/software/ttytter
% 
% Created: 2012-12-20.
% Copyright (c) 2012, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
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

function varargout = tweet(TWEET,varargin)

%- Defaults parameters:
id = 'argonaarc';
to = 'x';

%- Load arguments (and possibly overwrite defaults parameters):
if nargin > 1
	if mod(nargin-1,2) ~=0
		error('Arguments must come in pairs: PROP,VAL')
	end% if 
	for in = 1 : 2 : nargin-1
		eval(sprintf('%s = varargin{in+1};',varargin{in}));
	end% for in
	clear in
end% if

%--
if length(TWEET)<5
	error('This seems to be a very very short tweet, I won''t send it !');
end% if 
if length(TWEET)>140
%	error('This seems to be a long tweet, I won''t send it !');
end% if

%-
switch to
	case 'x'
		%-- This is not a direct message !
		command = TWEET;
	otherwise
		%-- This IS a direct message:
		if length(to)<4
			error('This seems to be a very very short username to send a message, I won''t send it !');			
		end% if 
		command = sprintf('/dm %s %s',to,TWEET);
end% switch 

command = sprintf('ttytter -keyf=%s -runcommand="%s"',id,command);
%disp(command);
s = system(command);

end% function twitter















