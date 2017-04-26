% wssize H1LINE
%
% [] = wssize()
% 
% HELPTEXT
%
% Created: 2009-11-30.
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

function varargout = wssize(varargin)


ws_base   = evalin('base','who()');

b = 0; n = 0;
for iv = 1 : length(ws_base)
	evalin('base',sprintf('wssize_this=whos(''%s'');',ws_base{iv}));
	wsload('wssize_this');
	b = b + wssize_this.bytes;
	n = n + prod(wssize_this.size);
end%for iv

disp(sprintf('Total workspace bytes: %i',b));

[p unit] = getb(b);

disp(sprintf('Memory size: %0.3f %s',b/1024^p,unit))

co = 6.9; % Workspace to mat file approximate ratio
%disp(sprintf('Equivalent matlab file: %0.3f %s',b/1024^p/co,unit))



evalin('base','clear wssize_this');


end %functionwssize


function [p unit] = getb(n)
	
	for ii=1:4
		if findp(n/1024^ii) == 0
			p = ii;
		end
	end
	if ~exist('p','var'),p=1;end
	
	switch p
		case 1, unit = 'k';
		case 2, unit = 'M';
		case 3, unit = 'G';
		case 4, unit = 'T';
	end
	
end












