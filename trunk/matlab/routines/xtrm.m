% extremum = XTRM(C)
%
% Find the extremum value of a 2D field
%
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

function varargout = xtrm(C);

[m1 im1a] = max(C);
[m1 im1b] = max(m1);

[m2 im2a] = min(C);
[m2 im2b] = min(m2);

if abs(m1)>abs(m2)
     M = m1;
     if(im1a==1)&(im1b~=1),im=im1b;end
     if(im1a~=1)&(im1b==1),im=im1a;end
     if(im1a==1)&(im1b==1),im=im1a;end
     if(im1a~=1)&(im1b~=1),im=[im1a im1b];end
else
     M = m2;
     if(im2a==1)&(im2b~=1),im=im2b;end
     if(im2a~=1)&(im2b==1),im=im2a;end
     if(im2a==1)&(im2b==1),im=im2a;end
     if(im2a~=1)&(im2b~=1),im=[im2a im2b];end  
end

switch nargout
  case 0
     varargout(1)={M};
  case 1
     varargout(1)={M};
  case 2
     varargout(1)={M};
     varargout(2)={im};
end
