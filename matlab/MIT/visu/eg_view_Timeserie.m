%
% THIS IS NOT A FUNCTION !
%
% Plot time series of all variables in different ways
% Outputs recording possible
%

clear
global sla netcdf_domain
pv_checkpath

% Path and extension to find files:
pathname = strcat('netcdf-files',sla);
%pathname = strcat('netcdf-files-twice-daily',sla);
%pathname = strcat('netcdf-files-daily',sla);
ext      = 'nc';
netcdf_domain = 'western_north_atlantic'; 

% Date series:
ID    = datenum(2000,12,31,12,0,0); % Start date
ID    = datenum(2000,12,31,0,0,0); % Start date
ID    = datenum(2001,1,1,12,0,0); % Start date
ID    = datenum(2001,4,1,0,0,0); % Start date
%IDend = datenum(2001,2,26,12,0,0); % End date
IDend = datenum(2001,7,4,0,0,0); % End date

dt = datenum(0,0,1,0,0,0); % Time step between input: 1 day
%dt = datenum(0,0,2,0,0,0); % Time step between input: 2 days
%dt = datenum(0,0,7,0,0,0); % Time step between input: 1 week
%dt = datenum(0,0,0,12,0,0); % Time step between input: 12 hours
IDend = ID + 1*dt; % 
nt = (IDend-ID)/dt;

% Create TIME table:
for it = 1 : nt
  ID = ID + dt;
  snapshot = datestr(ID,'yyyymmddHHMM'); % For twice-daily data
%  snapshot = datestr(ID,'yyyymmdd'); % For daily data
  TIME(it,:) = snapshot;
end %for it


% Some settings
iso    = 25.25; % Which sigma-theta surface ?
getiso = 0;    % We do not compute the isoST by default
outimg = 'img_tmp'; % Output directory
%outimg = 'img_tmp2'; % Output directory
%outimg = 'img_tmp3'; % Output directory
prtimg = 0; % Do we record figures as jpg files ?

% Plot modules available:
sub = get_plotlist('eg_view_Timeserie','.');
disp('Available plots:')
sub = get_plotlistdef('eg_view_Timeserie','.');
disp('Set the variable <pl> in view_Timeserie.m with wanted plots')

% Selected plots list:
pl = [7]; %getiso=1;

% Verif plots:
disp(char(2));disp('You have choosed to plot:')
for i = 1 : length(pl)
  disp(strcat(num2str(pl(i)),' -> ', sub(pl(i)).description ) )
end
s = input(' Are you sure ([y]/n) ?','s');
if ~isempty(s) & s == 'n'
    return
end

% To find a specific date
%find(str2num(TIME)==200103300000),break

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Video loop:
for it = 1 : nt
  snapshot = TIME(it,:);
  %titf='.section_32N';if ~exist(strcat(outimg,sla,'PV.',snapshot,titf,'.jpg'),'file')
  
%%%%%%%%%%%%%%%%
% NETCDF files name:
filPV   = 'PV';
filST   = 'SIGMATHETA';
filT    = 'THETA';
filTx   = 'TAUX';
filTy   = 'TAUY';
filJFz  = 'JFz';
filJBz  = 'JBz';
filQnet = 'TFLUX';
filQEk  = 'QEk';
%filMLD  = 'KPPmld';
filMLD  = 'MLD';
filOx   = 'OMEGAX';
filOy   = 'OMEGAY';
filZET  = 'ZETA';
filEKL  = 'EKL';


% Load fields:
disp('load fields...')
% (I keep proper axis for each variables in case of one day they would be different)
         ferfile = strcat(pathname,sla,snapshot,sla,filPV,'.',netcdf_domain,'.',ext);
             ncQ = netcdf(ferfile,'nowrite');
[Qlon Qlat Qdpt] = coordfromnc(ncQ);
               Q = ncQ{4}(:,:,:); clear ncQ ferfile
      [nz ny nx] = size(Q);
      %Qdpt = -Qdpt;

                  ferfile = strcat(pathname,sla,snapshot,sla,filZET,'.',netcdf_domain,'.',ext);
                    ncZET = netcdf(ferfile,'nowrite');
[ZETAlon ZETAlat ZETAdpt] = coordfromnc(ncZET);
                     ZETA = ncZET{4}(:,:,:); clear ncZET ferfile
  % Move ZETA on the same grid as Q:
  ZETA = ( ZETA(:,:,2:nx-1) + ZETA(:,:,1:nx-2) )./2;
  ZETA = ( ZETA(:,2:ny-1,:) + ZETA(:,1:ny-2,:) )./2;
  ZETAlon = ( ZETAlon(2:nx-1) + ZETAlon(1:nx-2) )./2;	
  ZETAlat = ( ZETAlat(2:ny-1) + ZETAlat(1:ny-2) )./2;

            ferfile = strcat(pathname,sla,snapshot,sla,filOx,'.',netcdf_domain,'.',ext);
               ncOX = netcdf(ferfile,'nowrite');
