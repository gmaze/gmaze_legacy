%
% [] = videotimeline(TIMERANGE,IT,POSITION)
%
% TIMERANGE contains all the time line serie
% TIME contains the current time
%

function varargout = videotimeline(TIME,it,POSIT)


[nt nc] = size(TIME);

DY = .02;
DX = 1/nt;

bgcolor=['w' 'r'];
bdcolor=['k' 'r'];
txtcolor=['k' 'w'];
fts = 8;

figure(gcf);hold on

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
  tt=text(.35,0.5,TIME(ii,:));
  
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
end
