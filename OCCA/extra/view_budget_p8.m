% Volume flux


maskNPW = zeros(ndpt,nlat,nlon);
maskNPW(squeeze(nanmean(THETA(1:3,:,:,:))) >=16 & squeeze(nanmean(THETA(1:3,:,:,:))) <=19) = 1;
[a b c] = meshgrid(lat,lon,abs(diff(dpt))); ddpt = permute(c,[3 2 1]); clear a b c
ddpt = ddpt(1:end-1,:,:)/2 + ddpt(2:end,:,:)/2;
ddpt = cat(1,7.5*ones(1,nlat,nlon),ddpt);
ddpt = cat(1,ddpt,NaN*ones(1,nlat,nlon));

for iz = 1 : ndpt
	su(iz,:,:) = e2t'.*squeeze(ddpt(iz,:,:));
	sv(iz,:,:) = e1t'.*squeeze(ddpt(iz,:,:));
end

figure;figure_tall;
%ax = ptable([2 2],[1 2;3 3;4 4]);
%ax = ptable([2 2],[1 3;2 2;4 4]);
ax = ptable([3 2],[1 2;3 3;4 4;5 6]);


axes(ax(1)); hold on
	m_proj('mercator','lon',[128 182],'lat',[8 40]);
	Cx = squeeze(nansum(squeeze(nanmean(UVEL(1:12,:,:,:))).*maskNPW.*ddpt.*mask_KESS,1)./nansum(maskNPW.*ddpt,1));
	Cy = squeeze(nansum(squeeze(nanmean(VVEL(1:12,:,:,:))).*maskNPW.*ddpt.*mask_KESS,1)./nansum(maskNPW.*ddpt,1));
	[yy xx] = meshgrid(lat,lon);
%	m_quiver(xx,yy,Cx',Cy',20);	
	dx = 1 : 2 : nlon; dy = 1 : 2 : nlat;
	m_vec(.75,xx(dx,dy),yy(dx,dy),Cx(dy,dx)',Cy(dy,dx)','headangle',20,'headlength',4,'shaftwidth',0.08);
	[cs,h]=m_contour(lon,lat,squeeze(nanmean(ETA(1:12,:,:))),[-2:.1:2],'k');set(h,'color',[1 1 1]*.5,'linewidth',1);	
	m_coast('patch',[1 1 1]*.4);
	m_grid('xtick',[0:10:360],'ytick',[0:5:90],'fontsize',7);
	title(sprintf('Thermal layer vertical integral of the velocity field (annual mean)\n(mean SSH in gray)'));

for im = 1 : 12
	Cx = squeeze(UVEL(im,:,:,:)).*maskNPW.*mask_KESS.*su;
	Cy = squeeze(VVEL(im,:,:,:)).*maskNPW.*mask_KESS.*sv;

	axes(ax(2)); hold on
	c1u(im,:) = squeeze(nansum(Cx(:,:,[ind_x(1)+1]),1))./1e6;
	c2u(im,:) = -squeeze(nansum(Cx(:,:,[ind_x(2)]),1))./1e6;
	vfu(im) = nansum(c1u(im,:)+c2u(im,:));
	
	cc = squeeze(nansum(Cx(:,:,[ind_x(1)+1]),1))./1e6;
	WBCt(im,1) = nansum(cc(cc>0));
	cc = -squeeze(nansum(Cx(:,:,[ind_x(2)]),1))./1e6;
	WBCt(im,2) = nansum(cc(cc>0));
	
	p(1)=plot(lat,c1u(im,:),'r');
	p(2)=plot(lat,c2u(im,:),'k');
	axis([0 45 [-1 1]*2]);	grid on, box on
	l=legend(p,sprintf('West (%2.2gSv)',nanmean(nansum(c1u(im,:),2))),sprintf('East (%2.2gSv)',nanmean(nansum(c2u(im,:),2))),4);
	set(l,'fontsize',7);
	xlabel('Latitude');ylabel('Sv');
	title(sprintf('Zonal volume flux into the layer (Net=%2.2gSv)',nanmean(vfu)));
	set(gca,'fontsize',7);
	
	axes(ax(3)); hold on
	c1v(im,:) = squeeze(nansum(Cy(:,[ind_y(1)+1],:),1))./1e6;
	c2v(im,:) = -squeeze(nansum(Cy(:,[ind_y(2)],:),1))./1e6;
	vfv(im) = nansum(c1v(im,:)+c2v(im,:));
	
	p(1)=plot(lon,c1v(im,:),'r');
	p(2)=plot(lon,c2v(im,:),'k');
	axis([125 185 [-1 1]*.1]);	grid on, box on
	l=legend(p,sprintf('South (%2.2gSv)',nanmean(nansum(c1v(im,:),2))),sprintf('North (%2.2gSv)',nanmean(nansum(c2v(im,:),2))));
	set(l,'fontsize',7);
	xlabel('Longitude');ylabel('Sv');
	title(sprintf('Meridional volume flux into the layer (Net=%2.2gSv)',nanmean(vfv)));
	set(gca,'fontsize',7);

end % for im


axes(ax(4)); hold on
axm = datenum(1900,1:12,15,0,0,0);
pp=plot(axm,vfu,axm,vfv,axm,vfu+vfv);
set(pp(1),'color','k');
set(pp(2),'color','b');
set(pp(3),'color','r');
datetick('x');set(gca,'ylim',[-5 4]);grid on, box on;set(gca,'ytick',[-5:1:4]);
legend('Zonal','Meridional','Total','fontsize',7);
xlabel('Time');ylabel('Sv');
title('Monthly time series of boundary volume fluxes');
set(gca,'fontsize',7);





