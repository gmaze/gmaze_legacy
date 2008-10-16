


dS = subfct_getdS(lat,lon);
bin = 0.25;

for im = 1 : 12
	C = squeeze(SST(im,:,:)).*squeeze(mask_KESS(1,:,:));
	
	mask = zeros(nlat,nlon); mask(C>=THETAlow & C<=THETAhig) = 1;	
	su(1,im)=nansum(nansum(mask.*dS));
	
	mask = zeros(nlat,nlon); mask(C>=THETAlow-bin/2 & C<=THETAlow+bin/2) = 1;
	su(2,im)=nansum(nansum(mask.*dS));
	
	mask = zeros(nlat,nlon); mask(C>=THETAhig-bin/2 & C<=THETAhig+bin/2) = 1;
	su(3,im)=nansum(nansum(mask.*dS));
end



figure
axm = datenum(1900,1:12,15,0,0,0);
plot(circshift(axm,[2 3]),circshift(su,[2 3])');
legend('Total layer outcrop','Lower isotherm binned','Higher isotherm binned');
datetick('x','mmm');
grid on;
ylabel('Surface (m^2)');
xlabel('Month');

