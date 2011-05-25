% MYCOLORMAP Change colormap resolution
%
% CMAP = MYCOLORMAP(MAP,NCL) 
%    Change colormap MAP resolution to NCL points 
%
%
% Copyright (c) 2004 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function [cmap]=mycolormap(map,ncl)


[ic ii]=size(map);

X= linspace(1,ic,ic);
XI=linspace(1,ic,ncl);
cmap=zeros(ncl,3);

for j=1:ii
   c=interp1(X,squeeze(map(:,j))',XI);
   cmap(:,j)=c';
end

