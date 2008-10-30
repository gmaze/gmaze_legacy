% ASSYM Compute sym. or assym. component of 2D field
%
% D = ASSYM(C,[DIR])
%
% Compute the zonaly (dim. 1) symetric or assymetric component
% of the field C(lon,lat)
% DIR = 1 (Default) : Assymetric component of C
% DIR = 2 : Zonal mean of C
%
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function output = assym(C,varargin);
  
if nargin==2
	compo = varargin{:};
else
	compo = 1;
end

[nx ny]=size(C);
switch compo
 case 1
  output = C-meshgrid(nanmean(C,1),[1:nx]);
 case 2
  output = meshgrid(nanmean(C,1),[1:nx]);
end

