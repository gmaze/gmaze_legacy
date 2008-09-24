function [w] = integrate_for_w(u,v,dxg,dyg,raw, delZ )
%function [w] = integrate_for_w(u,v,dxg,dyg, raw, delZ )
%
% Get the vertical velocity from the horizontal velocity.
% Use the conservation of volume for this computation. 
% U and V are 3-dimensional.
% Following the MITgcm subroutine, integrate_for_w.F
%
% uncertain about the halo region.
%
% G. Gebbie, MIT-WHOI, 2003.
%

[nx ny nz] = size(u);

k=1:nz;
utrans(:,:,k) = u(:,:,k) .* dyg(:,:,ones(1,nz));
vtrans(:,:,k) = v(:,:,k) .* dxg(:,:,ones(1,nz));

%% is this the best way to overlap?
utrans(nx+1,:,k) = utrans(1,:,k);
vtrans(:,ny+1,k) = vtrans(:,1,k);

%w(:,:,23) = zeros(nx,ny,nz);

kbot = nz;
i=1:nx;
j=1:ny;
w(:,:,kbot) = - (utrans(i+1,j,kbot) - utrans(i,j,kbot) + ...
                 vtrans(i,j+1,kbot) - vtrans(i,j,kbot)) ...
		 .*(delZ(kbot)) ./raw(i,j);

for k=nz-1:-1:1
  w(:,:,k) = w(:,:,k+1)- ((utrans(i+1,j,k) - utrans(i,j,k) + ...
	  vtrans(i,j+1,k) - vtrans(i,j,k)) .* (delZ(k) ./raw(i,j)));
end

return
