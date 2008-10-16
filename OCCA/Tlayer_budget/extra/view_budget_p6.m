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

% Horizontal maps
% Above vs under the JFM mixed layer depth:

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
[a b c] = meshgrid(lat,lon,abs(diff(dpt))); ddpt = permute(c,[3 2 1]); clear a b c
ddpt = ddpt(1:end-1,:,:)/2 + ddpt(2:end,:,:)/2;
ddpt = cat(1,7.5*ones(1,nlat,nlon),ddpt);
ddpt = cat(1,ddpt,NaN*ones(1,nlat,nlon));


	
if 0
	figure;
	iw=2;jw=2;
	subplot(iw,jw,1); pcolor(y,-z,squeeze(maskSF(:,:,100)));shading flat;title('mask SF')
	subplot(iw,jw,2); pcolor(y,-z,squeeze(maskML(:,:,100)));shading flat;title('mask ML')
	subplot(iw,jw,3); pcolor(y,-z,squeeze(maskDW(:,:,100)));shading flat;title('mask DW')
	subplot(iw,jw,4); pcolor(y,-z,squeeze(maskUP(:,:,100)));shading flat;title('mask UP')
end

load LSmask_KESS_OCCA.mat; mask_KESS(mask_KESS==0)=NaN;

for imask = 5:5
	switch imask
		case 1, mask = maskSF; inte(1).val='-15'; inte(2).val='s'; labF = 'VolBdgmap_0406_top15';
		case 2, mask = maskML; inte(1).val='MLD'; inte(2).val='-15';labF = 'VolBdgmap_0406_MLD';
		case 3, mask = maskDW; inte(1).val='b'; inte(2).val='MLD'; labF = 'VolBdgmap_0406_bot';
		case 4, mask = maskUP; inte(1).val='MLD'; inte(2).val='s'; labF = 'VolBdgmap_0406_down15';
		case 5, mask = ones(nz,ny,nx); inte(1).val='b'; inte(2).val='s'; labF = 'VolBdgmap_0406_wcol';
	end


m_proj('mercator','lon',[lon2D_D(1) lon2D_D(end)],'lat',[lat2D_D(1) lat2D_D(end)]);
m_proj('mercator','lon',[128 182],'lat',[6 56]);
m_proj('mercator','lon',[129 180],'lat',[15 50]);

sg = -1;
C1 = sg*Mq;
C2 = sg*(Mdiff+MtendA+Mall);
C3 = sg*(Madv); C3x = sg*Madvx; C3y = sg*Madvy;
C4 = sg*MtendN-(C1+C2+C3);
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

figure;     
iw=2;jw=2; clear sb cl
load mapanom2;cmap=mapanom;c=[1 1];
colormap(logcolormap(12*2,c(1),c(2),cmap));

if 1
	ncl = 13;
	cmap=jet(ncl);
%	load mapanom, cmap = mycolormap(mapanom,ncl);
%	cmap=mycolormap(mapanom,ncl);
	cmap(fix(ncl/2)+1,:)=[1 1 1]*1;colormap(cmap);
end

for ipl = 1 : 4
	switch ipl		
		case 1, C = squeeze(nansum(C1.*mask)); lab='F';
		case 2, C = squeeze(nansum(C2.*mask)); lab='A_{diff}';
		case 3, C = squeeze(nansum(C3.*mask)); lab='A_{adv}';
		case 4, C = squeeze(nansum(C4.*mask)); lab='Residual';
	end
	C(C==-9999)=NaN;
	cx='auto';
	cx=[-1 1]*0.013;
	
	sb(ipl)=subplot(iw,jw,ipl); hold on
	m_pcolor(x,y,C);shading flat;
	caxis(cx);
	if ipl == 3		& 0
		[yy xx] = meshgrid(y,x);
		sg = -1;
		Cx = squeeze(nansum(sg*C3x(iz,:,:),1));
		Cy = squeeze(nansum(sg*C3y(iz,:,:),1));
		dx = 4; nx=length(x);
		dy = 4; ny=length(y);
		m_quiver(xx(1:dx:nx,1:dy:ny),yy(1:dx:nx,1:dy:ny),Cx(1:dy:ny,1:dx:nx)',Cy(1:dy:ny,1:dx:nx)',5,'color','k');
	end
	if ipl ==3 & 0
		Cx = squeeze(nansum(squeeze(nanmean(UVEL(1:3,:,:,:))).*maskNPW.*ddpt.*mask_KESS,1)./nansum(maskNPW.*ddpt,1));
		Cy = squeeze(nansum(squeeze(nanmean(VVEL(1:3,:,:,:))).*maskNPW.*ddpt.*mask_KESS,1)./nansum(maskNPW.*ddpt,1));
		[yy xx] = meshgrid(lat,lon);
		m_quiver(xx,yy,Cx',Cy',10);
		
	end
	

	
	
%	[cs,h]=m_contourf(lon,lat,squeeze(nanmean(ETA(1:3,:,:))),[-2:.2:2],'k');set(h,'edgecolor',[1 1 1]*.5);
	[cs,h]=m_contour(lon,lat,squeeze(SST(3,:,:)),[16 19]);set(h,'edgecolor','k','linewidth',1);
	[cs,h]=m_contour(lon,lat,squeeze(SST(3+6,:,:)),[16 19]);set(h,'edgecolor','k','linewidth',1);
	[cs,h]=m_contour(lon,lat,squeeze(nanmean(MLD([1:3],:,:),1)).*squeeze(mask_KESS(1,:,:)),[200:100:500]);set(h,'edgecolor','k');clabel(cs,h,'rotation',0,'labelspacing',200,'fontsize',6);
%	l = m_line([1 1]*lon2D_D(find(lon2D_D>=lon(ixT(1)),1)),lat([1 end]));set(l,'color','k');
	m_coast('patch',[1 1 1]*.4);
	m_grid('xtick',[0:10:360],'ytick',[0:5:90],'fontsize',7);
	title(sprintf('\\int_{%s}^{%s} %s dz (%3.3g Svy)',inte(1).val,inte(2).val,lab,nansum(C(:))),'fontweight','bold');	
	cl(ipl) = colorbar;
	m_text(132,47,sprintf('%s',ALPHABET(ipl)),'color','k','backgroundcolor','w','fontweight','bold','fontsize',12);
end

set(cl(1:3),'visible','off');
pos4=get(sb(4),'position');
pos=get(cl(4),'position'); set(cl(4),'position',[pos(1)+0.05 pos(2) 0.018 1-pos(2)*1.8]);
%set(cl(4),'fontsize',6);
set(sb(4),'position',pos4);
%set(get(cl(4),'title'),'string','Sv.y/m^2');
set(cl(4),'ytick',[cx(1)+diff(cx)/ncl/2:diff(cx)/ncl:cx(2)-diff(cx)/ncl/2])
set(cl(4),'yticklabel',fix([cx(1)+diff(cx)/ncl/2:diff(cx)/ncl:cx(2)-diff(cx)/ncl/2]*1e3*10)/10)
set(get(cl(4),'title'),'string','10^{-3} Sv.y');
for ip = 1 : 4, posiI(ip,:) = get(sb(ip),'position'); end
posiCLI = get(cl(4),'position');

if prtimg,
	view_budget_subplot;
	footnote('del');
	print(gcf,'-depsc2',strcat('img/',RUNlabel,'_',labF,'.eps'));
	footnote;
end
	
	
end %for imask



























