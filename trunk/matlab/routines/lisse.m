% LISSE Smooth a scalar array with a running mean
%
% VAR = LISSE(FIELD,LX,LY)
%    Smooth a scalar field by running mean: compute a runnning mean
%    of width LX (zonaly or dimension 1) and LY (meridiannaly or
%    dimension 2). FIELD is supposed to be symetric zonaly.
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

function [result]=lisse(champ,lx,ly)

if nargin ~=3
  help lisse.m
  error('Wrong number of argument(s)')
  return
end %if

[nj ni]=size(champ);

result=champ;
vara=champ;
vara_tmp=champ;
vara_tmp2=champ;

% Lissage zonal
for iy=1:ni
  for jx=1+lx:nj-lx % Balayage en longitude
    vara_tmp(jx,iy) = mean( champ(jx-lx:jx+lx,iy) );
  end
end
% Sur les bords
  for jx=1:lx
    vara(jx,:)      = vara_tmp(1,:);
    vara(nj-jx+1,:) = vara_tmp(nj,:);
  end

% Lissage meridien
  for iy=1+ly:ni-ly % Balayage en latitude
    vara_tmp2(:,iy) = squeeze( mean( champ(:,iy-ly:iy+ly) , 2) );
  end

  vara=(vara_tmp+vara_tmp2)./2;


for iy=1:ni
  for jx=1:nj
     if( isnan(vara(jx,iy)) == 1 )
       vara(jx,iy)=champ(jx,iy);
     end
  end
end


result=vara;
