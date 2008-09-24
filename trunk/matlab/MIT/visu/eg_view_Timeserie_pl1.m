%DEF 1 var per figure

% Map projection:
m_proj('mercator','long',subdomain.limlon,'lat',subdomain.limlat);
%m_proj('mercator','long',subdomain2.limlon,'lat',subdomain2.limlat);
%m_proj('mercator','long',subdomain.limlon,'lat',[25 40]);
%m_proj('mercator','long',[subdomain.limlon(1) 360-24],'lat',[25 50]);

% Which variables to plot:
wvar = [21 10 7 22];
wvar = [12];

for ip = 1 : length(wvar)
  
  figur(10+ip);clf;drawnow;hold on;iw=1;jw=1;

% Variables loop:
  % Default:
  CBAR = 'v'; % Colorbar orientation
  Tcontour = [17 19]; Tcolor = [0 0 0]; % Theta contours
  Hcontour = -[0:200:600]; Hcolor = [0 0 0]; % MLD contours
  unit = ''; % Default unit
  load mapanom2 ; N = 256; c = [0 0]; cmap = jet; % Colormaping
  uselogmap = 1; % Use the log colormap
  showT = 1; % Iso-Theta contours
  showW = 0; % Windstress arrows
  showH = 0; colorW = 'w'; % Mixed Layer Depth
  showE = 0; colorE = 'w'; % Ekman Layer Depth
  showCLIM = 1; % Show CLIMODE region box
  showQnet = 0 ; Qnetcontour = [-1000:100:1000]; % Show the Net heat flux
  CONT  = 0; % Contours instead of pcolor
  CONTshlab = 0; % Show label for contours plot
  CONTc  = 0; % Highlighted contours instead of pcolor
  CONTcshlab = 0; % Show label for contours plot
  colorCOAST = [0 0 0]; % Land color
  SHADE = 'flat'; % shading option
  
  %if it==1, mini; end 
