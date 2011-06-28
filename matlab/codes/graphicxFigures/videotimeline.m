% VIDEOTIMELINE Add a video timeline to a plot
%
% [] = videotimeline(TIME,IT,POSITION)
%
% TIME contains all the time line serie as: (1:nt,'YYYYMMDDHHMM')
% IT contains the current time
% POSITION = 't'
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

function varargout = videotimeline(TIME,it,POSIT)

[nt nc] = size(TIME);

DY = .02;
DX = 1/nt;

bgcolor=['w' 'r'];
bdcolor=['k' 'r'];
txtcolor=['k' 'w'];
fts = 8;

%builtin('figure',gcf);hold on

for ii = 1 : nt
  %p=patch([ii-1 ii ii ii-1]*DX,[1 1 0 0]*DY,'w');
  if POSIT == 't'
    s=subplot('position',[(ii-1)*DX 1-DY DX DY]);
  else
    s=subplot('position',[(ii-1)*DX 0 DX DY]);
  end
  p=patch([0 1 1 0],[0 0 1 1],'w');
  set(s,'ytick',[],'xtick',[]);
  set(s,'box','on');
  tt = text(.35,0.5,TIME(ii,:));
  
  if ii == it
    set(p,'facecolor',bgcolor(2));
    set(p,'edgecolor',bdcolor(2));
    %set(s,'color',bgcolor(2));
    set(tt,'fontsize',fts,'color',txtcolor(2));
  else
    set(p,'facecolor',bgcolor(1));
    set(p,'edgecolor',bdcolor(1));
    %set(s,'color',bgcolor(1));
    set(tt,'fontsize',fts,'color',txtcolor(1));
  end
  to(ii) = tt;
end

switch nargout
	case 1
		varargout(1) = {to};
end






