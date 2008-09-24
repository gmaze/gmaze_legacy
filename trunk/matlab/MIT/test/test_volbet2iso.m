% Test of the function volbet2iso
%

clear

% Theoritical fields:
eg = 1;

switch eg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 case 1 % The more simple:
  % Axis:
  lon = [200:1/8:300]; nlon = length(lon);
  lat = [0:1/8:20];   nlat = length(lat);
  dpt = [5:5:1000];    ndpt = length(dpt);
    
  % chp goes linearly from 10 at 30N to 0 at 40N
  % uniformely between the surface and the bottom:
  [a chp c] = meshgrid(lon,-lat+lat(nlat),dpt); clear a c
  chp = permute(chp,[3 1 2]);
  %chp(:,:,1:400) = chp(:,:,1:400).*NaN;
  
  % Define limits:
  LIMITS(1) = 18 ; % Between 1.75N and 2N
  LIMITS(2) = 18.2 ;
  LIMITS(3) = dpt(ndpt) ;
  LIMITS(4:5) = lat([1 nlat]) ;
  LIMITS(6:7) = lon([1 nlon]) ;
   
  % Expected volume: 
  dx = m_lldist([200 300],[1 1]*1.875)./1000;
  dy = m_lldist([1 1],[1.75 2])./1000;
  dz = dpt(ndpt)./1000;
  Vexp = dx*dy*dz; % Unit is km^3
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
end %switch



% Get volume:
[V Vmat dV] = volbet2iso(chp,LIMITS,dpt,lat,lon);

disp('Computed:')
disp(num2str(V/1000^3))
disp('Approximatly expected:')
disp(num2str(Vexp))
