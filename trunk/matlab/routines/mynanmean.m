% NANMEAN Average or mean value of matrix with NaN.
%
% Y = NANMEAN(X,[DIM])
%   For vectors, NANMEAN(X) is the mean value of the elements in X. NaN
%   values are not taken account. For matrices, NANMEAN(X) is a row 
%   vector containing the mean value of each column. 
%   THIS FUNCTION IS NOW AVAILABLE ONLY FOR 2-D ARRAY !
%
%   NANMEAN(X,DIM) takes the mean along the dimension DIM of X. 
%
%   Example: If X = [0 NaN
%                    3  5]
%
%   then nanmean(X,1) is [1.5 5] and nanmean(X,2) is [0
%                                                     4]
%
%   See also MEAN, MEDIAN, STD, MIN, MAX, COV.
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

  function y = nanmean(x,dim)

if nargin==1, 

  for iy = 1 : size(x,2)
      X = x(:,iy);
      if isempty( find(isnan(X)==1) )==1
         y(iy) = mean(X);
      else
         som = 0; ntot = 0;
         for ix = 1 : size(x,1)
            if isnan(X(ix))~=1
               som = som + X(ix) ;
               ntot = ntot + 1;
            end%if
         end %for
         if som==0
            y(iy) = NaN;
         else
            y(iy) = som/ntot;
         end%if
      end%if
  end%for

else
  if dim == 1

  for iy = 1 : size(x,2)
      X = x(:,iy);
      if isempty( find(isnan(X)==1) )==1
         y(iy) = mean(X);
      else
         som = 0; ntot = 0;
         for ix = 1 : size(x,1)
            if isnan(X(ix))~=1
               som = som + X(ix) ;
               ntot = ntot + 1;
            end%if
         end %for
         if som==0
            y(iy) = NaN;
         else
            y(iy) = som/ntot;
         end%if
      end%if
  end%for

  elseif dim == 2

  for ix = 1 : size(x,1)
      X = x(ix,:);
      if isempty( find(isnan(X)==1) )==1
         y(ix) = mean(X);
      else
         som = 0; ntot = 0;
         for iy = 1 : size(x,2)
            if isnan(X(iy))~=1
               som = som + X(iy) ;
               ntot = ntot + 1;
            end%if
         end %for
         if som==0
            y(ix) = NaN;
         else
            y(ix) = som/ntot;
         end%if
      end%if
  end%for
  y = y';

  end%if dim

end
