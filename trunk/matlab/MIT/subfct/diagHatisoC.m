% [H,[dH,h,dh]] = diagHatisoC(C,Z,isoC,[dC])
%
% Get depth of C(depth,lat,lon) = isoC
% Z < 0
%
% OUTPUTS:
% H(lat,lon)  is the depth determine with the input resolution
% dH(lat,lon) is the thickness of the layer: isoC-dC < C < isoC+dC from H
% h(lat,lon) is a more accurate depth (determined with interpolation)
% dh(lat,lon) is the interp thickness of the layer: isoC-dC < C < isoC+dC from h
%
% G. Maze, MIT, June 2007
%

function varargout = diagHatisoC(C,Z,isoC,varargin)


% 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROC
[nz,ny,nx] = size(C);
H = zeros(ny,nx).*NaN;
if nargout >= 2
  h = zeros(ny,nx).*NaN;
  z = [0:-1:Z(end)]; % Vertical axis of the interpolated depth
  if nargin == 4
    dh = zeros(ny,nx).*NaN;
  end
end
if nargin == 4
  dC = varargin{1};
  dH = zeros(ny,nx).*NaN;
end

% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTING
warning off
 for ix = 1 : nx
   for iy = 1 : ny
     c = squeeze(C(:,iy,ix))';   
     if isnan(c(1)) ~= 1
     if length(find(c>=isoC))>0 & length(find(c<=isoC))>0
	
        % Raw value of depth:
	[cm icm] = min(abs(abs(c)-abs(isoC)));
        H(iy,ix) = Z(icm);
	
	if nargout >= 2 & nargin == 4
	  % raw thickness
   	   [cm icm1] = min(abs(abs(c)-abs(isoC+dC)));
   	   [cm icm2] = min(abs(abs(c)-abs(isoC-dC)));
           dH(iy,ix) = max(Z([icm1 icm2])) - min(Z([icm1 icm2]));
	end 
	
	if nargout >= 3
          % Interp guess of depth:
          cc = feval(@interp1,Z,c,z,'linear');
	  [cm icm] = min(abs(abs(cc)-abs(isoC)));
          h(iy,ix) = z(icm);
	end 
	
	if nargout >= 4 & nargin == 4
          % Interp guess of thickness:
   	      [cm icm1] = min(abs(abs(cc)-abs(isoC+dC)));
   	      [cm icm2] = min(abs(abs(cc)-abs(isoC-dC)));
              dh(iy,ix) = max(z([icm1 icm2])) - min(z([icm1 icm2]));
	end 
	
     end % if found value in the profile
     end % if point n ocean
   end
 end
warning on 
 
% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
switch nargout
 case 1
  varargout(1) = {H};
 case 2
  varargout(1) = {H};
  varargout(2) = {dH};
 case 3
  varargout(1) = {H};
  varargout(2) = {dH};
  varargout(3) = {h};
 case 4
  varargout(1) = {H};
  varargout(2) = {dH};
  varargout(3) = {h};
  varargout(4) = {dh};
end
