% pathname  = abspath(pathname)
%
% Replace any occurence of a "~" into input path
% by the absolute home directory given by shell
% variable $HOME
%
% Copyright (c) 2008 Guillaume Maze. 

% This file is part of "The-Matlab-Show"
% The-Matlab-Show is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.
% Foobar is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with The-Matlab-Show.  If not, see <http://www.gnu.org/licenses/>.
%

function newpath = abspath(varargin)
	
	
pathname = varargin{1};

[a hom] = dos('echo $HOME');
clear a

if ~isempty(hom)
	newpath = strrep(pathname,'~',strtrim(hom));
else
	newpath = pathname;
end

