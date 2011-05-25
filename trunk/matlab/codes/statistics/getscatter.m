% GETSCATTER Get scatter plot distribution
%
% [P,Paxis] = GETSCATTER(C,dC)
%
% Get the distribution of values in C with
% resolution dC
%
%
% Copyright (c) 2007 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function [varargout] = getscatter(C,dC)


%  C = Q.*mask;
%  C = squeeze(C(:,:,200));
%  dC = 1e-10;
  
% Get the dimensions for min max values:  
s = size(C);


% Adjust the resolution:
if dC<1
	C = fix(C/dC)*dC;
else
	C = fix(C*dC)/dC;
end

% Get extremum:
for idim = 1 : length(s)
  if idim == 1
     Cmin = nanmin(C);
     Cmax = nanmax(C); 
  else
     Cmin = nanmin(Cmin);
     Cmax = nanmax(Cmax); 
  end %if
end %for idim


% Count values:
Paxis = [Cmin:dC:Cmax];
P = ones(1,length(Paxis)).*NaN;
for i = 1 : length(Paxis)
    pt = find(C==Paxis(i));
    if ~isempty(pt)
      P(i) = length(pt);
    end
end %for i

switch nargout
 case 1
  varargout(1) = {P};
 case 2
  varargout(1) = {P};
  varargout(2) = {Paxis};
end
