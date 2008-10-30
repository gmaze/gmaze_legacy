% LOGCOLORMAP Stretch a colormap extremum toward black and white
%
% cmap = logcolormap(Ncol,c1,c2,cmapO)
% Ncol is the number of points in the colormap
% [c1 c2] are the stretching parameters
% cmap0 is the initial colormap to stretch (N,3)
%
% EQ:
% cmap = logcolormap(256,1,2,jet)
%
% Copyright (c) 2006 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function cmap = logcolormap(Ncol,c1,c2,cmapO);

cmapO = mycolormap(cmapO,Ncol);

colD = [1 1 1];
colU = [0 0 0];


cmapD = [linspace(colD(1),cmapO(1,1),c1*Ncol) ; ...
	 linspace(colD(2),cmapO(1,2),c1*Ncol) ; ...
	 linspace(colD(3),cmapO(1,3),c1*Ncol)]';
%cmapD = ones(c1*Ncol,3)*0;



cmapU = [linspace(cmapO(Ncol,1),colU(1),c2*Ncol) ; ...
	 linspace(cmapO(Ncol,2),colU(2),c2*Ncol) ; ...
	 linspace(cmapO(Ncol,3),colU(3),c2*Ncol)]';
%cmapU = ones(c2*Ncol,3)*0;


if c1 == 0 & c2 ~= 0
cmap = [...
        cmapO ; ...
	cmapU ; ...
       ];
end

if c1 ~= 0 & c2 ==0
cmap = [...
	cmapD ; ...
        cmapO ; ...
       ];
end
  
if c1 ~= 0 & c2 ~= 0  
cmap = [...
	cmapD ; ...
        cmapO ; ...
	cmapU ; ...
       ];
end

if c1 == 0 & c2 == 0  
cmap = [cmapO];
end

cmap = [cmapD;cmapO;cmapU];

if 0
n = ceil(Ncol/4);
u1 = [(1:1:n)/n ones(1,n-1) (n:-1:1)/n]';

x = log( linspace(1,exp(1),n) ).^2;
%u = [x ones(1,n-1) (n:-1+dx:1)/n]';
u = [x ones(1,n-n/2) fliplr(x)]';



g = ceil(n/2) - (mod(Ncol,4)==1) + (1:length(u1))';

%b = - (1:length(u))'  ;

b = g - n ;
r = g + n ;

r(r>Ncol) = [];
g(g>Ncol) = [];
b(b<1)    = [];

cmap      = zeros(Ncol,3);
cmap(r,1) = u1(1:length(r));
cmap(g,2) = u1(1:length(g));
cmap(b,3) = u1(end-length(b)+1:end);
end




if 0
% Set the colormap:
clf;colormap(cmap);
hold on
plot(cmap(:,1),'r*-');
plot(cmap(:,2),'g*-');
plot(cmap(:,3),'b*-');
colorbar
grid on
end
