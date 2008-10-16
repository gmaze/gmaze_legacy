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
% Simple time series
figure; figure_land; hold on
sg = -1;
yl = [-18 18];

pp=plot(t,abs(sg)*(Vvol-Vvol(1)),t,sg*(VtendN),t,sg*Vq,t,sg*(Vadv+Vdiff+Vall+VtendA),...
		t,sg*Vdiff,t,sg*Vadv,t,sg*Vall,t,sg*VtendA);
set(pp(1:4),'linewidth',2);
set(pp(1),'color','c'); % census
set(pp(2),'color',[0 0 1]); % budget
set(pp(3),'color','r'); % Qnet
set(pp(4:8),'color','k'); % all oceanic fluxes
set(pp(6),'linestyle','--'); %
set(pp(7),'linestyle','-.');
set(pp(8),'linestyle',':'); % Artif

grid on, box on

ylabel('Sv.y');
xlabel('Time from Nov04 to Oct06');
set(gca,'xlim',[t(1) t(end)]);
datetick('x','yyyy');axis tight;set(gca,'ylim',yl);
%set(gca,'ylim',[-2 1.5]*1e14) 
for it = 1 : nt
  im = str2num(datestr(t(it),'mmdd'));
  if im == 101 | im == 201 | im == 301 | im == 401
    line([1 1]*t(it),get(gca,'ylim'),'color','k','linestyle',':');
  end
end
set(gca,'ylim',yl);
set(gca,'xlim',[datenum(2003,11,1,0,0,0) datenum(2006,11,30,0,0,0)]);
%set(gca,'ytick',[yl(1):1:yl(2)]);

legend(pp,'Volume (census)','Volume (Nat.)',...
	'Air-sea Heat fluxes','Oceanic fluxes:',...
	'Diffusion','Advection','Residual Terms','Artifical term',...
	'location','northoutside');
	
if 0
	line([1 1]*datenum(2003,11,1,12,0,0)+0*275-1,get(gca,'ylim'),'linestyle','--');
	line([1 1]*datenum(2003,11,1,12,0,0)+1*275-1,get(gca,'ylim'),'linestyle','--');
	line([1 1]*datenum(2003,11,1,12,0,0)+2*275+1-1,get(gca,'ylim'),'linestyle','--');
	line([1 1]*datenum(2003,11,1,12,0,0)+3*275+1-1,get(gca,'ylim'),'linestyle','--');
	line([1 1]*datenum(2003,11,1,12,0,0)+4*275+1-1,get(gca,'ylim'),'linestyle','--');
end

