% [BN BS BW BE BT BB] = getVOLbounds(PII)
%
% Given a 1/0 3D matrix PII, determine faces bounding the volume
% 
% INPUT:
%  PII is of dimensions: PII(NDPT,NLAT,NLON)
%  with:
%   DPT downward
%   LAT northward
%   LON eastward
%
% OUTPUT:
% BN,BS, BW,BE, BT,BB are 3D matrices like PII, filled with 0 or 1.
% 1 indicates a surface bounding the volume 
%
% BN stands for northern bound
% BS stands for southern bound
% BW stands for western bound
% BE stands for eastern bound
% BT stands for top bound
% BB stands for bottom bound
%
%  gmaze@mit.edu 2007/07/19
%

function varargout = getVOLbounds(varargin)


pii  = varargin{1};
ndpt = size(pii,1);
nlat = size(pii,2);
nlon = size(pii,3);


  bounds_W = zeros(ndpt,nlat,nlon);
  bounds_E = zeros(ndpt,nlat,nlon);
  bounds_S = zeros(ndpt,nlat,nlon);
  bounds_N = zeros(ndpt,nlat,nlon);
  bounds_T = zeros(ndpt,nlat,nlon);
  bounds_B = zeros(ndpt,nlat,nlon);

  for iz = 1 : ndpt
    for iy = 1 : nlat
      for ix = 1 : nlon
	if pii(iz,iy,ix) == 1
	  
	  % Is it a western boundary ?
	  if ix-1 <= 0 % Reach the domain limit
	    bounds_W(iz,iy,ix) = 1;
	  elseif pii(iz,iy,ix-1) == 0 
	    bounds_W(iz,iy,ix) = 1;
	  end
	  % Is it a eastern boundary ?
	  if ix+1 >= nlon % Reach the domain limit
	    bounds_E(iz,iy,ix) = 1;
	  elseif pii(iz,iy,ix+1) == 0
	    bounds_E(iz,iy,ix) = 1;
	  end
	  
	  % Is it a southern boundary ?
	  if iy-1 <= 0 % Reach the domain limit
	    bounds_S(iz,iy,ix) = 1;
	  elseif pii(iz,iy-1,ix) == 0
	    bounds_S(iz,iy,ix) = 1;
	  end
	  % Is it a northern boundary ?
	  if iy+1 >= nlat % Reach the domain limit
	    bounds_N(iz,iy,ix) = 1;
	  elseif pii(iz,iy+1,ix) == 0
	    bounds_N(iz,iy,ix) = 1;
	  end
	  
	  % Is it a top boundary ?
	  if iz-1 <= 0 % Reach the domain limit
	    bounds_T(iz,iy,ix) = 1;
	  elseif pii(iz-1,iy,ix) == 0
	    bounds_T(iz,iy,ix) = 1;
	  end
	  % Is it a bottom boundary ?
	  if iz+1 >= ndpt % Reach the domain limit
	    bounds_B(iz,iy,ix) = 1;
	  elseif pii(iz+1,iy,ix) == 0
	    bounds_B(iz,iy,ix) = 1;
	  end
	  
	end % if 
      end %for ix	
    end % for iy
  end % for iz
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
switch nargout
  
  case 1
varargout(1) = {bounds_N};
  case 2
varargout(1) = {bounds_N};
varargout(2) = {bounds_S};
  case 3
varargout(1) = {bounds_N};
varargout(2) = {bounds_S};
varargout(3) = {bounds_W};
  case 4
varargout(1) = {bounds_N};
varargout(2) = {bounds_S};
varargout(3) = {bounds_W};
varargout(4) = {bounds_E};
  case 5
varargout(1) = {bounds_N};
varargout(2) = {bounds_S};
varargout(3) = {bounds_W};
varargout(4) = {bounds_E};
varargout(5) = {bounds_T};
  case 6
varargout(1) = {bounds_N};
varargout(2) = {bounds_S};
varargout(3) = {bounds_W};
varargout(4) = {bounds_E};
varargout(5) = {bounds_T};
varargout(6) = {bounds_B};

end %switch