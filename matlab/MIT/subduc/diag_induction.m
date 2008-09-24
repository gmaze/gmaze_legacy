function [induction,gradx,grady] = diag_induction(ustar,vstar,h,dxc,dyc);
%function [induction,gradx,grady] = diag_induction(ustar,vstar,h,dxc,dyc)
%
% Diagnose lateral induction u_h . grad h 
%
% G. Gebbie, 2003. 

 [nx,ny] = size(ustar);

 gradx(2:nx,:) = (h(2:nx,:)  - h(1:nx-1,:));
 grady(:,2:ny) =  h(:,2:ny)  - h(:,1:ny-1);

 gradx = gradx ./ dxc;
 grady = grady ./ dyc;

 udelh = ustar .* gradx;
 vdelh = vstar .* grady;

%% now move udelh from U points to H points, in order to match up with W*.
%% involves an average.
 udelh2 = (udelh(2:nx,:)+udelh(1:nx-1,:))./2;
 vdelh2 = (vdelh(:,2:ny)+vdelh(:,1:ny-1))./2;

 udelh2(nx,:) = 0;
 vdelh2(:,ny)=0;

induction = udelh2 + vdelh2;
