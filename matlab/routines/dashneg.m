% [] = dashneg(h)
% 
% Change linestyle of h for negative values
% to dashed.
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
function varargout = dashneg(h)
	

styl='--';
if nargin==2
	styl=varargin{2};
end

ch = get(h,'children');

if ~isempty(ch)
%	h=ch;
end

val = get(h,'userData');
set(h(find(cell2mat(val)<0)),'linestyle',styl);

