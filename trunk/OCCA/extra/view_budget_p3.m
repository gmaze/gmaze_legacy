
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SIMPLIFIED:
% Plot the typical year:
figure;   figure_land; hold on
clear pp
sg = -1;
yl = [-1 1]*10;
pp=plot(tY,Cm(1,:),...
		tY,sg*Cm(2,:),...
		tY,sg*Cm(5,:),...
		tY,sg*sum(Cm([3 4 6 7],:),1),...
		tY,sg*sum(Cm([4 6 7],:)),...
		tY,sg*Cm(3,:));
set(pp(1:4),'linewidth',2);
set(pp(1),'color','c');      % census
set(pp(2),'color',[0 0 1]);  % budget
set(pp(3),'color','r');      % Qnet
set(pp(4:end),'color','k');  % all oceanic fluxes
set(pp(6),'linestyle','--'); %
%set(pp(7),'linestyle','-.');
%set(pp(8),'linestyle','--'); 

grid on, box on
set(gca,'xtick',tY(str2num(datestr(tY,'mm'))==1))
datetick('x','mmm'); 
xlabel('Typical year (mean over 2004-2006)');

ll=legend(pp,'Volume (census)','Volume (budget)',...
	'Air-sea Heat fluxes','Oceanic fluxes:',...
	'Diffusion','Advection',...
	'location','southwest');
ylabel('Sv.y');
set(gca,'ylim',yl);
set(gca,'ytick',[yl(1):1:yl(2)]);
set(gca,'xlim',[tY(1) tY(end)]);
line(get(gca,'xlim'),[0 0],'color','k')
set(gcf,'name','Simplified budget for the paper');

if prtimg,
	footnote('del');
	print(gcf,'-depsc2',strcat('img/',RUNlabel,'_VolBdg_0406.eps'));
	footnote;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SIMPLIFIED:
% Plot the typical year:
figure;   figure_land; hold on
clear pp
sg = -1;
yl = [-1 1]*10;
difcurv = sg*sum(Cm([4 6 7],:))+sg*Cm(3,:)-Cm(11,:); % We include the advection scheme diffusion
advcurv = Cm(11,:); % Must be the volume flux at open boundaries
pp=plot(tY,Cm(1,:),...
		tY,sg*Cm(2,:),...
		tY,sg*Cm(5,:),...
		tY,sg*sum(Cm([3 4 6 7],:),1),...
		tY,difcurv,...
		tY,advcurv,...
		tY,sg*Cm(3,:)-Cm(11,:));
set(pp(1:4),'linewidth',2);
set(pp(1),'color','c');      % census
set(pp(2),'color',[0 0 1]);  % budget
set(pp(3),'color','r');      % Qnet
set(pp(4:end),'color','k');  % all oceanic fluxes
set(pp(6),'linestyle','--'); %
%set(pp(7),'linestyle','-.');
%set(pp(8),'linestyle','--'); 

grid on, box on
set(gca,'xtick',tY(str2num(datestr(tY,'mm'))==1))
datetick('x','mmm'); 
xlabel('Typical year (mean over 2004-2006)');

ll=legend(pp,'Volume (census)','Volume (budget)',...
	'Air-sea Heat fluxes','Oceanic fluxes:',...
	'Diffusion','Advection',...
	'location','southwest');
ylabel('Sv.y');
set(gca,'ylim',yl);
set(gca,'ytick',[yl(1):1:yl(2)]);
set(gca,'xlim',[tY(1) tY(end)]);
line(get(gca,'xlim'),[0 0],'color','k')
set(gcf,'name','Simplified budget for the paper');



