%DEF
%REQ
%
% Created by Guillaume Maze on 2008-10-01.
% Copyright (c) 2008 Guillaume Maze. 
% http://www.guillaumemaze.org/codes

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

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

maskNPW = zeros(ndpt,nlat,nlon);
maskNPW(squeeze(nanmean(THETA(1:3,:,:,:))) >=16 & squeeze(nanmean(THETA(1:3,:,:,:))) <=19) = 1;


figure;     
iw=2;jw=2;clear cl sb
load mapanom2;cmap=mapanom;c=[1 1];
colormap(logcolormap(256*2,c(1),c(2),cmap));
	ncl = 13;
	cmap=jet(ncl);
%	load mapanom, cmap = mycolormap(mapanom,ncl);
%	cmap=mycolormap(mapanom,ncl);
	cmap(fix(ncl/2)+1,:)=[1 1 1]*1;colormap(cmap);
	
%colormap(cmap);
%ix = find(lon2D_D>=lon(ixT(1)),1);
ix=1:size(Mq,3);
%ix=find(x>=140,1);

sg = -1;
C1 = sg*Mq;
C2 = sg*(Mdiff+MtendA+Mall);
C3 = sg*(Madv);
C4 = sg*MtendN-(C1+C2+C3);

%mask = maskUP+maskDW;
%mask = maskUP;
mask = ones(nz,ny,nx);

C1 = C1.*mask;
C2 = C2.*mask;
C3 = C3.*mask;
C4 = C4.*mask;

for ipl = 1 : 4
	switch ipl		
		case 1, C = squeeze(nansum(C1(:,:,ix),3)); lab='F';
		case 2, C = squeeze(nansum(C2(:,:,ix),3)); lab='A_{diff}';
		case 3, C = squeeze(nansum(C3(:,:,ix),3)); lab='A_{adv}';	
		case 4, C = squeeze(nansum(C4(:,:,ix),3)); lab='Residual';
	end
	C(C==-9999)=NaN;
	cx='auto';
	cx=[-1 1]*0.013;
	if length(ix) == 1, cx = [-1 1]*5e-4;end
	C(C==0) = NaN;
	
	sb(ipl)=subplot(iw,jw,ipl); hold on
	pcolor(lat2D_D(1,:)',gdept_D,C);shading flat;
	caxis(cx);
	set(gca,'ydir','reverse');
	set(gca,'xlim',[10 43]);
%	[cs,h] = contour(x,y,LAYs,[20:10:60]); set(h,'color','w','linewidth',2)
%	[cs,h] = contour(x,y,squeeze(LAYm(3,:,:)), [1 1]*10); set(h,'edgecolor','k','linewidth',2)
%	[cs,h] = contour(x,y,squeeze(LAYm(9,:,:)),[1 1]*10); set(h,'edgecolor','k','linewidth',2,'linestyle','--')
%	[cs,h] = contour(lat,-dpt,squeeze(THETA(3,:,:,find(lon>=150,1))),[16 19]);set(h,'edgecolor','b','linewidth',2);
%	[cs,h] = contour(lat,-dpt,squeeze(THETA(9,:,:,find(lon>=150,1))),[16 19]);set(h,'edgecolor','r','linewidth',2);
%	l = line(lat,squeeze(-h16(1,:,ixT(1)))); set(l,'color','g','linewidth',1);
%	l = line(lat,squeeze(-h18(1,:,ixT(1)))); set(l,'color','g','linewidth',1);
%	l = line(lat,squeeze(-h16(2,:,ixT(2)))); set(l,'color','g','linewidth',1,'linestyle','--');
%	l = line(lat,squeeze(-h18(2,:,ixT(2)))); set(l,'color','g','linewidth',1,'linestyle','--');
	l = line(lat,nanmean(squeeze(nanmean(MLD([1:3],:,:),1)).*squeeze(mask_KESS(1,:,:)),2)); set(l,'color','k','linewidth',1);
%	l = line(y,squeeze(nanmean(MLDjfm(:,ix),2))); set(l,'color','k','linewidth',1);
	if 0
		[cs,h]=contour(y,z,squeeze(nanmean(maskSF(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
		[cs,h]=contour(y,z,squeeze(nanmean(maskML(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
		[cs,h]=contour(y,z,squeeze(nanmean(maskDW(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
		[cs,h]=contour(y,z,squeeze(nanmean(maskUP(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
	end
	title(sprintf('\\int %s dx (%3.3g Svy)',lab,nansum(nansum(C,2),1)),'fontweight','bold');	
	axis([10 43 0 600]);box on;
	daspect([22 500 1])
	xlabel('Latitude');
%	xlabel(sprintf('Latitude (Section at longitude: %1.3gE)',lon(ixT(1))));
	ylabel('Depth (m)');
	set(gca,'fontsize',7);
	for iiy = 0:5:60
		line([1 1]*iiy,get(gca,'ylim'),'color','k','linestyle',':');
	end
	for iix = 600 : -50 : 0
		line(get(gca,'xlim'),[1 1]*iix,'color','k','linestyle',':');
	end	
	line([get(gca,'xlim') fliplr(get(gca,'xlim')) min(get(gca,'xlim'))],...
		[min(get(gca,'ylim')) get(gca,'ylim') fliplr(get(gca,'ylim'))],'color','k');
	cl(ipl) = colorbar;
end
set(cl(1:3),'visible','off');
pos4=get(sb(4),'position');
pos=get(cl(4),'position'); set(cl(4),'position',[pos(1)+0.05 pos(2) 0.018 1-pos(2)*1.8]);
%set(cl(4),'fontsize',6);
set(sb(4),'position',pos4);
set(cl(4),'ytick',[cx(1)+diff(cx)/ncl/2:diff(cx)/ncl:cx(2)-diff(cx)/ncl/2])
set(cl(4),'yticklabel',fix([cx(1)+diff(cx)/ncl/2:diff(cx)/ncl:cx(2)-diff(cx)/ncl/2]*1e3*10)/10)
set(get(cl(4),'title'),'string','10^{-3} Sv.y');
posiCLI = get(cl(4),'position');
for ip = 1 : 4, posiI(ip,:) = get(sb(ip),'position'); end


if prtimg,
	view_budget_subplot;
	footnote('del');
	print(gcf,'-depsc2',strcat('img/',RUNlabel,'_VolBdgmap_0406_zonalMean.eps'));
	footnote;
end



































