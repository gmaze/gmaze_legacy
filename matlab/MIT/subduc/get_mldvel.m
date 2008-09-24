function [ustar,vstar,wstar] = get_mldvel(u,v,w,depth,delZ,h)
%function [ustar,vstar,wstar] = get_mldvel(u,v,w,Z,delZ,h)
%
% Get velocity at a surface h = h(x,y).
% Velocity remains on the C-grid with depths "depth".
%
% depth < 0
% delZ  < 0
% h     < 0 
%
% G. Maze: remove extra function dependance
% 
% Started: D. Jamous, 1996, FORTRAN diags.
%
% Translated: G. Gebbie, MIT-WHOI, November 2003.

[nx,ny,nz]=size(u);

 ustar = zeros(nx,ny);
 vstar = zeros(nx,ny);
 wstar = zeros(nx,ny);

 zbot = cumsum(delZ)';
 zbot = depth;

 for i=2:nx-1
   for j=2:ny-1
     ustar(i,j) = interp1( depth, squeeze(u(i,j,:)),(h(i,j)+h(i-1,j))./2,'linear');
     vstar(i,j) = interp1( depth, squeeze(v(i,j,:)),(h(i,j)+h(i,j-1))./2,'linear');
   end
 end
 for i=1:nx-1
   for j=1:ny-1
     wstar(i,j) = interp1( squeeze(zbot(1:nz)), squeeze(w(i,j,:)), h(i,j), 'linear');
   end
 end

 ustar(isnan(ustar))= 0;
 vstar(isnan(vstar))= 0;
 wstar(isnan(wstar))= 0;
