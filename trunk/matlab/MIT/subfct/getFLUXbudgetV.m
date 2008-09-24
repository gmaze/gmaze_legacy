% [D1,D2] = getFLUXbudgetV(z,y,x,Fx,Fy,Fz,box,mask)
%
% Compute the two terms:
% D1 as the volume integral of the flux divergence
% D2 as the surface integral of the normal flux across the volume's boundary
%
% Given a 3D flux vector ie:
%  Fx(z,y,x)
%  Fy(z,y,x)
%  Fz(z,y,x)
%
% Defined on the C-grid at U,V,W locations (bounding the tracer point)
% given by:
% z ( = W detph )
% y ( = V latitude)
% x ( = U longitude)
%
% box is a 0/1 3D matrix defined on the tracer grid
% ie, of dimension: z-1 , y-1 , x-1
% 
% All fluxes are supposed to be scaled by the surface of the cell tile they
% account for.
%
% Each D is decomposed as: 
%  D(1) = Total integral (Vertical+Horizontal)
%  D(2) = Vertical contribution
%  D(3) = Horizontal contribution
%
% Rq:
% The divergence theorem is thus a conservation law which states that 
% the volume total of all sinks and sources, the volume integral of 
% the divergence, is equal to the net flow across the volume's boundary.
%
% gmaze@mit.edu 2007/07/19
%
%

function varargout = getFLUXbudgetV(varargin)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PRELIM

dptw = varargin{1}; ndptw = length(dptw);
latg = varargin{2}; nlatg = length(latg);
long = varargin{3}; nlong = length(long);

ndpt = ndptw - 1;
nlon = nlong - 1;
nlat = nlatg - 1;

Fx = varargin{4};
Fy = varargin{5};
Fz = varargin{6};
%ndptw = size(Fz,1);
%nlatg = size(Fy,2);
%nlong = size(Fx,3);

if size(Fx,1) ~= ndpt
  disp('Error, Fx(1) wrong dim');
  return
end
if size(Fx,2) ~= nlatg-1
  disp('Error, Fx(2) wrong dim');
  whos Fx 
  return
end
if size(Fx,3) ~= nlong
  disp('Error, Fx(3) wrong dim');
  return
end

% Get the volume definition 0/1:
pii  = varargin{7};
% Get the centered mask 1/NaN:
mask = varargin{8};

% Check if we compute the real term:
if nargin == 9
  isoTflag = varargin{9};
else
  isoTflag = 0;
end

% Ensure we're not gonna missed points cause is messy around:
if 1
  Fx(isnan(Fx)) = 0;
  Fy(isnan(Fy)) = 0;
  Fz(isnan(Fz)) = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Compute the volume integral of flux divergence:
% (gonna be on the tracer grid)
dFdx = ( Fx(:,:,1:nlong-1) - Fx(:,:,2:nlong) );
dFdy = ( Fy(:,1:nlatg-1,:) - Fy(:,2:nlatg,:) );
dFdz = ( Fz(2:ndptw,:,:)   - Fz(1:ndptw-1,:,:) );

dFdx = dFdx.*mask;
dFdy = dFdy.*mask;
dFdz = dFdz.*mask;

% And sum it over the box:
D1(1) = nansum(nansum(nansum( dFdx.*pii + dFdy.*pii + dFdz.*pii )));
D1(2) = nansum(nansum(nansum( dFdz.*pii )));
D1(3) = nansum(nansum(nansum( dFdy.*pii + dFdx.*pii )));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Compute the surface integral of the flux:
if nargout > 1
if exist('getVOLbounds')
  method = 3;
else
  method = 2;
end


