% wsload Load all (or list of) variables of the base workspace into a function workspace
%
% [] = wsload([VLIST])
% 
% Load all variables of the base workspace into a function workspace.
% If VLIST is specified, only load variables given by cell array VLIST.
%
% Created: 2009-11-05.
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

function varargout = wsload(varargin)

ws_base   = evalin('base','who()');
ws_caller = evalin('caller','who()');

switch nargin
	case 1  %%% LOAD SPECIFIC VARIABLES:
		vlist = varargin{1};
		if isnumeric(vlist)
			error('I can only load variables given by a string !');
		elseif ischar(vlist)
			vlist = {vlist};
		end
		for ii = 1 : length(vlist)
			if ~strcmp(vlist{ii},'ans') 
				if ismember(vlist{ii},ws_base)
					[iv iv] = ismember(vlist{ii},ws_base);
					tmp = evalin('base',ws_base{iv});
					assignin('caller',ws_base{iv},tmp);
				else
					warning(sprintf('Cannot load ''%s'' because it is not in the base workspace',vlist{ii}));
				end
			end
		end
	otherwise %%% LOAD ALL VARIABLES:
		for ii = 1 : length(ws_base)
		   if ~strcmp(ws_base{ii},'ans') & ~strcmp(ws_base{ii},'varargin') & ~strcmp(ws_base{ii},'varargout')
		      tmp = evalin('base',ws_base{ii});
		      assignin('caller',ws_base{ii},tmp);
		   end
		end
end%if which variables to load



end%function












