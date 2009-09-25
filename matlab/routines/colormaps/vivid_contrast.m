% vivid_contrast H1LINE
%
% [] = vivid_contrast()
% 
% HELPTEXT
%
%
% Created: 2009-08-06.
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

function varargout = vivid_contrast(gcf,ii)

i1 = ii(1);
i2 = ii(2);
builtin('figure',gcf);
vivid([i1 i2]);
for ii = i1:[1-i1]/50:1
	colormap(vivid([ii i2]));
	pause(1e-3);
end




end %function