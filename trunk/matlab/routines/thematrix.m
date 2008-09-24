% [] = thematrix(dAZ,nrevol)
%
% This function creates a motion camera effect
% on the current 3D figure
% This "a la" MATRIX(c) camera effect makes the object
% to spin around it vertical axis.
%
% Help: If the 3D object shows different aspect ratio
%       during the movement, try to zoom out of it
%       with camzoom
%
% Created by Guillaume Maze on 2006/08/17
% Copyright (c) 2006 Guillaume Maze. 

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

function [] = thematrix(varargin)

% Default setting:
  dAZ = 5;
  nrevol =1;
  
% Custom:  
switch nargin
 case 1
  arg = varargin(1); arg = arg{:};
  dAZ = arg;
 case 2
  arg = varargin(1); arg = arg{:};
  dAZ = arg;
  arg = varargin(2); arg = arg{:};
  nrevol = arg;
end
  
% Initial view
[az0,el0] = view;

  
% Number of revolution:
for irevol = 1 : nrevol

  % THE MATRIX effect !
  for iv = az0 : dAZ : az0+360
     view(iv,el0);
     drawnow
  end

end