switch wvar(ip)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1
 case 1
  C     = Diso;
  Clon  = Qlon; Clat = Qlat;
  tit   = strcat('Depth of \sigma_\theta=',num2str(iso),'kg.m^{-3}');
  showW = 0; % Windstress
  cx    = [-600 0];
  unit  = 'm';
  titf  = 'Diso';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 11
 case 11
  C     = Qiso;
  %C(isnan(C)) = 10;
  Clon  = Qlon; Clat = Qlat;
  tit   = strcat('Full potential vorticity field on iso-\sigma=',num2str(iso));
  colorCOAST = [1 1 1]*.5; % Land color
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  showT = 1; 
  Tcontour = [22 22];
  N     = 256;
  c     = [1 5];
  cx    = [-(1+2*c(1)) 1+2*c(2)]*5e-10; cmap = mapanom; %cmap = jet;
  unit  = '1/m/s';
  titf  = strcat('PViso_',num2str(iso));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 12
 case 12
  % First iso-ST have been computed in view_Timeserie
  % Here is the 2nd one (supposed to be deeper than the 1st one)
  iso2 = 25.35;
  disp('Get 2nd iso-ST')
  [Iiso mask] = subfct_getisoS(ST,iso2);
  Diso1 = Diso;
  Diso2 = ones(size(Iiso)).*NaN;
  Qiso2 = ones(size(Iiso)).*NaN;
  for ix = 1 : size(ST,3)
    for iy = 1 : size(ST,2) 
      if ~isnan(Iiso(iy,ix)) & ~isnan( Q(Iiso(iy,ix),iy,ix) )
        Diso2(iy,ix) = STdpt(Iiso(iy,ix));
        Qiso2(iy,ix) =     Q(Iiso(iy,ix),iy,ix);
      end %if
  end, end %for iy, ix
  Diso1(isnan(squeeze(MASK(1,:,:)))) = NaN;
  Diso2(isnan(squeeze(MASK(1,:,:)))) = NaN;
  for ix = 1 : size(ST,3)
    for iy = 1 : size(ST,2) 
      if isnan(Diso1(iy,ix)) & isnan(Diso2(iy,ix))
	Hbiso(iy,ix) = -Inf;
      elseif isnan(Diso1(iy,ix)) & ~isnan(Diso2(iy,ix))
	Hbiso(iy,ix) = Inf;
      elseif ~isnan(Diso1(iy,ix)) & ~isnan(Diso2(iy,ix))
	Hbiso(iy,ix) = Diso1(iy,ix) - Diso2(iy,ix);
      end
  end, end %for iy, ix
  Hbiso = Hbiso.*squeeze(MASK(1,:,:));  
  %figur(1);pcolor(Diso1);shading flat;colorbar
  %figur(2);pcolor(Diso2);shading flat;colorbar
  %figur(3);pcolor(Hbiso);shading flat;colorbar

  C     = Hbiso;
  %C(isnan(C)) = NaN;
  Clon  = STlon; Clat = STlat;
  tit   = strvcat(strcat('Height between iso-\sigma=',num2str(iso),...
			 ' and: iso-\sigma=',num2str(iso2)),...
		  strcat('(White areas are outcrops for both iso-\sigma and red areas only for: ',...
			 num2str(iso),')'));
  colorCOAST = [1 1 0]*.8; % Land color
  showW = 1; colorW = 'k';  % Windstress
  showH = 0; % Mixed layer depth
  showCLIM = 1; % CLIMODE
  showT = 0;  Tcontour = [21 23]; % THETA
  CONTc = 0; CONTcv = [0:0]; CONTcshlab = 1; 
  showQnet = 1; Qnetcontour=[[-1000:200:-400] [400:200:1000]];
  cx    = [0 300];   uselogmap = 0;
  cmap  = [[1 1 1]; jet ; [1 0 0]]; 
  unit  = 'm';
  titf  = strcat('Hbiso_',num2str(iso),'_',num2str(iso2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2
 case 2
  C     = QisoN; % C = Qiso;
  Clon  = Qlon; Clat = Qlat;
  tit   = strcat(snapshot,'/ Potential vorticity field: q = (-f/\rho . d\sigma_\theta/dz) / q_{ref}');
  %tit   = strcat(snapshot,'/ Potential vorticity field: q = - f . d\sigma_\theta/dz / \rho');
  showW = 0; % Windstress
  cx    = [0 1]*10;
  unit  = char(1);
  titf  = 'PVisoN';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 21
 case 21
  C     = squeeze(Q(1,:,:));
  Clon  = Qlon; Clat = Qlat;
  tit   = strcat('Surface potential vorticity field');
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  N     = 256;
  c     = [1 12];  cx = [-(1+2*c(1)) 1+2*c(2)]*1e-14;  cmap = mapanom; % ecco2_bin1
  c     = [1 12];  cx = [-(1+2*c(1)) 1+2*c(2)]*1e-11;  cmap = mapanom; % ecco2_bin2
  unit  = '1/m/s';
  titf  = 'PV.Lsurface';
  %SHADE = 'interp';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 22
 case 22
  C     = squeeze(Q(11,:,:));
  Clon  = Qlon; Clat = Qlat;
  tit   = strcat('Full potential vorticity field (-115m)');
  showW = 0; % Windstress
  N     = 32;
  c     = [1 12];
  c     = [1 12];  cx = [-(1+2*c(1)) 1+2*c(2)]*1e-14;  cmap = mapanom; % ecco2_bin1
  c     = [1 12];  cx = [-(1+2*c(1)) 1+2*c(2)]*1e-11;  cmap = mapanom; % ecco2_bin2
  unit  = '1/m/s';
  titf  = 'PV.L115';
  colorCOAST = [1 1 1]*.5;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3
 case 3
  C     = JFz;
  Clon  = JFzlon; Clat = JFzlat;
  %tit   = strcat(snapshot,'/ Mechanical PV flux J^F_z and windstress');
  tit   = strvcat(['Mechanical PV flux J^F_z (positive upward), Ekman layer depth (green contours' ...
		   ' m)'],'and windstress (black arrows)');
  %Tcolor = [0 0 0];
  showW = 1; % Windstress
  colorW = 'k';
  showE = 1; 
  Econtour = [10 20:20:200]; 
  N     = 256;
  c     = [1 1];
  cx    = [-(1+2*c(1)) 1+2*c(2)]*1e-11; cmap = mapanom; %cmap = jet;
  %cx    = [-1 1]*10^(-11);
  unit  = 'kg/m^3/s^2';
  titf  = 'JFz';
  showCLIM = 1;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4
  
 case 4
  C     = JBz;
  Clon  = JBzlon; Clat = JBzlat;
  tit   = strcat(snapshot,'/ Diabatic PV flux J^B_z and windstress');
  showW = 1; % Windstress
  cx    = [-1 1]*10^(-11);
  unit  = 'kg/m^3/s^2';
  titf  = 'JBz';
  
 case 5
  C     = Qnet;
  Clon  = Qnetlon; Clat = Qnetlat;
  tit   = ['Net surface heat flux Q_{net} (positive downward), mixed layer depth (green contours,' ...
	   ' m) and windstress (black arrows)'];
  tit   = ['Net surface heat flux Q_{net} (positive downward), and windstress (black arrows)'];
  showH = 0;
  Hcontour = -[100 200:200:600];
  showT = 0;
  showW = 1; colorW = 'k';
  N     = 256;
  c     = [1 1]; cx    = [-(1+2*c(1)) 1+2*c(2)]*200; cmap = mapanom;
  %cx    = [-1 1]*500;
  cmap  = mapanom;  
  unit  = 'W/m^2';
  titf  = 'Qnet';
  showCLIM = 1;
  colorCOAST = [0 0 0];
  
 case 6
  C     = JFz./JBz;
  Clon  = JFzlon; Clat = JFzlat;
  tit   = strcat(snapshot,'/ Ratio: J^F_z/J^B_z');
  cx    = [-1 1]*5;
  unit  = char(1);
  titf  = 'JFz_vs_JBz';
  
 case 7
  C     = squeeze(ST(1,:,:));
  C(isnan(C)) = 0;
  Clon  = STlon; Clat = STlat;
  tit   = strcat('Surface Potential density \sigma_\theta ');
  showT = 0; % 
  cmap  = flipud(hot);
  CONT  = 1;  CONTv = [20:.2:30];  CONTshlab = 0;
  CONTc  = 1; CONTcv = [20:1:30];  CONTcshlab = 1;
  cx    = [23 28];
  unit  = 'kg/m^3';
  titf  = 'SIGMATHETA';
  colorCOAST = [1 1 1]*.5;
  
 case 8
  C     = squeeze(ZETA(1,:,:));
  Clon  = ZETAlon; Clat = ZETAlat;
  tit   = strcat('Surface relative vorticity');
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  N     = 256;
  c     = [0 0];
  cx    = [-(1+2*c(1)) 1+2*c(2)]*6e-5; cmap = mapanom;
  unit  = '1/s';
  titf  = 'ZETA';
  
 case 9
  C     = abs(squeeze(ZETA(1,:,:))./squeeze(f(1,:,:)));
  Clon  = ZETAlon; Clat = ZETAlat;
  tit   = strcat('Absolute ratio between relative and planetary vorticity');
  showW = 0; % Windstress
  showH = 0;
  showCLIM = 1;
  N     = 256;
  c     = [0 1];
  cx    = [0 1+3*c(2)];
  cmap  = flipud(hot); cmap = mapanom;
  unit  = '';
  titf  = 'ZETA_vs_f';
  
 case 10
  C     = squeeze(T(1,:,:));
  Clon  = Tlon; Clat = Tlat;
  tit   = strcat('Surface Potential temperature \theta ');
  showT = 0; % 
  N = 256; c = [0 0];
  cmap  = flipud(hot); cmap = jet;
  CONT  = 0;  CONTv = [0:1:40];  CONTshlab = 0;
  CONTc = 1; CONTcv = [0:1:40]; CONTcshlab = 1; 
  cx    = [0 30];
  unit  = '^oK';
  titf  = 'THETA';
  colorCOAST = [1 1 1]*.5;


end %switch what to plot

% Draw variable:
sp=subplot(iw,jw,1);hold on
if CONT ~= 1
  m_pcolor(Clon,Clat,C);
  shading(SHADE);
  if uselogmap
     colormap(logcolormap(N,c(1),c(2),cmap));
  else
     colormap(cmap);
  end
  
  if wvar(ip) == 10
    if CONTc
     clear cs h csh
     EDW = [21:23];
     [cs,h] = m_contour(Clon,Clat,C,CONTcv,'k');
     csh = clabel(cs,h,'fontsize',8,'labelspacing',800); 
     set(csh,'visible','on');
      for ih = 1 : length(h)
       if find(EDW == get(h(ih),'Userdata'))
 	set(h(ih),'linewidth',1.5)
       end %if
       if find(EDW(2) == get(h(ih),'Userdata'))
 	set(h(ih),'linestyle','--')
       end %if
      end %for 
      for icsh = 1 : length(csh)
	if find(EDW == get(csh(icsh),'userdata') )
	  set(csh(icsh),'visible','on');
	end %if
      end %for
     end %if CONTc
  end % if ST
  
else 
  clear cs h csh
  [cs,h] = m_contourf(Clon,Clat,C,CONTv);
  if uselogmap
    colormap(mycolormap(logcolormap(N,c(1),c(2),cmap),length(CONTv)));
  else
    colormap(mycolormap(cmap,length(CONTv)));
  end
  csh = clabel(cs,h,'fontsize',8,'labelspacing',800); 
  set(csh,'visible','off');
  if CONTshlab
    set(csh,'visible','on');
  end
  if CONTc
    for ih = 1 : length(h)
      if find(CONTcv == get(h(ih),'CData'))
	set(h(ih),'linewidth',1.5)	
      end
    end
    if CONTcshlab
    for ih = 1 : length(csh)
      if find(CONTcv == str2num( get(csh(ih),'string') ) )
	set(csh(ih),'visible','on','color','k','fontsize',8);
	set(csh(ih),'fontweight','bold','margin',1e-3);
      end
    end
    end
  end
end
caxis(cx);
ccol(ip) = colorbar(CBAR,'fontsize',10);
ctitle(ccol(ip),unit);
title(tit);
m_coast('patch',colorCOAST);
m_grid('xtick',360-[20:5:80],'ytick',[20:2:50]);
set(gcf,'name',titf);

if wvar == 5 % Qnet (Positions depend on map limits !)
  yy=get(ccol,'ylabel');
  set(yy,'string','Cooling                                              Warming');
  set(yy,'fontweight','bold');
end %if

if showT
  clear cs h
  [cs,h] = m_contour(Tlon,Tlat,squeeze(T(1,:,:)),Tcontour);
  clabel(cs,h,'fontsize',8,'color',[0 0 0],'labelspacing',200);
  for ih=1:length(h)
    set(h(ih),'edgecolor',Tcolor,'linewidth',1.2);
  end
end %if show THETA contours

if showQnet
  clear cs h
  CQnet = Qnet;
  if wvar(ip) == 12
    %CQnet(isnan(C)) = NaN;
  end
  [cs,h] = m_contour(Qnetlon,Qnetlat,CQnet,Qnetcontour);
  Qnetmap = mycolormap(mapanom,length(Qnetcontour)); 
  if ~isempty(cs)
    clabel(cs,h,'fontsize',8,'color',[0 0 0],'labelspacing',200);
    for ih=1:length(h)
      val = get(h(ih),'userdata');
      set(h(ih),'edgecolor',Qnetmap( find(Qnetcontour == val) ,:),'linewidth',1);
    end
  end
end %if show Qnet contours

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
      m_quiver(360-82,37,1,0,s,'w','linewidth',1.25);
        m_text(360-82,38,'1 N/m^2','color','w');
end %if show windstress

if showH
  clear cs h
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

if showE
  clear cs h
  %[cs,h] = m_contour(EKLlon,EKLlat,EKL,Econtour);
  %cm = flipud(mycolormap(jet,length(Econtour)));
  n = length(Econtour);
  cm = flipud([linspace(0,0,n); linspace(1,0,n) ;linspace(0,0,n)]');
  %cm = [0 1 0 ; 0 .6 0 ; 0 .2 0 ; 0 0 0];
  for ii = 1 : length(Econtour) 
    [cs,h] = m_contour(EKLlon,EKLlat,EKL,[1 1]*Econtour(ii)); 
    if ~isempty(cs)
%    clabel(cs,h,'fontsize',8,'color',[0 0 0],'labelspacing',300);
    cl=clabel(cs,h,'fontsize',8,'color',cm(ii,:),'labelspacing',600,'fontweight','bold');
    for ih = 1 : length(h)
%      set(h(ih),'edgecolor',Ecolor,'linewidth',1);
      set(h(ih),'edgecolor',cm(ii,:),'linewidth',1.2);
    end
    end
  end
end %if show Ekman Layer depth

if showCLIM
  m_line(360-[71 62 62 71 71],[36 36 40.5 40.5 36],'color','r','linewidth',1.5)
end

  
if 1 % Show the date in big in the upper left corner
  spp=subplot('position',[0 .95 .25 .05]);
  p=patch([0 1 1 0],[0 0 1 1],'w');
  set(spp,'ytick',[],'xtick',[]);
  set(spp,'box','off');
  dat = num2str(TIME(it,:));
  dat = strcat(dat(1:4),'/',dat(5:6),'/',dat(7:8),':',dat(9:10),'H',dat(11:12));
  text(0.1,.5,dat,'fontsize',16,...
       'fontweight','bold','color','r','verticalalign','middle');
end  

%%%%%%%%%%%%%%%%
drawnow
set(gcf,'position',[4 48 888 430]);
%videotimeline(num2str(zeros(size(TIME,1),1)),it,'b')
set(gcf,'color','white') 
set(findobj('tag','m_grid_color'),'facecolor','none')
if prtimg
set(gcf,'paperposition',[0.6 6.5 25 14]);
%print(gcf,'-djpeg100',strcat(outimg,sla,titf,'.',snapshot,'.jpg'));
exportj(gcf,0,strcat(outimg,sla,titf,'.',snapshot));
end %if


end %for ip

