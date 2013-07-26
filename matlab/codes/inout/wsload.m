% wsload Load all (or list of) variables of the base workspace into a function workspace
%
% wsload() Load all variables from the base workspace to the caller workspace.
% 
% wsload('var') Load variable named 'var' from the base workspace to the caller workspace.
% 
% wsload('pat*') List all variables with names 'pat*' and load from the base workspace to the caller workspace.
% 
% wsload({'var1','var2'}) Load variables named 'var1' and 'var2' from the base workspace to the caller workspace.
% 
% Created: 2009-11-05.
% Rev. by Guillaume Maze on 2013-07-25: Added wild card * loading type and modified help
% Rev. by G. Maze on 2011-07-28: Change warning to error when trying to load a nonexistent variable.
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
			if strfind(vlist,'*')
				pat = vlist; clear vlist
				pat = strrep(pat,'*','\w*');
				vlist = {};
				for ii = 1 : length(ws_base)
					if ~isempty(regexp(ws_base{ii},pat))
						vlist = cat(1,vlist,ws_base{ii});
					end% if 
				end% for ii
			else
				vlist = {vlist};
			end% if			
		end% if 
		for ii = 1 : length(vlist)
			if ~strcmp(vlist{ii},'ans') 
				if ismember(vlist{ii},ws_base)
					[iv iv] = ismember(vlist{ii},ws_base);
					tmp = evalin('base',ws_base{iv});
					assignin('caller',ws_base{iv},tmp);
				else
					error(sprintf('Cannot load ''%s'' because it is not in the base workspace',vlist{ii}));
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












