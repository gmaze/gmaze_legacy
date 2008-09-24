%DEF All components of the relative vorticity

% Map projection:
m_proj('mercator','long',subdomain.limlon,'lat',subdomain.limlat);
%m_proj('mercator','long',subdomain2.limlon,'lat',subdomain2.limlat);
%m_proj('mercator','long',subdomain.limlon,'lat',[25 40]);
%m_proj('mercator','long',[subdomain.limlon(1) 360-24],'lat',[25 50]);

% Which variables to plot:
wvar = [1:3];
iz = 2; % Surface
%iz = 6; % Core of the Gulf Stream
%iz = 22; % Under the Gulf Stream

figure(12);clf;hold on;iw=1;jw=length(wvar);
  
for ip = 1 : length(wvar)

% Variables loop:
  % Default:
  CBAR = 'h'; % Colorbar orientation
  Tcontour = [17 19]; Tcolor = [0 0 0]; % Theta contours
  Hcontour = -[0:200:600]; Hcolor = [0 0 0]; % MLD contours
  unit = ''; % Default unit
  load mapanom2 ; N = 256; c = [0 0]; cmap = jet; % Colormaping
  showT = 1; % Iso-Theta contours
  showW = 0; % Windstress arrows
  showH = 0; colorW = 'w'; % Mixed Layer Depth
  showCLIM = 0; % Show CLIMODE region box
  CONT  = 0; % Contours instead of pcolor
  CONTshlab = 0; % Show label for contours plot
  colorCOAST = [0 0 0]; % Land color
  SHADE = 'flat'; % shading option
  
  N     = 32;
  c     = [12 30];
  cx    = [-(1+2*c(1)) 1+2*c(2)]*6e-5; cmap = mapanom;
  titf  = 'OMEGA';
  
switch wvar(ip)
 case 1
  C     = -squeeze(OX(iz,:,:));
  Clon  = OXlon; Clat = OXlat;
  tit   = strcat('\omega_x = - \partial v / \partial z');
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  unit  = '1/s';
 case 2
  C     = -squeeze(OY(iz,:,:));
  Clon  = OYlon; Clat = OYlat;
  tit   = strcat('\omega_y =  \partial u / \partial z');
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  %N     = 256;
  %c     = [10 10];
  %cx    = [-(1+2*c(1)) 1+2*c(2)]*6e-5; cmap = mapanom;
  unit  = '1/s';
 case 3
  C     = squeeze(ZETA(iz,:,:));
  Clon  = ZETAlon; Clat = ZETAlat;
  tit   = strcat('\zeta = \partial v / \partial x - \partial u / \partial y');
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  %N     = 256;
  %c     = [10 10];
  %cx    = [-(1+2*c(1)) 1+2*c(2)]*6e-5; cmap = mapanom;
  unit  = '1/s';
end %switch what to plot


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw variable:
sp=subplot(iw,jw,ip);hold on
if CONT ~= 1
  m_pcolor(Clon,Clat,C);
  shading(SHADE);
  colormap(logcolormap(N,c(1),c(2),cmap));
else 
  [cs,h] = m_contourf(Clon,Clat,C,CONTv);
  colormap(mycolormap(logcolormap(N,c(1),c(2),cmap),length(CONTv)));
  if CONTshlab
    clabel(cs,h,'labelspacing',200,'fontsize',8)
  end
end
caxis(cx);
if ip == 2
  ccol = colorbar(CBAR,'fontsize',10);
  ctitle(ccol,unit);
  posiC = get(ccol,'position');
  set(ccol,'position',[.2 posiC(2) 1-2*.2 .02]);
end
title(tit);
m_coast('patch',colorCOAST);
m_grid('xtick',360-[20:5:80],'ytick',[20:2:50]);
set(gcf,'name',titf);


if showT
  [cs,h] = m_contour(Tlon,Tlat,squeeze(T(1,:,:)),Tcontour);
  clabel(cs,h,'fontsize',8,'color',[0 0 0],'labelspacing',200);
  for ih=1:length(h)
    set(h(ih),'edgecolor',Tcolor,'linewidth',1);
  end
end %if show THETA contours

if showW
      dx = 10*diff(Txlon(1:2)); dy = 8*diff(Txlat(1:2));
      dx = 20*diff(Txlon(1:2)); dy = 10*diff(Txlat(1:2));
      lo = [Txlon(1):dx:Txlon(length(Txlon))];
      la = [Txlat(1):dy:Txlat(length(Txlat))];
      [lo la] = meshgrid(lo,la);
      Txn = interp2(Txlat,Txlon,Tx',la,lo);
      Tyn = interp2(Txlat,Txlon,Ty',la,lo);
      s = 2;
      m_quiver(lo,la,Txn,Tyn,s,colorW,'linewidth',1.25);
%      m_quiver(lo,la,-(1+sin(la*pi/180)).*Txn,(1+sin(la*pi/180)).*Tyn,s,'w');
      m_quiver(360-84,47,1,0,s,'w','linewidth',1.25);
        m_text(360-84,48,'1 N/m^2','color','w');
end %if show windstress

if showH
  %[cs,h] = m_contour(MLDlon,MLDlat,MLD,Hcontour);
  cm = flipud(mycolormap(jet,length(Hcontour)));
  cm = mycolormap([linspace(0,0,20); linspace(1,.5,20) ;linspace(0,0,20)]',length(Hcontour));
  cm = [0 1 0 ; 0 .6 0 ; 0 .2 0 ; 0 0 0];
  for ii = 1 : length(Hcontour) 
    [cs,h] = m_contour(MLDlon,MLDlat,MLD,[1 1]*Hcontour(ii)); 
    if ~isempty(cs)
%    clabel(cs,h,'fontsize',8,'color',[0 0 0],'labelspacing',300);
    clabel(cs,h,'fontsize',8,'color',cm(ii,:),'labelspacing',600,'fontweight','bold');
    for ih=1:length(h)
%      set(h(ih),'edgecolor',Hcolor,'linewidth',1);
      set(h(ih),'edgecolor',cm(ii,:),'linewidth',1.2);
    end
    end
  end
end %if show Mixed Layer depth

if showCLIM
  m_line(360-[71 62 62 71 71],[36 36 40.5 40.5 36],'color','r','linewidth',1.5)
end

%suptitle(strcat('Relative vorticity component at depth:',num2str(OYdpt(iz)),'m'));

  
end %for ip
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 1 % Show the date in big in the upper left corner
  spp=subplot('position',[0 .95 .25 .05]);
  p=patch([0 1 1 0],[0 0 1 1],'w');
  set(spp,'ytick',[],'xtick',[]);
  set(spp,'box','off');
  text(0.1,.5,num2str(TIME(it,:)),'fontsize',16,...
       'fontweight','bold','color','r','verticalalign','middle');
end  


%%%%%%%%%%%%%%%%
drawnow
set(gcf,'position',[4 48 888 430]);
videotimeline(num2str(zeros(size(TIME,1),1)),it,'b')
%videotimeline(TIME,it,'b')
if prtimg
set(gcf,'color','white') 
set(findobj('tag','m_grid_color'),'facecolor','none')
set(gcf,'paperposition',[0.6 6.5 25 14]);
exportj(gcf,1,strcat(outimg,sla,titf,'.',snapshot));
end %if

