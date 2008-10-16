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

mo = datestr(datenum(1900,1:12,1,0,0,0),'mmmm');
mask = mask_KESS;mask(isnan(mask)) = 0;

mask1 = LSmask3D;
mask1(isnan(mask1)) = 0;
mask2 = zeros(ndpt,nlat,nlon); mask2(ind_z(1):ind_z(2),ind_y(1):ind_y(2),ind_x(1):ind_x(2)) = 1;
mask  = zeros(ndpt,nlat,nlon);
mask(mask1==1 & mask2==1)=1; clear mask1 mask2

%mask = LSmask3D;mask(isnan(mask)) = 0;


load mapanom2
iw=2;jw=2;
figure; figure_land;

for irun = 1 : nrun
	if irun == 1, figure;figure_land;
	else,figure_land;clf;footnote;hold on;end
	
	sg = -1;
	C1 = sg*eval(strcat(runl(irun).val,'_Mq'));
	C2 = sg*(eval(strcat(runl(irun).val,'_Mdiff'))+eval(strcat(runl(irun).val,'_MtendA'))+eval(strcat(runl(irun).val,'_Mall')));
	C3 = sg*(eval(strcat(runl(irun).val,'_Madv')));
	C4 = sg*eval(strcat(runl(irun).val,'_MtendN'))-(C1+C2+C3);	
	C5a = eval(strcat(runl(irun).val,'_Mvol'));
	
	for ipl = 1 : 4
		switch ipl		
			case 1, C = C1; lab='F';
			case 2, C = C2; lab='A_{diff}';
			case 3, C = C3; lab='A_{adv}';	
			case 4, C = C4; lab='Residual';
		end
		[xx yy zz] = meshgrid(x,y,z);
		%C = permute(C5a,[2 3 1]);
		%cm = max(max(max(C)));
		%[ix iy iz] = find(C==cm,1);

		C = permute(C,[2 3 1]);
		C(C==0) = NaN;
		%C(abs(C)<1e-6)=NaN;

		subplot(iw,jw,ipl); hold on
		slice(xx,yy,-zz,C,x(2:nx/6:nx),0,-z(1));
		shading flat;

		iz=-z(1); contour3(lon,lat,squeeze(mask(find(dpt<iz,1),:,:))*iz,[1 1]*iz,'w')
		iz=-600; contour3(lon,lat,squeeze(mask(find(dpt<iz,1),:,:))*iz,[1 1]*iz,'w')
		if 0,for iz=0:-50:-600
			contour3(lon,lat,squeeze(mask(find(dpt<iz,1),:,:))*iz,[1 1]*iz,'w')
		end,end

		if 0
			c = squeeze(mask_KESS(1,:,:)); c(isnan(c))=0; c=1-c;c=abs(c);
			for iy = ind_y(1) : ind_y(2)
				ix = find(c(iy,ind_x(1):ind_x(2))==0,1,'first');
				if ~isempty(ix)
					line(lon([ix ix]+ind_x(1)),lat([iy iy]),[-600 0]);
				end
			end
		end

		axis([120 180 10 50 -600 0])
		grid on, box on
		xlabel('Longitude');
		ylabel('Latitude');
		zlabel('Depth');
		set(gca,'color','none')
		set(gcf,'color',[1 1 1]*.5)
		%view(-125,15)
		%view(-70,10)
		view(20,20);
		%view(3)
		axis off
		daspect([1 1 30])
		caxis([-1 1]*1.3*1e-4); colormap(logcolormap(256,1,1,mapanom))
		title(lab);
		
	end %for ipl

	videotimeline(mo,irun,'t');
	drawnow;
	Vid(irun) = getframe(gcf);

end %for irun

break



[xx2 yy2 zz2] = meshgrid(lon,lat,dpt);

im=11; C = squeeze(THETA(im,:,:,:));
C = C.*mask_KESS;
C(C==0) = NaN;
C = permute(C,[2 3 1]);
p = patch(isosurface(xx2,yy2,zz2,C,15));
isonormals(xx2,yy2,zz2,C,p);
set(p, 'FaceColor', 'blue', 'EdgeColor', 'none');
%daspect([1 1 1])
view(3)
camlight; lighting phong
set(gca,'color','none')
box on





























