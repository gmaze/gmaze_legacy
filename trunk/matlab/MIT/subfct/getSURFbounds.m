% [BN BS BW BE] = getSURFbounds(PII)
%
% Given a 1/0 2D matrix PII, determine faces bounding the surface
% 
% INPUT:
%  PII is of dimensions: PII(NLAT,NLON)
%  with:
%   LAT northward
%   LON eastward
%
% OUTPUT:
% BN,BS, BW,BE, are 2D matrices like PII, filled with 0 or 1.
% 1 indicates a surface bounding the surface
%
% BN stands for northern bound
% BS stands for southern bound
% BW stands for western bound
% BE stands for eastern bound
%
%  gmaze@mit.edu 2007/08/07
%

function varargout = getSURFbounds(varargin)

pii  = varargin{1};
nlat = size(pii,1);
nlon = size(pii,2);


  bounds_W = zeros(nlat,nlon);
  bounds_E = zeros(nlat,nlon);
  bounds_S = zeros(nlat,nlon);
  bounds_N = zeros(nlat,nlon);


    for iy = 1 : nlat
      for ix = 1 : nlon
	if pii(iy,ix) == 1
	  
	  % Is it a western boundary ?
	  if ix-1 <= 0 % Reach the domain limit
	    bounds_W(iy,ix) = 1;
	  elseif pii(iy,ix-1) == 0 
	    bounds_W(iy,ix) = 1;
	  end
	  % Is it a eastern boundary ?
	  if ix+1 >= nlon % Reach the domain limit
	    bounds_E(iy,ix) = 1;
	  elseif pii(iy,ix+1) == 0
	    bounds_E(iy,ix) = 1;
	  end
	  
	  % Is it a southern boundary ?
	  if iy-1 <= 0 % Reach the domain limit
	    bounds_S(iy,ix) = 1;
	  elseif pii(iy-1,ix) == 0
	    bounds_S(iy,ix) = 1;
	  end
	  % Is it a northern boundary ?
	  if iy+1 >= nlat % Reach the domain limit
	    bounds_N(iy,ix) = 1;
	  elseif pii(iy+1,ix) == 0
	    bounds_N(iy,ix) = 1;
	  end
	
	end % if 
      end %for ix	
    end % for iy

  
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

end %switch