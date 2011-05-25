% CURVEAREA Compute curve area in a crude way
%
% AREA = CURVEAREA(CB,X)
% where CB(NX) define the curve and X the axis
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


function [A] = curvearea(Cb,x)



nx=length(Cb);
A = 0;

for ix=1:nx
  if ix+1>nx
     afx=nx;
  else 
     afx=ix+1;
  end
  if ix-1<1
     bfx=1;
  else 
     bfx=ix-1;
  end
  dx = (x(afx)-x(bfx))/2;
   A = A + Cb(ix)*dx;
end
