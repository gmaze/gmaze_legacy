% wssave Save all (or list of) variables from the caller workspace into the base workspace
%
% wssave() Save all variables from the caller workspace to the base workspace.
% 
% wssave('var') Save variable named 'var' from the caller workspace to the base workspace.
% 
% wssave('pat*') List all variables with names 'pat*' and save them from the caller workspace to the base workspace.
% 
% wssave({'var1','var2'}) Save variables named 'var1' and 'var2' from the caller workspace to the base workspace.
%
% Created: 2009-11-05.
% Rev. by Guillaume Maze on 2013-07-25: Added the wild card * possibility
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

function varargout = wssave(varargin)

ws_base   = evalin('base','who()');
ws_caller = evalin('caller','who()');

switch nargin
	case 1  %%% SAVE SPECIFIC VARIABLES:
		vlist = varargin{1};
		if isnumeric(vlist)
			error('I can only save variables given by a string !');
		elseif ischar(vlist)
			if strfind(vlist,'*')
				pat = vlist; clear vlist
				pat = strrep(pat,'*','\w*');
				vlist = {};
				for ii = 1 : length(ws_caller)
					if ~isempty(regexp(ws_caller{ii},pat))
						vlist = cat(1,vlist,ws_caller{ii});
					end% if 
				end% for ii
			else
				vlist = {vlist};
			end% if 
		end
		for ii = 1 : length(vlist)
			if ~strcmp(vlist{ii},'ans') 
				if ismember(vlist{ii},ws_caller)
					[iv iv] = ismember(vlist{ii},ws_caller);
					tmp = evalin('caller',ws_caller{iv});
					assignin('base',ws_caller{iv},tmp);
				else
					warning(sprintf('Cannot save ''%s'' because it is not in the caller workspace',vlist{ii}));
				end
			end
		end
	otherwise %%% SAVE ALL VARIABLES:
		for ii = 1 : length(ws_caller)
		   if ~strcmp(ws_caller{ii},'ans')
		      tmp = evalin('caller',ws_caller{ii});
		      assignin('base',ws_caller{ii},tmp);
		   end
		end
end%if which variables to load



end %functionwssave