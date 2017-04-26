% nojvmwaitbar Progress waitbar for Matlab running without JVM
%
% nojvmwaitbar(N,i,[TITLE])
% 
% Display a progress waitbar of fractional length i versus N
% with an optional message TITLE.
% 
% Eg:
%	for ii=1:100
%		nojvmwaitbar(100,ii,sprintf('line1\nline2'));
%		pause(1/20);
%	end
%
% Created: 2010-03-26.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = nojvmwaitbar(varargin)

N     = varargin{1};
iprog = varargin{2};
if nargin >= 3
	tit = varargin{3};
end

if nargin >= 4
	npt = varargin{4};
else
	npt = 75;
end

ii  = fix(iprog*npt/N);

str = ' ';
for ik = 2:npt
	str = sprintf('%s ',str);
end

if ii == 1
	str(ii) = '>';
end

if ii>1
	str(1:ii-1) = '=';
	str(ii)     = '>';
end

if ii==npt
	str(1:npt) = '=';
end


if exist('tit','var')
	clc;disp(sprintf('%s\n[%s] (%0.1f%%)',tit,str,ii*100/npt));
else
	clc;disp(sprintf('[%s] (%0.1f%%)',str,ii*100/npt));
end


end %functionnojvmwaitbar
















