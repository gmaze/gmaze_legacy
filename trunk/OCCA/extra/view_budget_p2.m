% Created by Guillaume Maze on 2008-10-01.
% Copyright (c) 2008 Guillaume Maze. 
% http://www.guillaumemaze.org/codes

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the typical year:
figure;   figure_land; hold on
sg = -1;
yl = [-1 1]*10;
pp=plot(tY,Cm(1,:),tY,sg*Cm(2,:),tY,sg*Cm(5,:),tY,sg*sum(Cm([3 4 6 7],:),1),tY,sg*Cm([4 3 6 7],:));
set(pp(1:4),'linewidth',2);
set(pp(1),'color','c'); % census
set(pp(2),'color',[0 0 1]); % budget
set(pp(3),'color','r'); % Qnet
set(pp(4:8),'color','k'); % all oceanic fluxes
set(pp(6),'linestyle','--'); %
set(pp(7),'linestyle','-.');
set(pp(8),'linestyle','--'); 

grid on, box on
set(gca,'xtick',tY(str2num(datestr(tY,'mm'))==1))
datetick('x','mmm'); 
xlabel('Typical year (mean over 2004-2006)');

ll=legend(pp,'Volume (census)','Volume (Nat.)',...
	'Air-sea Heat fluxes','Oceanic fluxes:',...
	'Diffusion','Advection','Residual Terms','Artifical term',...
	'location','southwest');
ylabel('Sv.y');
set(gca,'ylim',yl);
set(gca,'ytick',[yl(1):1:yl(2)]);
set(gca,'xlim',[tY(1) tY(end)]);
line(get(gca,'xlim'),[0 0],'color','k')
