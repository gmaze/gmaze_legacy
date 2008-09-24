% PII = boxcar(C3D,H,X,Y,Z,isoC,dC)
% The boxcar function:
%                               {  isoC-dC/2 <= C3D(iZ,iY,iX) < isoC + dC/2
% PII(isoC,C3D(iZ,iY,iX) = 1 if:{  Z(iZ) > H(iY,iX)
%                        = 0 otherwise
%
% Rq:
% H may be a single value
% Z and H should be negative
% Z orientatd downward
%

%function [PII] = boxcar(C3D,H,X,Y,Z,isoC,dC)

function [PII A B C] = boxcar(C3D,H,X,Y,Z,isoC,dC)

nz  = length(Z);
ny  = length(Y);
nx  = length(X);

method = 2;

if length(H) == 1, H = H.*ones(ny,nx); end

switch method
  case 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     PII = zeros(nz,ny,nx); 
     warning off
     for ix = 1 : nx
       for iy = 1 : ny
	 Cprof = squeeze(C3D(:,iy,ix));
	 li = find( isoC-dC/2 <= Cprof   & ...
		        Cprof < isoC+dC/2 & ...
		            Z > H(iy,ix) );
	 if ~isempty(li)
	   PII(li,iy,ix) = 1;
	 end %if
       end %for iy
     end %for ix
     warning on

  case 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     PII = ones(nz,ny,nx); 
     
     [a b]=meshgrid(Z,H); b=reshape(b,[ny nx nz]);b=permute(b,[3 1 2]);H=b;clear a b
     [a b c]=meshgrid(Z,Y,X);a=permute(a,[2 1 3]);Z=a;clear a b c
     
     PII(find( -dC/2 < C3D-isoC & C3D-isoC <= +dC/2 & H<=Z  ))  = 0;
     PII = 1-PII;


end %switch method


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Also provide the 1/0 matrix of the layer boundaries:
bounds_vert = zeros(nz,ny,nx);
bounds_meri = zeros(nz,ny,nx);

for ix = 1 : nx
piisect   = squeeze(PII(:,:,ix));
boundsect = zeros(nz,ny);
% Determine vertical boundaries of the layer:
for iy = 1 : ny
  li = find(piisect(:,iy)==1);
  if length(li) ~= 0
    boundsect(li(1),iy)  = 1;
    boundsect(li(end),iy) = 1;
  end
end
bounds_vert(:,:,ix) = boundsect;

boundsect = zeros(nz,ny);
% Determine horizontal meridional boundaries of the layer:
for iz = 1 : nz
  li = find(piisect(iz,:)==1);
  if length(li) ~= 0
    boundsect(iz,li(1))   = 1;
    boundsect(iz,li(end)) = 1;
  end
end
bounds_meri(:,:,ix) = boundsect;

end %for ix

bounds_zona = zeros(nz,ny,nx);
for iy = 1 : ny
piisect   = squeeze(PII(:,iy,:));
boundsect = zeros(nz,nx);
% Determine horizontal zonal boundaries of the layer:
for iz = 1 : nz
  li = find(piisect(iz,:)==1);
  if length(li) ~= 0
    boundsect(iz,li(1))   = 1;
    boundsect(iz,li(end)) = 1;
  end
end
bounds_zona(:,iy,:) = boundsect;
end %for iy

A = bounds_vert;
B = bounds_meri;
C = bounds_zona;