[OXlon OXlat OXdpt] = coordfromnc(ncOX);
                 OX = ncOX{4}(:,:,:); clear ncOX ferfile
  % Move OMEGAx on the same grid as Q:
  OX = ( OX(:,2:ny-1,:) + OX(:,1:ny-2,:) )./2;
  OX = ( OX(2:nz-1,:,:) + OX(1:nz-2,:,:) )./2;
  OXlat = ( OXlat(2:ny-1) + OXlat(1:ny-2) )./2;
  OXdpt = ( OXdpt(2:nz-1) + OXdpt(1:nz-2) )./2;

            ferfile = strcat(pathname,sla,snapshot,sla,filOy,'.',netcdf_domain,'.',ext);
               ncOY = netcdf(ferfile,'nowrite');
[OYlon OYlat OYdpt] = coordfromnc(ncOY);
                 OY = ncOY{4}(:,:,:); clear ncOY ferfile
  % Move OMEGAy on the same grid as Q:
  OY = ( OY(2:nz-1,:,:) + OY(1:nz-2,:,:) )./2;
  OY = ( OY(:,:,2:nx-1) + OY(:,:,1:nx-2) )./2;
  OYdpt = ( OYdpt(2:nz-1) + OYdpt(1:nz-2) )./2;
  OYlon = ( OYlon(2:nx-1) + OYlon(1:nx-2) )./2;
  
  
            ferfile = strcat(pathname,sla,snapshot,sla,filST,'.',netcdf_domain,'.',ext);
               ncST = netcdf(ferfile,'nowrite');
[STlon STlat STdpt] = coordfromnc(ncST);
                 ST = ncST{4}(:,:,:); clear ncST ferfile

         ferfile = strcat(pathname,sla,snapshot,sla,filT,'.',netcdf_domain,'.',ext);
             ncT = netcdf(ferfile,'nowrite');
[Tlon Tlat Tdpt] = coordfromnc(ncT);
               T = ncT{4}(:,:,:); clear ncT ferfile
	      
              ferfile = strcat(pathname,sla,snapshot,sla,filTx,'.',netcdf_domain,'.',ext);
                 ncTx = netcdf(ferfile,'nowrite');
  [Txlon Txlat Txdpt] = coordfromnc(ncTx);
                   Tx = ncTx{4}(1,:,:); clear ncTx ferfile
              ferfile = strcat(pathname,sla,snapshot,sla,filTy,'.',netcdf_domain,'.',ext);
                 ncTy = netcdf(ferfile,'nowrite');
  [Tylon Tylat Tydpt] = coordfromnc(ncTy);
                   Ty = ncTy{4}(1,:,:); clear ncTy ferfile
  
                 ferfile = strcat(pathname,sla,snapshot,sla,filJFz,'.',netcdf_domain,'.',ext);
                   ncJFz = netcdf(ferfile,'nowrite');
  [JFzlon JFzlat JFzdpt] = coordfromnc(ncJFz);
                     JFz = ncJFz{4}(1,:,:);
  
                 ferfile = strcat(pathname,sla,snapshot,sla,filJBz,'.',netcdf_domain,'.',ext);
                   ncJBz = netcdf(ferfile,'nowrite');
  [JBzlon JBzlat JBzdpt] = coordfromnc(ncJBz);
                     JBz = ncJBz{4}(1,:,:);
  
                  ferfile = strcat(pathname,sla,snapshot,sla,filQnet,'.',netcdf_domain,'.',ext);
                   ncQnet = netcdf(ferfile,'nowrite');
[Qnetlon Qnetlat Qnetdpt] = coordfromnc(ncQnet);
                     Qnet = ncQnet{4}(1,:,:);
% $$$ 
% $$$                ferfile = strcat(pathname,sla,snapshot,sla,filQEk,'.',netcdf_domain,'.',ext);
% $$$                  ncQEk = netcdf(ferfile,'nowrite');
% $$$ [QEklon QEklat QEkdpt] = coordfromnc(ncQEk);
% $$$                    QEk = ncQEk{4}(1,:,:);
% $$$ 
                 ferfile = strcat(pathname,sla,snapshot,sla,filMLD,'.',netcdf_domain,'.',ext);
                   ncMLD = netcdf(ferfile,'nowrite');
  [MLDlon MLDlat MLDdpt] = coordfromnc(ncMLD);
                     MLD = ncMLD{4}(1,:,:);
  
                 ferfile = strcat(pathname,sla,snapshot,sla,filEKL,'.',netcdf_domain,'.',ext);
                   ncEKL = netcdf(ferfile,'nowrite');
  [EKLlon EKLlat EKLdpt] = coordfromnc(ncEKL);
                     EKL = ncEKL{4}(1,:,:);

	       