switch method 
%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
 case 2
  bounds_W = zeros(ndpt,nlat,nlon);
  bounds_E = zeros(ndpt,nlat,nlon);
  bounds_S = zeros(ndpt,nlat,nlon);
  bounds_N = zeros(ndpt,nlat,nlon);
  bounds_T = zeros(ndpt,nlat,nlon);
  bounds_B = zeros(ndpt,nlat,nlon);
  Zflux = 0;
  Mflux = 0;
  Vflux = 0;

  for iz = 1 : ndpt
    for iy = 1 : nlat
      for ix = 1 : nlon
	if pii(iz,iy,ix) == 1
	  
	  % Is it a western boundary ?
	  if ix-1 <= 0 % Reach the domain limit
	    bounds_W(iz,iy,ix) = 1;
	    Zflux = Zflux + Fx(iz,iy,ix);
	  elseif pii(iz,iy,ix-1) == 0 
	    bounds_W(iz,iy,ix) = 1;
	    Zflux = Zflux + Fx(iz,iy,ix);
	  end
	  % Is it a eastern boundary ?
	  if ix+1 >= nlon % Reach the domain limit
	    bounds_E(iz,iy,ix) = 1;
	    Zflux = Zflux - Fx(iz,iy,ix+1);
	  elseif pii(iz,iy,ix+1) == 0
	    bounds_E(iz,iy,ix) = 1;
	    Zflux = Zflux - Fx(iz,iy,ix+1);
	  end
	  
	  % Is it a southern boundary ?
	  if iy-1 <= 0 % Reach the domain limit
	    bounds_S(iz,iy,ix) = 1;
	    Mflux = Mflux + Fy(iz,iy,ix);
	  elseif pii(iz,iy-1,ix) == 0
	    bounds_S(iz,iy,ix) = 1;
	    Mflux = Mflux + Fy(iz,iy,ix);
	  end
	  % Is it a northern boundary ?
	  if iy+1 >= nlat % Reach the domain limit
	    bounds_N(iz,iy,ix) = 1;
	    Mflux = Mflux - Fy(iz,iy+1,ix);
	  elseif pii(iz,iy+1,ix) == 0
	    bounds_N(iz,iy,ix) = 1;
	    Mflux = Mflux - Fy(iz,iy+1,ix);
	  end
	  
	  % Is it a top boundary ?
	  if iz-1 <= 0 % Reach the domain limit
	    bounds_T(iz,iy,ix) = 1;
	    Vflux = Vflux - Fz(iz,iy,ix);
	  elseif pii(iz-1,iy,ix) == 0
	    bounds_T(iz,iy,ix) = 1;
	    Vflux = Vflux - Fz(iz,iy,ix);
	  end
	  % Is it a bottom boundary ?
	  if iz+1 >= ndpt % Reach the domain limit
	    bounds_B(iz,iy,ix) = 1;
	    Vflux = Vflux + Fz(iz+1,iy,ix);
	  elseif pii(iz+1,iy,ix) == 0
	    bounds_B(iz,iy,ix) = 1;
	    Vflux = Vflux + Fz(iz+1,iy,ix);
	  end
	  
	end %for iy
      end %for ix	
       
    end
  end  
  
D2(1) = Vflux+Mflux+Zflux;
D2(2) = Vflux;
D2(3) = Mflux+Zflux;


%%%%%%%%%%%%%%%%%%%%
  case 3
  [bounds_N bounds_S bounds_W bounds_E bounds_T bounds_B] = getVOLbounds(pii.*mask);
  Mflux = nansum(nansum(nansum(...
      bounds_S.*squeeze(Fy(:,1:nlat,:)) - bounds_N.*squeeze(Fy(:,2:nlat+1,:)) )));
  Zflux = nansum(nansum(nansum(...
      bounds_W.*squeeze(Fx(:,:,1:nlon)) - bounds_E.*squeeze(Fx(:,:,2:nlon+1)) )));
  Vflux = nansum(nansum(nansum(...
      bounds_B.*squeeze(Fz(2:ndpt+1,:,:))-bounds_T.*squeeze(Fz(1:ndpt,:,:)) )));

  D2(1) = Vflux+Mflux+Zflux;
  D2(2) = Vflux;
  D2(3) = Mflux+Zflux;
  
end %switch method surface flux
end %if we realy need to compute this ?




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS


switch nargout
  case 1
varargout(1) = {D1};
  case 2
varargout(1) = {D1};
varargout(2) = {D2};
  case 3
varargout(1) = {D1};
varargout(2) = {D2};
varargout(3) = {bounds_N};
  case 4
varargout(1) = {D1};
varargout(2) = {D2};
varargout(3) = {bounds_N};
varargout(4) = {bounds_S};
  case 5
varargout(1) = {D1};
varargout(2) = {D2};
varargout(3) = {bounds_N};
varargout(4) = {bounds_S};
varargout(5) = {bounds_W};
  case 6
varargout(1) = {D1};
varargout(2) = {D2};
varargout(3) = {bounds_N};
varargout(4) = {bounds_S};
varargout(5) = {bounds_W};
varargout(6) = {bounds_E};
  case 7
varargout(1) = {D1};
varargout(2) = {D2};
varargout(3) = {bounds_N};
varargout(4) = {bounds_S};
varargout(5) = {bounds_W};
varargout(6) = {bounds_E};
varargout(7) = {bounds_T};
  case 8
varargout(1) = {D1};
varargout(2) = {D2};
varargout(3) = {bounds_N};
varargout(4) = {bounds_S};
varargout(5) = {bounds_W};
varargout(6) = {bounds_E};
varargout(7) = {bounds_T};
varargout(8) = {bounds_B};

end %switch