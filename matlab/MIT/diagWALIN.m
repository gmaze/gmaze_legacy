% [F,A,D,CROP] = diagWALIN(FLAG,C1,C2,Qnet,Snet,Classes,dA)
% 
% DESCRIPTION:
% Compute the transformation rate of a surface outcrop class (potential
% density or SST) from surface net heat flux Qnet and salt flux Snet
% according to the Walin theory.
%
% INPUTS: 
% FLAG    : Can either be: 0, 1 or 2
%           0: Outcrop field is surface potential density computed 
%              from C1=SST and C2=SSS
%           1: Outcrop field is surface potential density given by C1
%           2: Outcrop field is SST and potential density is computed 
%              from C1=SST and C2=SSS
% C1,C2   : Depends on option FLAG:
%           - FLAG = 0 : 
%                        C1 : Sea surface temperature (degC) 
%                        C2 : Sea surface salinity (PSU)
%           - FLAG = 1 : 
%                        C1 : Surface potential density (kg/m3) 
%                        C2 : Not used
%           - FLAG = 2 : 
%                        C1 : Sea surface temperature (degC) 
%                        C2 : Sea surface salinity (PSU)
% Qnet    : Downward net surface heat flux (W/m2)
% Snet    : Downward net surface salt flux (kg/m2/s) -> 
%           ie, Snet = rho*beta*SSS*(E-P)
% Classes : Range of outcrops to explore (eg: [20:.1:30] for potential density)
% lon,lat : axis
% dA      : Matrix of grid surface elements (m2) centered in (lon,lat) of Ci
%
%
% OUTPUTS:
% F(3,:)    : Transformation rate (m3/s) (from 1:Qnet, 2:Snet and 3:Total)
% A         : Surface of each outcrops
% D(3,:,:)  : Maps of density flux (kg/m2/s) from 1:Qnet, 2:Snet and 3:Total
% CROP(:,:) : Map of the surface field used to compute outcrop's contours
%
%
% NOTES:
% - Fields are of the format: C(LAT,LON)
% - The potential density is computed with the equation of state routine from
%   the MITgcm called densjmd95.m 
%   (see: http://mitgcm.org/cgi-bin/viewcvs.cgi/MITgcm_contrib/gmaze_pv/subfct/densjmd95.m)
% - Snet may be filled of NaN if not available, its F component won't computed
%
%
% AUTHOR: 
% Guillaume Maze / MIT 2006
% 
% HISTORY:
% - Revised: 06/28/2007
%            * Add option do directly give the pot. density as input
%            * Add options do take SST as outcrop 
% - Created: 06/22/2007
%
% REFERENCES: 
% Walin G. 1982: On the relation between sea-surface 
% heat flow and thermal circulation in the ocean. Tellus N24
%

% The routine is not optimized for speed but for clarity, that's why we
% compute buoyancy fluxes, etc...
%
% TO DO: 
% - Fix signs in density fluxes to be correct albeit consistent with F right now
% - Create options for non regular CLASS
% - Create options to also compute the formation rate M
% - Create options to compute an error bar
% - Create check of inputs section

function varargout = diagWALIN(FLAG,C1,C2,QNET,SNET,CLASS,dA)


iy = 30; ix = 50;

% 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROC
% Variables:
nlat = size(C1,1);
nlon = size(C1,2);
CLASS = CLASS(:);
  
% Determine surface fields from which we'll take outcrops contours:
switch FLAG
  
 case {0,2} % Need to compute SIGMA THETA
  SST = C1;
  SSS = C2;
  ST = densjmd95(SSS,SST,zeros(nlat,nlon)) - 1000;  % Real surface (depth = 0)
  %dpt = -5; ST = densjmd95(SSS,SST,(0.09998*9.81*dpt)*ones(nlat,nlon)) - 1000; % Model surface
  if FLAG == 0     % Outcrop is SIGMA THETA:
     OUTCROP = ST;
  elseif FLAG == 2 % Outcrop is SST:
     OUTCROP = SST;
  end
  
 case 1
  ST = C1; % Potential density
  OUTCROP = ST;
end
  
% Create a flag if we don't find salt flux:
if length(find(isnan(SNET)==1)) == nlat*nlon
  do_ep = 0;
else
  do_ep = 1;
end

% Physical constants:
g = 9.81;        % Gravity (m/s2)
Cp = 3994;       % Specific heat of sea water (J/K/kg)
rho0 = 1035;     % Density of reference (kg/m3)
rho  = ST+1000;  % Density (kg/m3)
		 % Thermal expansion coefficient (1/K)
if exist('SST') & exist('SSS') 
  alpha = sw_alpha(SSS,SST,zeros(nlat,nlon));
else
  alpha = 2.*1e-4; 
end


QNET(iy,ix)

% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BUOYANCY FLUX: b
% The buoyancy flux (m/s2*m/s=m2/s3) is computed as:
% b = g/rho*( alpha/Cp*QNET - SNET )
% b = g/rho*alpha/Cp*QNET - g/rho*SNET
% b = b_hf + b_ep
% QNET the net heat flux (W/m2) and SNET the net salt flux (kg/m2/s) 
              b_hf =  g.*alpha./Cp.*QNET./rho;
if do_ep==1,  b_ep = -g*SNET./rho; else b_ep = zeros(nlat,nlon); end
                 b = b_hf + do_ep*b_ep;

b_hf(iy,ix)

% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DENSITY FLUX: bd
% Buoyancy flux is transformed into density flux (kg/m3*m/s = kg/m2/s):
% bd = - rho/g * b
% with b the buoyancy flux
             bd_hf = - rho/g.*b_hf; 
             bd_ep = - rho/g.*b_ep;
             bd    = - rho/g.*b;

bd_hf(iy,ix)

% 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NET MASS FLUX INTEGRATED OVER OUTCROPS: Bd
% The amount of mass water flux over an outcrop is computed as:
% Bd = SUM_ij bd(i,j)*dA(i,j)*MASK(i,j,OUTCROP)
% with MASK(i,j,OUTCROP) = 1 where  OUTCROP(i,j)-dC/2 <=  OUTCROP(i,j) < OUTCROP(i,j)+dC/2
%                        = 0 otherwise
% Outcrops are defined with an increment of:
dCROP = diff(CLASS(1:2));

switch FLAG
 case {0,1}, coef = 1;                 % Potential density as outcrops
 case 2,     coef = 1./(alpha.*rho0);  % SST as outcrops
end %switch
coef
% Surface integral:
for iC = 1 : length(CLASS)
  CROPc  = CLASS(iC);
  mask   = zeros(nlat,nlon);
  mask(find( (CROPc-dCROP/2 <= OUTCROP) & (OUTCROP < CROPc+dCROP/2) )) = 1;
  %if CROPc == 18,[CROPc-dCROP/2 CROPc+dCROP/2],global mask18,mask18=mask;end;
               Bd_hf(iC) = nansum(nansum(dA.*mask.*bd_hf.*coef,1),2);
               Bd_ep(iC) = nansum(nansum(dA.*mask.*bd_ep.*coef,1),2);
                  Bd(iC) = nansum(nansum(dA.*mask.*bd.*coef,1),2);
		  AA(iC) = nansum(nansum(dA.*mask,1),2);
end %for iC
dA(iy,ix)

% 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRANSFORMATION RATE: F
% F is defined as the convergence/divergence of the integrated mass flux Bd.
% F = Bd(CROP) / dCROP
% where Bd is the mass flux over an outcrop.
             F_hf = Bd_hf./dCROP;
             F_ep = Bd_ep./dCROP; 
             F    = Bd./dCROP;
dCROP



% 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
% Transformation rate:
TRANSFORM_RATE(1,:) = F_hf;
TRANSFORM_RATE(2,:) = F_ep;
TRANSFORM_RATE(3,:) = F;	     

% Density flux:
DENSITY_FLUX(1,:,:) = bd_hf;
DENSITY_FLUX(2,:,:) = bd_ep;
DENSITY_FLUX(3,:,:) = bd;

switch nargout
 case 1
  varargout(1) = {TRANSFORM_RATE};
 case 2
  varargout(1) = {TRANSFORM_RATE};
  varargout(2) = {AA};
 case 3
  varargout(1) = {TRANSFORM_RATE};
  varargout(2) = {AA};
  varargout(3) = {DENSITY_FLUX};
 case 4
  varargout(1) = {TRANSFORM_RATE};
  varargout(2) = {AA};
  varargout(3) = {DENSITY_FLUX};
  varargout(4) = {OUTCROP};
end %switch
