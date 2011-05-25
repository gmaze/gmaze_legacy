% dim Give the number of dimensions of a field
%
% n = dim(C)
% 
% Compute the dimension of C, ie the number of
% dimensions of C
%
%
% Created: 2009-02-24.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function n = dim(varargin)

C = varargin{1};
a = size(C);
n = length(a);
if sum(a)/length(a) == 1
	n = 1;
end

end %function