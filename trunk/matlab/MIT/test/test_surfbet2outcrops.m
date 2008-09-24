% Test of the function surfbet2outcrops
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
    
  % chp goes linearly from 20 at 0N to 0 at 20N
  [a chp] = meshgrid(lon,-lat+lat(nlat)); clear a c
%  chp(:,1:400) = chp(:,1:400).*NaN;
  
  % Define limits:
  LIMITS(1) = 18 ; % Between 1.75N and 2N
  LIMITS(2) = 18.2 ;
  LIMITS(3:4) = lat([1 nlat]) ;
  LIMITS(5:6) = lon([1 nlon]) ;
   
  % Expected surface:
  dx = m_lldist([200 300],[1 1]*1.875)./1000;
  dy = m_lldist([1 1],[1.75 2])./1000;
  Sexp = dx*dy; % Unit is km^2
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
end %switch



% Get surface:
[S Smat dS] = surfbet2outcrops(chp,LIMITS,lat,lon);

disp('Computed:')
disp(num2str(S/1000^2))
disp('Approximatly expected:')
disp(num2str(Sexp))
