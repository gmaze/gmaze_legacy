% reexportp Re-export a figure in pdf using app datas
%
% [] = reexportp([H])
% 
% Re-export a figure in pdf using app datas (orientation and file name).
% H is the figure's handle, by default the current figure is used.
%
% See also: exportp
%
% Rev. by Guillaume Maze on 2011-03-29: Default figure is the current one
% Created: 2010-07-22.
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

function varargout = reexportp(varargin)

%- Load options:
switch nargin
	case 0
		f = gcf;
	case 1
		f = varargin{1};
		if ~isnumeric(f) | ~ishandle(f) | (ishandle(f) & ~strcmp(get(f,'type'),'figure'))
			error('This is not a valid figure''s handle')
		end% if 
end% switch 

%- Load from the figure datas informations about the previous export:
if ~isappdata(f,'exportdatas')
	error('Export before Re-export this figure !')
else
	exportdatas = getappdata(f,'exportdatas');
end% if 

%- Re-export the figure:
exportp(f,exportdatas.orient,strrep(exportdatas.file,'.pdf',''),exportdatas.keepfootnote);
%exportp(f,getappdata(f,'pdf_file_orientation'),strrep(getappdata(f,'pdf_file'),'.pdf',''));

end %functionreexportp














