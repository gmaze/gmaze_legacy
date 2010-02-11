% cbsnews Open the CBS Evening News podcast with your browser
%
% cbsnews([DATE])
% 
% Open the CBS Evening News podcast with your browser.
% If DATE is specified (format: MM/DD) open it instead.
%
% Created: 2009-10-15.
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = cbsnews(varargin)

if nargin == 0
	d = datenum(now)-1;
	cl(1) = str2double(datestr(d,'yyyy'));
	cl(2) = str2double(datestr(d,'mm'));
	cl(3) = str2double(datestr(d,'dd'));
else
	d = strread(varargin{1},'%s','delimiter','/');
	cl(1) = str2double(datestr(now,'yyyy'));
	cl(2) = str2double(d{1}); % month
	cl(3) = str2double(d{2}); % day
	d = datenum(cl(1),cl(2),cl(3),0,0,0);
end

if strcmp(datestr(d,'ddd'),'Sat') || strcmp(datestr(d,'ddd'),'Sun')
%	error('No CBS evening news on week-end !')
end

% CBS Evening news
command = sprintf('http://mediasd.cbsnews.com/media/%i/%0.2i/%0.2i/evening_broadcast%0.2i%0.2i_720.mp4',cl(1),cl(2),cl(3),cl(2),cl(3));
disp(sprintf('CBS Evening news:\n\t%s',command));
cbs = command;
system(sprintf('osascript -e ''tell application "QuickTime Player" to activate'' -e ''tell application "QuickTime Player" to getURL "%s"''',cbs));


% CNN Daily news:
command = sprintf('http://podcasts.cnn.net/cnn/big/podcasts/cnnnewsroom/video/%i/%0.2i/%0.2i/the.daily.%0.2i.%0.2i.cnn.m4v',cl(1),cl(2),cl(3),cl(2),cl(3));
disp(sprintf('CNN Daily news:\n\t%s',command));
cnn = command;
%system(sprintf('osascript -e ''tell application "QuickTime Player" to activate'' -e ''tell application "QuickTime Player" to getURL "%s"''',cnn));

% France 2 Flash permanent:
command = sprintf('mms://a988.v101995.c10199.e.vm.akamaistream.net/7/988/10199/1255708678/ftvigrp.download.akamai.com/10199/horsgv/regions/siege/infos/f2/flashinfos/flashinfo.wmv');
disp(sprintf('France 2 Flash permanent:\n\t%s',command));
fr2 = command;
%system(sprintf('osascript -e ''tell application "QuickTime Player" to activate'' -e ''tell application "QuickTime Player" to getURL "%s"''',fr2));




end %functioncbsnews







