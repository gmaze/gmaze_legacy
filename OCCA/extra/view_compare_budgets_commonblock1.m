
C(C==0) = NaN;
C5na = squeeze(nansum(C5a(:,:,ix),3)); C5na = C5na./abs(xtrm(C5na));
C5nb = squeeze(nansum(C5b(:,:,ix),3)); C5nb = C5nb./abs(xtrm(C5nb));
C5nc = squeeze(nansum(C5c(:,:,ix),3)); C5nc = C5nc./abs(xtrm(C5nc));

sb(ip)=subplot(iw,jw,plist(ipl)); hold on
pcolor(y,z,C);shading flat;
caxis(cx);
set(gca,'ydir','reverse');
set(gca,'xlim',[10 43]);
l = line(lat,nanmean(squeeze(nanmean(MLD([1:3],:,:),1)).*squeeze(mask_KESS(1,:,:)),2)); set(l,'color','k','linewidth',1);
%l = line(y,squeeze(nanmean(MLDjfm(:,ix),2))); set(l,'color','k','linewidth',1);	
%[cs,h]=contour(y,z,C5na,[1 1]*1e-2);set(h,'edgecolor','k');
[cs,h]=contour(y,z,C5nb,[1 1]*1e-2);set(h,'edgecolor','b');
[cs,h]=contour(y,z,C5nc,[1 1]*1e-2);set(h,'edgecolor','r');

if 0
	[cs,h]=contour(y,z,squeeze(nanmean(maskSF(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
	[cs,h]=contour(y,z,squeeze(nanmean(maskML(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
	[cs,h]=contour(y,z,squeeze(nanmean(maskDW(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
	[cs,h]=contour(y,z,squeeze(nanmean(maskUP(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
end

%		title(sprintf('\\int %s dx (%3.2g Svy)',lab,nansum(C(:))),'fontweight','bold');	
%		title(ALPHABET(ip),'fontweight','bold');
title(sprintf('%s: %s',runl(irun).val,lab),'fontweight','bold');

tt(ip)=text(11,580,sprintf('%3.2g Svy',nansum(C(:))));

axis([10 43 0 600]);box on;
daspect([22 500 1])
xlabel('Latitude','fontsize',7);
ylabel('Depth (m)','fontsize',7);
set(gca,'fontsize',7);

for iiy = 0:5:60
	line([1 1]*iiy,get(gca,'ylim'),'color','k','linestyle',':');
end
for iix = 600 : -50 : 0
	line(get(gca,'xlim'),[1 1]*iix,'color','k','linestyle',':');
end	
line([get(gca,'xlim') fliplr(get(gca,'xlim')) min(get(gca,'xlim'))],...
	[min(get(gca,'ylim')) get(gca,'ylim') fliplr(get(gca,'ylim'))],'color','k');

cl(ip) = thincolorbar;		
set(cl(ip),'fontsize',7);
set(cl(ip),'ytick',[cx(1)+diff(cx)/ncl/2:diff(cx)/ncl:cx(2)-diff(cx)/ncl/2])
set(cl(ip),'yticklabel',fix([cx(1)+diff(cx)/ncl/2:diff(cx)/ncl:cx(2)-diff(cx)/ncl/2]*1e3*10)/10)
set(get(cl(ip),'title'),'string','10^{-3} Sv.y','fontsize',7);




