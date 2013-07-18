% plotts Plot Temperature, Salinity on a T,S diag
%
% [p,h,cs] = plotts(TEMP,SALT,[PRES])
% 
% Plot temperature TEMP and salinity SALT on a T/S diagram.
% Output:
% - p: handle for points
% - h: handle for density contours
% - cs: density contours matrix
%
% Created: 2009-06-04.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = plotts(varargin)

T  = varargin{1};
S  = varargin{2};
T  = T(:);
S  = S(:);
n  = length(T);

if nargin >= 3
	if ~ischar(varargin{3})
		P = varargin{3};
		P = P(:);
	else
		P = zeros(1,length(T));
	end
else
	P = zeros(1,length(T));
end

N = 50;
Tlim = [nanmin(T) nanmax(T)] + [-1 1];   Tax = linspace(Tlim(1),Tlim(2),N);
Slim = [nanmin(S) nanmax(S)] + [-1 1]/2; Sax = linspace(Slim(1),Slim(2),N);
%Tax = linspace(-2,40,N);
%Sax = linspace(0,42,N);
for it = 1 : N
	for is = 1 : N
		ST(it,is) = densjmd95(Sax(is),Tax(it),P(it)) - 1000;
	end%for is
end%for it
contST = 0:.1:100;

%%%%%%%%%
hold on
% p = plot(T,S,'+');
% [cs,h] = contour(Tax,Sax,ST',contST,'edgecolor',[1 1 1]*.5);
% axis([Tlim Slim] + [-1 1 -.5 .5]);
if nargin==3
	if ischar(varargin{3})
		p = plot(S,T,varargin{3});
	end
elseif nargin>3
	p = plot(S,T,varargin{4:end});
else
	p = plot(S,T,'+');
end
[cs,h] = contour(Sax,Tax,ST,contST,'edgecolor',[1 1 1]*.5);
axis([Slim Tlim] + [-.5 .5 -1 1]);
box on;

%%%%%%%%%
switch nargout
	case 1
		varargout(1) = {p};
	case 2
		varargout(1) = {p};
		varargout(2) = {h};
	case 3
		varargout(1) = {p};
		varargout(2) = {h};
		varargout(3) = {cs};
end


end %function