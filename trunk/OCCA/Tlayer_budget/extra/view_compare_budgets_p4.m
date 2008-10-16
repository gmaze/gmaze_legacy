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

labF = 'details_allother';

figure;     figure_tall;
iw=4;jw=nrun;

view_compare_budgets_commonblock0

ip = 0;
%%%%%%%%%%%%%%%%%%%%% LOOPS OVER RUNS
for irun = 1 : nrun
	
	sg = -1;
	C1 = sg*eval(strcat(runl(irun).val,'_Mall')); % All other terms
	C2 = sg*(eval(strcat(runl(irun).val,'_Mghat'))); % KPP non local
	C3 = sg*(eval(strcat(runl(irun).val,'_Mall')))-C2; % dSSH + GTABT
	C4 = sg*(eval(strcat(runl(irun).val,'_MtendA'))); % Tend artificial
	
	mask = maskUP+maskDW;
	%mask = maskUP;

	C1 = C1.*mask;
	C2 = C2.*mask;
	C3 = C3.*mask;
	C4 = C4.*mask;

	plist = [1:jw:jw*iw]+irun-1;
	for ipl = 1 : iw
		ip = ip + 1;
		switch ipl		
			case 1, C = squeeze(nansum(C1(:,:,ix),3)); lab='All other terms';     cx = [-1 1]*1.3*1e-2;
			case 2, C = squeeze(nansum(C2(:,:,ix),3)); lab='KPP Non local';   cx = [-1 1]*1.3*1e-2;
			case 3, C = squeeze(nansum(C3(:,:,ix),3)); lab='dSSH + GTABT';   cx = [-1 1]*1.3*1e-2;
			case 4, C = squeeze(nansum(C4(:,:,ix),3)); lab='Artif. Tend.';         cx = [-1 1]*1.3*1e-2;
		end
		C(C==-9999)=NaN;
		
		view_compare_budgets_commonblock1
		
	end %for ipl
end %for irun


set(tt,'verticalalignment','bottom','horizontalalignment','left','fontweight','bold')

if prtimg,
	print(gcf,'-depsc2',strcat('img/',FIGlabel,'_',labF,'.eps'));
end
	













