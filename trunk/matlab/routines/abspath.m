% ABSPATH Relative to Absolute path function
%
% ABSOLUTE_PATH  = ABSPATH(RELATIVE_PATH)
%
% Replace any occurence of a "~" into input path
% by the absolute home directory given by shell
% variable $HOME
%
% Created by Guillaume Maze on 2008-10-28.
% Rev. by Guillaume Maze on 2009-09-25: test !
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function newpath = abspath(varargin)


pathname = varargin{1};

[a hom] = dos('echo $HOME');
clear a

if ~isempty(hom)
	hom = strrep(hom,'.cshrc: No such file or directory.','');
	newpath = strrep(pathname,'~',strtrim(hom));
else
	newpath = pathname;
end

