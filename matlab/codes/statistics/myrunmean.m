% MYRUNMEAN Perform running mean on an array
%
% A = myrunmean(a,NF,bool,dirm)
% compute runing mean of a in direction dirm with
% NF mean, i.e at each time step
%  A(i) --> mean( a(i-NF/2:i+NF/2) ,dirm )
%
% if bool == 1, A has only the N-NF elemts
% if bool == 0, A is Nan outside and has N elmts
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

function A = myrunmean(a,NF,bool,dirm)


N = length(a);
NF = 2*round(NF/2);
B = ones(1,N-NF);

for n = NF/2+1:N-NF/2
  B(n-NF/2) = mean( a(n-NF/2:n+NF/2) , dirm );
end

if bool == 0 
  A = NaN * a; A(NF/2+1:N-NF/2) = B; 
else
  A = B;
end

