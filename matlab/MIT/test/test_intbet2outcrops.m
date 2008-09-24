% Test of the function intbet2outcrops
clear

% Theoritical fields:
eg = 2;

switch eg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 case 1 % The more simple:
  % Axis:
  lon = [200:1/8:300]; nlon = length(lon);
  lat = [0:1/8:20];    nlat = length(lat);
    
  % chp goes linearly from 20 at 0N to 0 at 20N
  [a chp] = meshgrid(lon,-lat+lat(nlat)); clear a c
  [a chp] = meshgrid(lon,-lat+2); clear a c
  chp(14:16,:) = -1; % Make the integral proportional to the surface
    
  % Define limits:
  LIMITS(1) = -1 ; 
  LIMITS(2) = -1 ;
  LIMITS(3:4) = lat([14 16]) ;
  LIMITS(5:6) = lon([1 nlon]) ;
   
  % Expected integral:
  dx = m_lldist([200 300],[1 1]*1.75)./1000;
  dy = m_lldist([1 1],[1.625 1.875])./1000;
  Iexp = dx*dy/2; % Unit is km^2
  
  
 case 2
  % Axis:
  lon = [200:1/8:300]; nlon = length(lon);
  lat = [0:1:40];    nlat = length(lat);
  
  %
  [a chp]=meshgrid(lon,40-lat);
  
  % Define limits:
  LIMITS(1) =  9.5 ; 
  LIMITS(2) = 10.5 ;
  LIMITS(3:4) = lat([1 nlat]) ;
  LIMITS(5:6) = lon([1 nlon]) ;
   
  Iexp=4;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
end %switch


% Get integral:
[I Imat dI] = intbet2outcrops(chp,LIMITS,lat,lon);

disp('Computed:')
disp(num2str(I/1000^2))
disp('Approximatly expected:')
disp(num2str(Iexp))

%break
figure;iw=1;jw=2;
subplot(iw,jw,1);hold on
pcolor(chp);shading flat;canom;colorbar;axis tight
title('Tracer to integrate');

subplot(iw,jw,2);hold on
pcolor(double(Imat));shading flat;canom;colorbar;axis tight
title('Points selected for the integration');
