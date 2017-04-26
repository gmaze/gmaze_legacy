% plotts Plot Temperature, Salinity on a T,S diag
%
% [p,h,cs,cl] = plotts(TEMP,SALT,[OPT,VAL])
% 
% Plot temperature TEMP and salinity SALT on a T/S diagram.
% Output:
% - p: handle for points
% - h: handle for density contours
% - cs: density contours matrix
% - cl: handle of density labels
% 
% Options OPT/VAL:
% - 'P' : to provide pressure array
% - 'marker'  : define plot markers
% - 'STlevel' : levels of potential density contours
% - 'STcolor' : color of the density contours
% - 'STlabel' : add labels to ST contours
% - 'STlabelstep' : how many labels to add from: STlevel(1:STlabelstep:end)
%
% Eg:
% plotts(T,S,'marker','+','plotopt',{'color','b','markersize',2})
% 
% Created: 2009-06-04.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org
% Revised: 2015-01-09 (G. Maze) Change options to handle more possibilities

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = plotts(T,S,varargin)

%- Default options:
marker  = '+';
plotopt = {'color','k'};
stlevel = 20:.1:50;
stlabel = true;
stlabelstep = 2;
stcolor = [1 1 1]/2;

%- Init
T  = T(:);
S  = S(:);
n  = length(T);

%- Load user options:
if nargin > 2
	if mod(nargin,2) ~= 0
		error('Options must come in pairs: OPTION,VALUE')
	end% if 
	for in = 1 : 2 : nargin-2
		eval(sprintf('%s = varargin{in+1};',lower(varargin{in})));
	end% for in	
	clear in
end% if

if ~exist('P','var')
	P = zeros(1,n);	
else
	P = P(:);
end% if 

%- Define density background:
N = 50;
Tlim = [nanmin(T) nanmax(T)] + [-1 1];   Tax = linspace(Tlim(1),Tlim(2),N);
Slim = [nanmin(S) nanmax(S)] + [-1 1]/2; Sax = linspace(Slim(1),Slim(2),N);
for it = 1 : N
	for is = 1 : N
		ST(it,is) = densjmd95(Sax(is),Tax(it),0) - 1000;
	end%for is
end%for it

%- Plot:
hold on
% p = plot(T,S,'+');
% [cs,h] = contour(Tax,Sax,ST',STlevel,'edgecolor',[1 1 1]*.5);
% axis([Tlim Slim] + [-1 1 -.5 .5]);
p = plot(S,T,'linestyle','none','marker',marker,plotopt{:});

[cs,h] = contour(Sax,Tax,ST,stlevel,'edgecolor',stcolor);
if stlabel
%	cl = clabel(cs,h,stlevel(1:stlabelstep:end),'labelspacing',400,'rotation',0);
	cl = clabel(cs,h,stlevel(1:stlabelstep:end),'labelspacing',400);
else 	
	cl = [];
end% if 

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
	case 4
		varargout(1) = {p};
		varargout(2) = {h};
		varargout(3) = {cs};
		varargout(4) = {cl};
end


end %function