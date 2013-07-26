% h1line Search for text in h1 lines
%
% [] = h1line(PATTERN)
% 
%
% Created: 2013-07-17.
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

function varargout = h1line(varargin)

pattern = varargin{1};

plist = strread(path,'%s','delimiter',':');

ii = 0;
N = 0;
t0 = now;
for ip = 1 : length(plist)
	mlist = dir(fullfile(plist{ip},'*.m'));
	for im = 1 : length(mlist)
		N = N + 1;
		mfile = fullfile(plist{ip},mlist(im).name);
		tline = readh1line(mfile);
		if ischar(tline)
			is  = strfind(lower(tline),lower(pattern));
%			is  = regexp(lower(tline),lower(pattern));
			if ~isempty(is)
				[pa na ex] = fileparts(mfile);
				ii = ii + 1;
				RESULT(ii).file = mfile;
				RESULT(ii).path = pa;
				RESULT(ii).name = na;
				RESULT(ii).ext    = ex;
%				RESULT(ii).h1line = tline;
				RESULT(ii).h1line = regexprep(tline,sprintf('(\\w*)%s(\\w*)',pattern),sprintf('$1[%s]$2',pattern),'ignorecase');
			end% if 
		end% if 
	end% for im
end% for ip
if ~exist('RESULT','var')
	disp('No results');
	return
end% if 

NR = length(RESULT);

% Display results:
n = get(0,'commandWindowSize');
res = sprintf('Found %i result(s) from %i files',NR,N);
tim = stralign(n(1)-length(res)-1,sprintf('(in %0.4f seconds)',(now-t0)*86400),'left');
disp(sprintf('%s %s',res,tim))

for ifct = 1 : length(RESULT)
%			disp(sprintf('%s: %s',strjust(sprintf('%30s',TB(ifct).name),'left'),strjust(sprintf('%30s',TB(ifct).def),'left')));
%	disp(sprintf('%s: %s (%s)',stralign(20,TB(ifct).name,'left'),stralign(50,TB(ifct).def,'left'),TB(ifct).file));
	disp(sprintf('%s: %s (%s)',stralign(20,RESULT(ifct).name,'left'),stralign(50,RESULT(ifct).h1line,'left'),RESULT(ifct).file));
end
		
end %functionh1line






























