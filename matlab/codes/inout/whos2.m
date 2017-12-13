function varargout = whos2(varargin)
% whos2 List only 2-Dimensional arrays
%
% w = whos2() List only 2-Dimensional arrays 
% 	Singleton dimensions are accounted for.
%
% See Also: whos, whos3, whos1
%
% Copyright (c) 2017, Guillaume Maze (Ifremer, Laboratoire d'Océanographie Physique et Spatiale).
% Created: 2017-06-02 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire d'Océanographie Physique et Spatiale nor the names of its contributors may be used 
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

ws_base   = evalin('base','whos()');

ikeep = zeros(1,length(ws_base)).*false;
name_len = 0;
for iv = 1 : length(ws_base)
	if ~strcmp(ws_base(iv).name,'ans')
		s = ws_base(iv).size;
		if length(s(s~=1&s~=0)) == 2
			ikeep(iv) = true;
			name_len = max([name_len,length(ws_base(iv).name)]);
		end% if
	end% if 
end%for iv

if nargout == 1
	varargout(1) = {ws_base(ikeep==1)};
else
	ws_base = ws_base(ikeep==1);
	str = '';
	for iv = 1 : length(ws_base)
		str = sprintf('%s %s',str,ws_base(iv).name);
	end% for iv
	evalin('base',sprintf('whos %s',str));
	
end% if 

end %functionwhos2
