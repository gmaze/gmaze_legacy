% expt Export a figure to pdf format in a temporary folder/file
%
% [FILENAME] = expt([GCF,ORIENTATION,KEEPFOOTNOTE])
% 
% Export a figure to pdf format in a temporary folder/file.
% Using the exportp function print a figure into the folder:
%	./tmp/fig_DATE.pdf
% where DATE is the exact date of printing.
%
% Created: 2011-02-21.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = expt(varargin)

if ~exist('tmp','dir')
	mkdir('tmp');
end

fname = datestr(now,'yyyymmdd_HHMMSS');
fname = fullfile('tmp',fname);

switch nargin
	case 0
		exportp(gcf,0,fname);
	case 1
		if ishandle(varargin{1})
			exportp(varargin{1},0,fname);
		else
			exportp(gcf,varargin{1},fname);
		end% if 
	case 2
		exportp(varargin{1},varargin{2},fname);
	case 3
		exportp(varargin{1},varargin{2},fname,varargin{3});
	otherwise
		error('Bad number of arguments');
end% switch 

if nargout == 1
	varargout(1) = {fname};
end

end %functionexpt
