%%%%%%%%%%%%%%%%
% Q is defined on the same grid of ST but troncated by extrem 2 points, then here
% make all fields defined with same limits...
% In case of missing points, we add NaN.
disp('Reshape them')
ST    = squeeze(ST(2:nz+1,2:ny+1,2:nx+1));
STdpt = STdpt(2:nz+1);
STlon = STlon(2:nx+1);
STlat = STlat(2:ny+1);
T    = squeeze(T(2:nz+1,2:ny+1,2:nx+1));
Tdpt = Tdpt(2:nz+1);
Tlon = Tlon(2:nx+1);
Tlat = Tlat(2:ny+1);
JBz    = squeeze(JBz(2:ny+1,2:nx+1));
JBzlon = JBzlon(2:nx+1);
JBzlat = JBzlat(2:ny+1);
Qnet    = squeeze(Qnet(2:ny+1,2:nx+1));
Qnetlon = Qnetlon(2:nx+1);
Qnetlat = Qnetlat(2:ny+1);
MLD    = squeeze(MLD(2:ny+1,2:nx+1));
MLDlon = MLDlon(2:nx+1);
MLDlat = MLDlat(2:ny+1);
EKL    = squeeze(EKL(2:ny+1,2:nx+1));
EKLlon = EKLlon(2:nx+1);
EKLlat = EKLlat(2:ny+1);
ZETA = squeeze(ZETA(2:nz+1,:,:));
ZETA = cat(2,ZETA,ones(size(ZETA,1),1,size(ZETA,3)).*NaN);
ZETA = cat(2,ones(size(ZETA,1),1,size(ZETA,3)).*NaN,ZETA);
ZETA = cat(3,ZETA,ones(size(ZETA,1),size(ZETA,2),1).*NaN);
ZETA = cat(3,ones(size(ZETA,1),size(ZETA,2),1).*NaN,ZETA);
ZETAdpt = ZETAdpt(2:nz+1);
ZETAlon = STlon;
ZETAlat = STlat;
OX = squeeze(OX(:,:,2:nx+1));
OX = cat(1,OX,ones(1,size(OX,2),size(OX,3)).*NaN);
OX = cat(1,ones(1,size(OX,2),size(OX,3)).*NaN,OX);
OX = cat(2,OX,ones(size(OX,1),1,size(OX,3)).*NaN);
OX = cat(2,ones(size(OX,1),1,size(OX,3)).*NaN,OX);
OXlon = STlon;
OXlat = STlat;
OXdpt = STdpt;
OY = squeeze(OY(:,2:ny+1,:));
OY = cat(1,OY,ones(1,size(OY,2),size(OY,3)).*NaN);
OY = cat(1,ones(1,size(OY,2),size(OY,3)).*NaN,OY);
OY = cat(3,OY,ones(size(OY,1),size(OY,2),1).*NaN);
OY = cat(3,ones(size(OY,1),size(OY,2),1).*NaN,OY);
OYlon = STlon;
OYlat = STlat;
OYdpt = STdpt;


% Planetary vorticity:
  f = 2*(2*pi/86400)*sin(ZETAlat*pi/180);
  [a f c]=meshgrid(ZETAlon,f,ZETAdpt); clear a c
  f = permute(f,[3 1 2]);
  
% Apply mask:
MASK = ones(size(ST,1),size(ST,2),size(ST,3)); 
MASK(find(isnan(ST))) = NaN;
T = T.*MASK;
Qnet = Qnet.*squeeze(MASK(1,:,:));

  
% Grid:
global domain subdomain1 subdomain2 subdomain3
grid_setup
subdomain = subdomain1;


%%%%%%%%%%%%%%%%
% Here we determine the isosurface and its depth:
if getiso
  disp('Get iso-ST')
[Iiso mask] = subfct_getisoS(ST,iso);
Diso = ones(size(Iiso)).*NaN;
Qiso = ones(size(Iiso)).*NaN;
for ix = 1 : size(ST,3)
  for iy = 1 : size(ST,2) 
    if ~isnan(Iiso(iy,ix)) & ~isnan( Q(Iiso(iy,ix),iy,ix) )
       Diso(iy,ix) = STdpt(Iiso(iy,ix));
       Qiso(iy,ix) =     Q(Iiso(iy,ix),iy,ix);
    end %if
end, end %for iy, ix
end %if



%%%%%%%%%%%%%%%%
% "Normalise" the PV:
fO  = 2*(2*pi/86400)*sin(32*pi/180);
dST = 27.6-25.4;
H   = -1000;
RHOo = 1000;
Qref = -fO/RHOo*dST/H;
if getiso, QisoN = Qiso./Qref; end


%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
% Plots:
disp('Plots ...')


for i = 1 : length(pl)
  disp(strcat('Plotting module:',sub(pl(i)).name))
  eval(sub(pl(i)).name(1:end-2),'disp(''Oups scratch...'');return');
end


%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%

  %else,disp(strcat('Skip:',snapshot));end

fclose('all');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
end %for it  
