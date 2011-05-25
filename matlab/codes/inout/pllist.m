% pllist Shortcut for function get_plotlistdef(MASTER,'.')
%
% [LIST] = pllist(MASTER,[SUBDIR])
% 
% Simply execute:
%	get_plotlistdef(MASTER,SUBDIR);
%
% See also:
%	get_plotlistdef
%
% Created: 2009-08-25.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = pllist(varargin)

switch nargin
	case 1
		MASTER = varargin{1};
		SUBDIR = '.';
	case 2
		MASTER = varargin{1};
		SUBDIR = varargin{2};
	otherwise
		error('Bad number of arguments')
end

if nargout == 1
	out = get_plotlistdef(MASTER,SUBDIR);
	varargout(1) = {out};
else
	get_plotlistdef(MASTER,SUBDIR);
end




end %function