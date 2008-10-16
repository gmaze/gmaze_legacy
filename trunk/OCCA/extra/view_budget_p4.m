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

% TOTAL VERTICAL INTEGRATION:

%load LSmask_KESS_OCCA.mat; mask_KESS(mask_KESS==0)=NaN;
iz = 1 : size(Mq,1);   inte(1).val='b'; inte(2).val='s';
%iz = find(gdept_D<15); inte(1).val='-15'; inte(2).val='s';
%iz = find(gdept_D>=15); inte(1).val='b'; inte(2).val='-15';
%iz = find(gdept_D<200); inte(1).val='-200'; inte(2).val='s';
%iz = find(gdept_D>=200); inte(1).val='b'; inte(2).val='-200';

m_proj('mercator','lon',[lon2D_D(1) lon2D_D(end)],'lat',[lat2D_D(1) lat2D_D(end)]);
%m_proj('mercator','lon',[128 182],'lat',[6 56]);
%m_proj('mercator','lon',[129 180],'lat',[15 50]);
%mask = squeeze(mask_KESS(1,:,:)); mask(mask==0)=NaN;
mask = squeeze(LSmask3D(1,:,:));  mask(mask==0)=NaN;

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
%	cmap=mycolormap(mapanom,ncl);
	cmap(fix(ncl/2)+1,:)=[1 1 1]*1;colormap(cmap);
end

for ipl = 1 : 4
	switch ipl		
		case 1, C = squeeze(nansum(C1(iz,:,:))); lab='F';
		case 2, C = squeeze(nansum(C2(iz,:,:))); lab='A_{diff}';
		case 3, C = squeeze(nansum(C3(iz,:,:))); lab='A_{adv}';
		case 4, C = squeeze(nansum(C4(iz,:,:))); lab='Residual';
	end
	C(C==-9999)=NaN;
	cx='auto';
	cx=[-1 1]*0.03;
	x = lon2D_D(:,1);
	y = lat2D_D(1,:)';
	
	sb(ipl)=subplot(iw,jw,ipl); hold on
	m_pcolor(x,y,C);shading flat;
	caxis(cx);
	if ipl == 3	& 0
		[yy xx] = meshgrid(y,x);
		sg = -1;
		Cx = squeeze(nansum(sg*C3x(iz,:,:),1));
		Cy = squeeze(nansum(sg*C3y(iz,:,:),1));
		dx = 4; nx=length(x);
		dy = 4; ny=length(y);
		m_quiver(xx(1:dx:nx,1:dy:ny),yy(1:dx:nx,1:dy:ny),Cx(1:dy:ny,1:dx:nx)',Cy(1:dy:ny,1:dx:nx)',5,'color','k');
	elseif ipl == 3	& 0
		[yy xx] = meshgrid(lat,lon);
		Cx = squeeze(nansum(UVEL(im,1,:,:)));
		Cy = squeeze(nansum(VVEL(im,1,:,:)));
		dx = 4; nx=length(x);
		dy = 4; ny=length(y);
		m_quiver(xx(1:dy:ny,1:dx:nx),yy(1:dy:ny,1:dx:nx),Cx(1:dy:ny,1:dx:nx)',Cy(1:dy:ny,1:dx:nx)',5,'color','k');
	end
%	[cs,h]=m_contour(lon,lat,squeeze(THETA(3,1,:,:)).*mask,[16 19]);set(h,'edgecolor','g','linewidth',1);
%	[cs,h]=m_contour(lon,lat,squeeze(THETA(8,1,:,:)).*mask,[16 19]);set(h,'edgecolor','g','linewidth',1);
%	[cs,h]=m_contour(lon,lat,squeeze(MLD(3,:,:)).*mask,[300 300]);set(h,'edgecolor','k','linewidth',1);
%	l = m_line([1 1]*lon2D_D(find(lon2D_D>=lon(ixT(1)),1)),lat([1 end]));set(l,'color','k');
	m_coast('patch',[1 1 1]*.4);
	m_grid('xtick',[0:10:360],'ytick',[0:5:90]);
	title(sprintf('\\int_{%s}^{%s} %s dz (%3.3g Svy)',inte(1).val,inte(2).val,lab,nansum(nansum(C,2),1)),'fontweight','bold');	
	cl(ipl) = colorbar;
	m_text(132,47,sprintf('%s',ALPHABET(ipl)),'color','k','backgroundcolor','w','fontweight','bold','fontsize',12);
end

set(cl(1:3),'visible','off');
pos4=get(sb(4),'position');
pos=get(cl(4),'position'); set(cl(4),'position',[pos(1)+0.05 pos(2) 0.018 1-pos(2)*1.8]);
%set(cl(4),'fontsize',6);
set(sb(4),'position',pos4);
set(get(cl(4),'title'),'string','Sv.y/m^2');




