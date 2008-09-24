% [V,Cm,E,Vt,CC] = diagVOLU(FLAG,C1,C2,CLASS,LON,LAT,DPT,DV,[Ca(Z,Y,X),Cb(Z,Y,X),...])
%
% DESCRIPTION:
% Compute the volume of water for a particular CLASS of potential
% temperature or density.
% Also compute mean values of additional 3D fields (such as Ca, Cb ...) along
% the CLASS of the analysed field.
%
% The volume is accounted as:
%   CLASS(i) <= FIELD < CLASS(i+1)
%
% INPUTS: 
% FLAG    : Can either be: 0, 1 or 2
%           0: Compute volume of potential density classes
%              from C1=THETA and C2=SALT
%           1: Compute volume of potential density classes
%              from C1=SIGMA_THETA
%           2: Compute volume of temperature classes
%              from C1=THETA
% C1,C2   : Depends on option FLAG:
%           - FLAG = 0 : 
%                        C1 : Temperature (^oC)
%                        C2 : Salinity (PSU)
%           - FLAG = 1 : 
%                        C1 : Potential density (kg/m3) 
%                        C2 : Not used
%           - FLAG = 2 : 
%                        C1 : Temperature (^oC)
%                        C2 : Not used
% ClASS   : Range to explore (eg: [20:.1:30] for potential density)
% LON,LAT,DPT : axis (DPT < 0)
% dV      : Matrix of grid volume elements (m3) centered in (lon,lat,dpt) 
% Ca,Cb,...: Any additional 3D fields (unlimited)  
%
%
% OUTPUTS:
% V       : Volume of each CLASS (m3)
% Cm      : Mean value of the classified field (allow to check errors)
% E       : Each time a grid point is counted, a 1 is added to this 3D matrix
%           Allow to check double count of a point or unexplored areas
% Vt      : Is the total volume explored (Vt)
% CC      : Contains the mean value of additional fields Ca, Cb ....
%
% NOTES:
% - Fields are on the format: C(DPT,LAT,LON)
% - The potential density is computed with the equation of state routine from
%   the MITgcm called densjmd95.m 
%   (see: http://mitgcm.org/cgi-bin/viewcvs.cgi/MITgcm_contrib/gmaze_pv/subfct/densjmd95.m)
% - if dV is filled with NaN, dV is computed by the function
%
%
% AUTHOR: 
% Guillaume Maze / MIT 2006
% 
% HISTORY:
% - Created: 06/29/2007
%

% 

function varargout = diagVOLU(FLAG,C1,C2,CLASS,LON,LAT,DPT,DV,varargin)


% 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROC
% Variables:
ndpt = size(C1,1);
nlat = size(C1,2);
nlon = size(C1,3);
CLASS = sort(CLASS(:));
[Z b c] = meshgrid(DPT,LON,LAT);clear b c, Z = permute(Z,[2 3 1]);

% Determine fields from which we'll take class contours:
switch FLAG
  
 case {0,2} % Need to compute SIGMA THETA
  THETA = C1;
  SALT  = C2;
  ST = densjmd95(SALT,THETA,0.09998*9.81*abs(Z)) - 1000; 
  if FLAG == 0     % Field is SIGMA THETA:
     CROP = ST;
  elseif FLAG == 2 % Field is THETA:
     CROP = THETA;
  end
  
 case 1
  ST = C1; % Potential density
  CROP = ST;
end
  
% Volume elements:
if length(find(isnan(DV)==1)) == ndpt*nlat*nlon
  if exist('subfct_getdV','file')
    DV = subfct_getdV(DPT,LAT,LON);
  else
    DV  = local_getdV(DPT,LAT,LON);
  end
end

% Need to compute volume integral over these 3D fields
nIN = nargin-8;
if nIN >= 1
  doEXTRA = 1;
else
  doEXTRA = 0;
end

% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VOLUME INTEGRATION
explored = zeros(ndpt,nlat,nlon);
% Volume integral:
for iC = 1 : length(CLASS)-1
  mask   = zeros(ndpt,nlat,nlon);
  mask(find( (CLASS(iC) <= CROP) & (CROP < CLASS(iC+1)) )) = 1;
  explored = explored + mask;
  VOL(iC) = nansum(nansum(nansum(DV.*mask,1),2),3);
  
  if VOL(iC) ~= 0
     CAR(iC) = nansum(nansum(nansum(CROP.*DV.*mask,1),2),3)./VOL(iC);
     if doEXTRA
       for ii = 1 : nIN
           C = varargin{ii};
      	   CAREXTRA(ii,iC) = nansum(nansum(nansum(C.*DV.*mask,1),2),3)./VOL(iC);
       end %for ii	
     end %if doEXTRA
  else
     CAR(iC) = NaN;
     if doEXTRA
       for ii = 1 : nIN
      	   CAREXTRA(ii,iC) = NaN;
       end %for ii	
     end %if doEXTRA
  end  
end %for iC

% In order to compute the total volume of the domain:
CROP(find(isnan(CROP)==0)) = 1;  
CROP(find(isnan(CROP)==1)) = 0;
Vt = nansum(nansum(nansum(DV.*CROP,1),2),3);

% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
switch nargout
 case 1
  varargout(1) = {VOL};
 case 2
  varargout(1) = {VOL};
  varargout(2) = {CAR};
 case 3
  varargout(1) = {VOL};
  varargout(2) = {CAR};
  varargout(3) = {explored}; 
 case 4
  varargout(1) = {VOL};
  varargout(2) = {CAR};
  varargout(3) = {explored}; 
  varargout(4) = {Vt};
 case 5
  varargout(1) = {VOL};
  varargout(2) = {CAR};
  varargout(3) = {explored}; 
  varargout(4) = {Vt};
  varargout(5) = {CAREXTRA}; 
end %switch







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the 3D dV volume elements.
% Copy of the subfct_getDV function from gmaze_pv package
function DV = local_getdV(Z,Y,X)

nz = length(Z);
ny = length(Y);
nx = length(X);

DV = zeros(nz,ny,nx);

% Vertical elements:
for iz = 1 : nz % Toward the deep ocean (because DPT<0)
	% Vertical grid length centered at Z(iy)
	if iz == 1
  	  dz = abs(Z(1)) + abs(sum(diff(Z(iz:iz+1))/2));
	elseif iz == nz % We don't know the real ocean depth
  	  dz = abs(sum(diff(Z(iz-1:iz))/2));
	else
  	  dz = abs(sum(diff(Z(iz-1:iz+1))/2));
        end
	DZ(iz) = dz;
end

% Surface and Volume elements:
for ix = 1 : nx
  for iy = 1 : ny
      % Zonal grid length centered in X(ix),Y(iY)
      if ix == 1
         dx = abs(m_lldist([X(ix) X(ix+1)],[1 1]*Y(iy)))/2;
      elseif ix == nx 
         dx = abs(m_lldist([X(ix-1) X(ix)],[1 1]*Y(iy)))/2;
      else
         dx = abs(m_lldist([X(ix-1) X(ix)],[1 1]*Y(iy)))/2+abs(m_lldist([X(ix) X(ix+1)],[1 1]*Y(iy)))/2;
      end	
 
      % Meridional grid length centered in X(ix),Y(iY)
      if iy == 1
        dy = abs(m_lldist([1 1]*X(ix),[Y(iy) Y(iy+1)]))/2;
      elseif iy == ny
        dy = abs(m_lldist([1 1]*X(ix),[Y(iy-1) Y(iy)]))/2;
      else	
        dy = abs(m_lldist([1 1]*X(ix),[Y(iy-1) Y(iy)]))/2+abs(m_lldist([1 1]*X(ix),[Y(iy) Y(iy+1)]))/2;
      end

      % Surface element:
      DA = dx*dy.*ones(1,nz);
      
      % Volume element:
      DV(:,iy,ix) = DZ.*DA;
  end %for iy
end %for ix

