% mycolormaps_create H1LINE
%
% [] = mycolormaps_create(which_cmap)
% 
% HELPTEXT
%
%
% Created: 2009-06-18.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = mycolormaps_create(varargin)

if nargin == 1
	Icmap = varargin{1};
else
	Icmap = 1;
end

switch Icmap
	case 1
		ii=0;clear clsit
		%ii=ii+1; clsit(ii,:) = [100 0 150];
		ii=ii+1; clsit(ii,:) = [200  0  250];
		ii=ii+1; clsit(ii,:) = [100  0  250];
		%ii=ii+1; clsit(ii,:) = [75  0  150];
		ii=ii+1; clsit(ii,:) = [ 50   0  200];
		%ii=ii+1; clsit(ii,:) = [ 0   0  250]; % blue
		ii=ii+1; clsit(ii,:) = [ 0  125 250];
		%ii=ii+1; clsit(ii,:) = [ 0  250 250]; % 
		ii=ii+1; clsit(ii,:) = [ 0  250  0 ]; % green
		ii=ii+1; clsit(ii,:) = [250 250  0 ];
		ii=ii+1; clsit(ii,:) = [250  0   0 ]; % red
		ii=ii+1; clsit(ii,:) = [220  60  20];
		%ii=ii+1; clsit(ii,:) = [210 120  40];
		%ii=ii+1; clsit(ii,:) = [190 180  60];
		ii=ii+1; clsit(ii,:) = [170 170  170];
		ii=ii+1; clsit(ii,:) = [1 1  1]*255;
		clsit = clsit / 255;
		cmap = usercolormap(clsit); 
		cmap(cmap>1)=1;
		cmap(cmap<0)=0;
end

switch nargout
	case 1
		varargout(1) = {cmap};
end


end %function