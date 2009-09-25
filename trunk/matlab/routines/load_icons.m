% load_icons Load CDdata of an predefined icon
%
% CDdata = load_icons(IICON)
% 
% Load CDdata of an predefined icon
% 
% 1  Random
% 2  Google lab with white background
% 3  DEATH
% 4  Same as Google mail
% 5  Another mail icon (blue)
% 6: Green doc
% 7: Rocks logo for SGE
%
%
% Created: 2008-11-20.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function CDdata = load_icons(iicon)

here = which('load_icons');
here = strrep(here,'load_icons.m','');
sla  = here(1);
pathtoicons = strcat(here,sla,'icons',sla,'mat',sla);



switch iicon
	case 1 % Random
		a = [.20:.05:0.95];
		img1(:,:,1) = repmat(a,16,1)';
		img1(:,:,2) = repmat(a,16,1);
		img1(:,:,3) = repmat(flipdim(a,2),16,1);
		CDdata = img1;
		
	case 2 % Google lab with white background
		icoI   = load(strcat(pathtoicons,'labtool_icon.mat'));
		c = icoI.ico; 
		%c = c(2:end-1,3:end-2);
		c2 = ones(16,16).*255;
		c([1 end],:) = c2([1 end],:);
		c(:,[1 end]) = c2(:,[1 end]);
		CDdata = ind2rgb(c,icoI.cmap);
		if 1
		bgcolor = get(gcf,'color');
		bgcolor = [179 179 179]/255;
		for ix=1:size(CDdata,1)
			for iy=1:size(CDdata,2)
				if squeeze(CDdata(ix,iy,:)) == [1 1 1]'
					CDdata(ix,iy,:) = bgcolor;
				end
			end
		end
		end
		
	case 3 % DEATH
		icoI   = load(strcat(pathtoicons,'death_icon.mat'));
		c = icoI.ico;
		CDdata = ind2rgb(c,icoI.cmap);
		
	case 4 % Same as Google mail
		icoI   = load(strcat(pathtoicons,'mailtool_icon3.mat'));
		c = icoI.ico;
		c= c(4:14,:);
		CDdata = ind2rgb(c,icoI.cmap);
		
	case 5 % Another mail icon (blue)
		icoI   = load(strcat(pathtoicons,'mailtool_icon2.mat'));
		c = icoI.ico;
		c= c(6:16,1:16); c(c==5) = 4;
		CDdata = ind2rgb(c,icoI.cmap);	
				
	case 6 % Green Doc
		icoI   = load(strcat(pathtoicons,'green_doc.mat'));
		c = icoI.ico;
		CDdata = ind2rgb(c,icoI.cmap);
	
	case 7 % Rocks logo for SGE
		icoI   = load(strcat(pathtoicons,'sge.mat'));
		c = icoI.ico;
		CDdata = ind2rgb(c,icoI.cmap);

end



end %function




