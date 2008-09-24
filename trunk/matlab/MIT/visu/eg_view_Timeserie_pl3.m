%DEF Field projection on 3D surface


% Which variables to plot:
%wvar = [1 2 3 4 6];
wvar = [1];

for ip = 1 : length(wvar)
  
  figure(30+ip);clf;hold on;iw=1;jw=1;

% Variables loop:
  % Default:
  CBAR = 'v'; % Colorbar orientation
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
  
  %if it==1, mini; end 
switch wvar(ip)
  
end %switch what to plot

C = Diso;
Clon = STlon;
Clat = STlat;
% Replace land by zero:
STs = squeeze(ST(1,:,:));
%C(isnan(STs)) = 0;

C2 = Qiso;
% Replace land by zero:
Qs = squeeze(Q(1,:,:));
C2(isnan(Qs)) = 0;
% Replace ocean surface area of Diso by surface value of Q:
%C2(isnan(C)) = -10;
C2(isnan(C)) = Qs(isnan(C));

% Then replace NaN surface value of Diso by 0
C(isnan(C)) = 0;
C2(isnan(C2)) = 10;

LON = [min(Clon) max(Clon)];
LAT = [min(Clat) max(Clat)];
%LON = [277 299];
LAT = [26 40];
C = squeeze(C( max(find(Clat<=LAT(1))):max(find(Clat<=LAT(2))) ,  : ));
C = squeeze(C( : , max(find(Clon<=LON(1))):max(find(Clon<=LON(2))) ));
C2=squeeze(C2( max(find(Clat<=LAT(1))):max(find(Clat<=LAT(2))) , : ));
C2=squeeze(C2( : , max(find(Clon<=LON(1))):max(find(Clon<=LON(2)))));
Clon = squeeze(Clon( max(find(Clon<=LON(1))):max(find(Clon<=LON(2))) ));
Clat = squeeze(Clat( max(find(Clat<=LAT(1))):max(find(Clat<=LAT(2))) ));



if 0
     nlon = length(Clon);
     nlat = length(Clat);
     [lati longi] = meshgrid(Clat,Clon);
     %longi = longi';     lati = lati';
     
     new_dimension = fix([1*nlon .5*nlat]);
     n_nlon = new_dimension(1);
     n_nlat = new_dimension(2);
     n_Clon = interp1(Clon,[1:fix(nlon/n_nlon):nlon],'cubic')';
     n_Clat = interp1(Clat,[1:fix(nlat/n_nlat):nlat],'cubic')';
     [n_lati n_longi] = meshgrid(n_Clat,n_Clon);
     n_lati = n_lati'; n_longi = n_longi';
     
     n_C = interp2(lati,longi,C',n_lati,n_longi,'spline');

     n_C(find(n_C==0)) = NaN; 
     n_C = lisse(n_C,5,5);  

end %if


%C(find(C==0)) = NaN;
%C  =  lisse(C,2,2);  
%C2 = lisse(C2,2,2);       
   
% Map projection:
%m_proj('mercator','long',subdomain.limlon,'lat',subdomain.limlat);
%m_proj('mercator','long',subdomain.limlon,'lat',[25 40]);
%m_proj('mercator','long',[subdomain.limlon(1) 360-24],'lat',[25 50]);
%m_proj('mercator','long',Clon([1 length(Clon)])','lat',Clat([1 length(Clat)])');
%m_proj('mercator','long',Clon([1 length(Clon)])','lat',[15 40]);
%m_proj('mercator','long',[275 330],'lat',[15 40]);

camx = [-200:20:200];
az = [-30:10:30];
az = 5;
el = linspace(5,50,length(az));
el = 20*ones(1,length(az));

for ii = 1 : length(az)
  
clf
%surf(n_Clon,n_Clat,n_C);
s=surf(Clon,Clat,C);
%[X,Y] = m_ll2xy(Clon,Clat);
%s=surf(X,Y,C);

set(s,'cdata',C2);
  N    = 32;
  %c    = [1 30];
  %cx   = [-(1+2*c(1)) 1+2*c(2)]*1.5e-12; cmap = mapanom; cmap = jet;
  c     = [0 12];  
  cx = [-(1+2*c(1)) 1+2*c(2)]*.95*1e-9; cmap = mapanom;  %cmap = jet;
  cmap = [logcolormap(N,c(1),c(2),cmap); .3 .3 .3]; % Last value is for NaN
  %cmap = 1 - cmap;
  colormap(cmap);
  caxis(cx); %colorbar
  
  
shading interp
view(az(ii),el(ii))
%set(gca,'ylim',[15 40]);
%set(gca,'xlim',[275 330]);
grid on
xlabel('Longitude');
ylabel('Latitude');
zlabel('Depth');

%h = camlight('left'); %set(h,'color',[0 0 0]);
%camlight
l=light('position',[0 0 1]);
light('position',[0 0 -1]);
%set(h,'position',[150 -200 2000]); 
%set(h,'style','infinite')
lighting flat
material dull

%set(gca,'plotBoxAspectRatio',[2 2 .5])
%m_coast('color',[0 0 0])   
camzoom(2)
camzoom(1.25)

set(gca,'plotBoxAspectRatio',[2 2 .25])
set(gca,'visible','off');
%camzoom(1.1)
%for ix=1:length(camx)
%   set(h,'position',[camx(ix) -200 2000]); 
%   refresh;drawnow
   %M(ii) = getframe;
%end


if 0
  xlim = get(gca,'xlim');
  ylim = get(gca,'ylim');
  lC=[0 0 1];
  for x = 280:10:340
    if x >= xlim(1) & x <= xlim(2)
      line([1 1]*x,ylim,'color',lC);
    end
  end %for x
  for y = 0 : 10 : 90
    if y >= ylim(1) & y <= ylim(2)
      line(xlim,[1 1]*y,'color',lC)
    end
  end %for y
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

end
%return

%%%%%%%%%%%%%%%%
drawnow
set(gcf,'position',[4 48 888 430]);
%videotimeline(TIME,it,'b')
%videotimeline(num2str(zeros(size(TIME,1),1)),it,'b')
set(gcf,'color','white') 
if prtimg
%set(findobj('tag','m_grid_color'),'facecolor','none')
set(gcf,'paperposition',[0.6 6.5 25 14]);
titf='3Dview';
exportj(gcf,1,strcat(outimg,sla,titf,'.',snapshot));
end %if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%




end %for ip
