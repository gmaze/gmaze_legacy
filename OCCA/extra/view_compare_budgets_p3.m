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

labF = 'details_diffusion';

figure;     figure_tall;
iw=5;jw=nrun;

view_compare_budgets_commonblock0


ip = 0;
%%%%%%%%%%%%%%%%%%%%% LOOPS OVER RUNS
for irun = 1 : nrun
	
	sg = -1;
	C1 = sg*eval(strcat(runl(irun).val,'_Mdiff'));
	C2 = sg*(eval(strcat(runl(irun).val,'_Mdiffx')));
	C3 = sg*(eval(strcat(runl(irun).val,'_Mdiffy')));
	C4a = sg*(eval(strcat(runl(irun).val,'_Mdiffz')));
	C4b = sg*(eval(strcat(runl(irun).val,'_Mdiffiz')));
	C5a = eval(strcat(runl(1).val,'_Mvol'));
	C5b = eval(strcat(runl(2).val,'_Mvol'));
	
	mask = maskUP+maskDW;
	%mask = maskUP;

	C1 = C1.*mask;
	C2 = C2.*mask;
	C3 = C3.*mask;
	C4a = C4a.*mask;
	C4b = C4b.*mask;

	plist = [1:jw:jw*iw]+irun-1;
	for ipl = 1 : iw
		ip = ip + 1;
		switch ipl		
			case 1, C = squeeze(nansum(C1(:,:,ix),3)); lab='A_{diff}';     cx = [-1 1]*1.3*1e-2;
			case 2, C = squeeze(nansum(C2(:,:,ix),3)); lab='A_{diff} x';   cx = [-1 1]*1.3*1e-3;
			case 3, C = squeeze(nansum(C3(:,:,ix),3)); lab='A_{diff} y';   cx = [-1 1]*1.3*1e-3;
			case 4, C = squeeze(nansum(C4a(:,:,ix),3)); lab='A_{diff} E z';cx = [-1 1]*1.3*1e-2;
			case 5, C = squeeze(nansum(C4b(:,:,ix),3)); lab='A_{diff} I z';cx = [-1 1]*1.3*1e-2;
		end
		C(C==-9999)=NaN;
		
		view_compare_budgets_commonblock1
		
		set(get(gca,'xlabel'),'visible','off')
		
		
	end %for ipl
end %for irun

set(tt,'verticalalignment','bottom','horizontalalignment','left','fontweight','bold')

if prtimg,
	print(gcf,'-depsc2',strcat('img/',FIGlabel,'_',labF,'.eps'));
end










