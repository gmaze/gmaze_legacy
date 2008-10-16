%DEF
%REQ
%
% Created by Guillaume Maze on 2008-10-02.
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

% Monthly climato video



figure; 
iw=2;jw=2;
mo = datestr(datenum(1900,1:12,1,0,0,0),'mmmm');

%%%%%%%%%%%%%%%%%%%%% LOOPS OVER RUNS
for irun = 1 : nrun
	clf; footnote;
	ip = 0;	
	view_compare_budgets_commonblock0
	cmap(fix(ncl/2)+1,:)=[1 1 1]*1;colormap(mapanom);
	set(gcf,'color','w');
	
	sg = -1;
	C1 = sg*eval(strcat(runl(irun).val,'_Mq'));
	C2 = sg*(eval(strcat(runl(irun).val,'_Mdiff'))+eval(strcat(runl(irun).val,'_MtendA'))+eval(strcat(runl(irun).val,'_Mall')));
	C3 = sg*(eval(strcat(runl(irun).val,'_Madv')));
	C4 = sg*eval(strcat(runl(irun).val,'_MtendN'))-(C1+C2+C3);	
	C5a = eval(strcat(runl(irun).val,'_Mvol'));
	
	mask = maskUP+maskDW;
	C1 = C1.*mask;
	C2 = C2.*mask;
	C3 = C3.*mask;
	C4 = C4.*mask;

	for ipl = 1 : 4
		ip = ip + 1;
		switch ipl		
			case 1, C = squeeze(nansum(C1(:,:,ix),3)); lab='F';
			case 2, C = squeeze(nansum(C2(:,:,ix),3)); lab='A_{diff}';
			case 3, C = squeeze(nansum(C3(:,:,ix),3)); lab='A_{adv}';	
			case 4, C = squeeze(nansum(C4(:,:,ix),3)); lab='Residual';
		end
		C(C==-9999)=NaN;
		cx=[-1 1]*0.013;
%		cx=[-1 1]*1.3*1e-3;
		plist = [1:4];
		

		C(C==0) = NaN;
		C5na = squeeze(nansum(C5a(:,:,ix),3)); C5na = C5na./abs(xtrm(C5na));

		sb(ip)=subplot(iw,jw,plist(ipl)); hold on
		pcolor(y,z,C);shading flat;
		caxis(cx);
		set(gca,'ydir','reverse');
		set(gca,'xlim',[10 45]);
		l = line(lat,nanmean(squeeze(nanmean(MLD(irun,:,:),1)).*squeeze(mask_KESS(1,:,:)),2)); set(l,'color','k','linewidth',1);
		%l = line(y,squeeze(nanmean(MLDjfm(:,ix),2))); set(l,'color','k','linewidth',1);	
		[cs,h]=contour(y,z,C5na,[1 1]*1e-2);set(h,'edgecolor','r');

		if 0
			[cs,h]=contour(y,z,squeeze(nanmean(maskSF(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
			[cs,h]=contour(y,z,squeeze(nanmean(maskML(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
			[cs,h]=contour(y,z,squeeze(nanmean(maskDW(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
			[cs,h]=contour(y,z,squeeze(nanmean(maskUP(:,:,ix),3)),[1 1]*.9);set(h,'color','k');
		end

		title(sprintf('%s',lab),'fontweight','bold');

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

		
	end %for ipl
	set(tt,'verticalalignment','bottom','horizontalalignment','left','fontweight','bold')
	
	
	videotimeline(mo,irun,'t');
	drawnow;
	Vid(irun) = getframe(gcf);
		
	
end %for irun




















