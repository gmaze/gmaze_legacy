clear cl sb tt


maskUP = zeros(nz,ny,nx);
maskDW = zeros(nz,ny,nx);
maskSF = zeros(nz,ny,nx);
maskML = zeros(nz,ny,nx);
for iz = 1 : nz
	maskUP(iz,MLDjfm>=z(iz)) = 1;
	maskDW(iz,MLDjfm<z(iz)) = 1;
	maskSF(iz,15.*ones(ny,nx)>z(iz)) = 1;
	maskML(iz,15.*ones(ny,nx)<=z(iz)&MLDjfm>=z(iz)) = 1;
end

ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';


load mapanom2;cmap=mapanom;c=[1 1];
colormap(logcolormap(256*2,c(1),c(2),cmap));
ncl = 13;
cmap=jet(ncl);
%load mapanom, cmap = mycolormap(mapanom,ncl);
%cmap=mycolormap(mapanom,ncl);
cmap(fix(ncl/2)+1,:)=[1 1 1]*1;colormap(cmap);
	
ix = 1:nx;
%ix=find(x>=140,1);