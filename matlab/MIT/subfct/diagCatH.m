% Ch = diagCatH(C,depth,h)
%
% Get field C(depth,lat,lon) at depth h(lat,lon)
%
% depth < 0
% h     < 0 
%
% G. Maze, MIT, June 2007
%y

function varargout = diagCatH(C,Z,h)

% 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROC
[nz,ny,nx] = size(C);
Ch = zeros(ny,nx);

% 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTING
warning off
 for ix = 1 : nx
   for iy = 1 : ny
		if ~isnan(C(1,iy,ix))
		     Ch(iy,ix) = interp1( Z, squeeze(C(:,iy,ix)) , h(iy,ix) , 'linear');
		end
   end
 end
warning on
 
% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
switch nargout
 case 1
  varargout(1) = {Ch};
end