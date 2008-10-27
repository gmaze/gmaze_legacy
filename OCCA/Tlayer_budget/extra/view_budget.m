%DEF Load and plot a volume budget of a thermal layer computed with interpBudgetallinonceS.F90
%
%
% Created by Guillaume Maze on 2008-09-30.
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
clear
pv_checkpath

prtimg = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% load grid:
grid_path = '~/data/OCCA/grid/';


irun = 0;
switch irun
	case 0
		RUNlabel = 'devel';
		dirtofil = 'devel/new2/TMP_2003/'; 
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_2003.bin','r','b'),[1 1099],'integer*4');fclose('all');
%		dirtofil = 'TMP_YEAR/';  mydomain = [122 180 90 130 1 25]; % Western Pacific
%		dirtofil = 'TMP_YEAR/';  mydomain = [122 200 90 130 1 25]; % Western Pacific		
%		dirtofil = 'wholeNP/TMP_YEAR/';  mydomain = [110 260 90 147 1 25]; % Whole North Pacific
		dirtofil = 'TMP_YEAR/';  mydomain = [150 180 100 120 1 25]; % A box in the middle of the ocean				
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_YEAR.bin','r','b'),[1 1099],'integer*4');fclose('all');
	case 1
		dirtofil = '130/bdgYEAR/'; mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_YEAR.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'YEAR';
	case 2
		dirtofil = 'bdgJFM/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_JFM.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'JFM';
	case 3
		dirtofil = 'bdgJJA/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_JJA.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'JJA';
	case 4
		dirtofil = 'TMP_Jan/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Jan.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'jan';
	case 5
		dirtofil = 'TMP_Feb/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Feb.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'feb';		
	case 6
		dirtofil = 'TMP_Mar/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Mar.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'mar';	
	case 7
		dirtofil = 'TMP_Apr/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Apr.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'apr';	
	case 8
		dirtofil = 'TMP_May/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_May.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'may';
	case 9
		dirtofil = 'TMP_Jun/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Jun.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'jun';
	case 10
		dirtofil = 'TMP_Jul/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Jul.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'jul';
	case 11
		dirtofil = 'TMP_Aug/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Aug.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'aug';
	case 12
		dirtofil = 'TMP_Sep/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Sep.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'sep';
	case 13
		dirtofil = 'TMP_Oct/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Oct.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'oct';
	case 14
		dirtofil = 'TMP_Nov/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Nov.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'nov';
	case 15
		dirtofil = 'TMP_Dec/';mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
		timeline = fread(fopen('~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Dec.bin','r','b'),[1 1099],'integer*4');fclose('all');
		RUNlabel = 'dec';
end
%release = 'r0'; % First version
release = 'r1'; % New advection scheme (less diffusive)
dirtofil = abspath(sprintf('KESS/%s/dom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d/%s',release,mydomain,dirtofil));
%dirtofil = strcat('KESS/',release,'/',dirtofil);

% global domain:
jpiO = 360; jpjO = 160; jpkO = 50;
jpi = diff(mydomain(1:2))+1;
jpj = diff(mydomain(3:4))+1;
jpk = diff(mydomain(5:6))+1;
nb_in = 12; nbIn2Out = 3; nb_out = nb_in/nbIn2Out;
nb_in = 4;  nbIn2Out = 2; nb_out = nb_in/nbIn2Out;
ind_x = mydomain(1:2); 
ind_y = mydomain(3:4); 
ind_z = mydomain(5:6); 
run('check_grid');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load fields:
disp('Load results ...');
disp(RUNlabel)
patho    = '~/data/OCCA/Tlayer_budget/';
dirtofil = abspath(strcat(patho,dirtofil));
iter0 = 1;
iter1 = 1099;
THETAlow = 16;
THETAhig = 19;

run('load_budget_timeseries');
run('load_budget_maps');

if 1
	disp('Save results ...')
	save this_results.mat M* V* x y z t timeline
	system(sprintf('\\mv this_results.mat results_%s.mat',RUNlabel));
end

disp('Done');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Load climato:
if 1
	
run('load_climato');

load LSmask_KESS_OCCA.mat; mask_KESS(mask_KESS==0)=NaN;
for im = 1 : length(wm)
%	THETA(im,:,:,:) = squeeze(THETA(im,:,:,:)).*mask_KESS;
	MLD(im,:,:) = squeeze(MLD(im,:,:)).*squeeze(mask_KESS(1,:,:));
	ETA(im,:,:) = squeeze(ETA(im,:,:)).*squeeze(mask_KESS(1,:,:));
end

MLDjfm = squeeze(nanmean(MLD([1:3],:,:),1));
%mydomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
mydomain2 = mydomain([5 6 3 4 1 2]);
C = MLDjfm;
C = C(mydomain2(3):mydomain2(4),mydomain2(5):mydomain2(6));
% Move it to the MR grid:
C2 = zeros(jpj*nb_out,jpi*nb_out);
for icur = 1 : nb_out
	for jcur = 1 : nb_out
		C2(jcur:nb_out:jpj*nb_out,icur:nb_out:jpi*nb_out) = C;
	end
end
MLDjfm = C2;

clear C2 C3
for im = 1 : 12
C = squeeze(ETA(im,:,:));
C = C(mydomain2(3):mydomain2(4),mydomain2(5):mydomain2(6));

C2 = zeros(jpj*nb_out,jpi*nb_out);
for icur = 1 : nb_out
	for jcur = 1 : nb_out
		C2(jcur:nb_out:jpj*nb_out,icur:nb_out:jpi*nb_out) = C;
	end
end
C3(im,:,:) = C2;
end %for im
ETAmr = C3; clear C2

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Load volume fluxes at boundaries
load('../../global/diag_pl58.1d.global.MOAdnov.mat');
ip = 1;
c1 = nansum(nansum(pl58_UfluxW_sec(ip,:,:,:),3),4)'-nansum(nansum(pl58_UfluxE_sec(ip,:,:,:),3),4)';
c2 = nansum(nansum(pl58_VfluxS_sec(ip,:,:,:),3),4)';
c1 = c1./1e6*pl58_Rfact_dw^2; c2 = c2./1e6*pl58_Rfact_dw^2;
Vbdn = zeros(1,nt).*NaN; Vbdn(1:length(c1)) = c1+c2;
Vbdn = myrunmean(Vbdn,30,0,2);
clear *pl58* c1 c2



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE A TYPICAL YEAR
tY = datenum(0,12,1,0,0,0):datenum(0,12,1,0,0,0)+364;
pivot = find(str2num(datestr(tY,'mmdd'))==str2num(datestr(t(1),'mmdd')));

ii=0; clear dC
ii=ii+1;dC(ii,:) = diff(Vvol);
ii=ii+1;dC(ii,:) = diff(VtendN);
ii=ii+1;dC(ii,:) = diff(Vadv);
ii=ii+1;dC(ii,:) = diff(Vdiff);
ii=ii+1;dC(ii,:) = diff(Vq);
ii=ii+1;dC(ii,:) = diff(Vall);
ii=ii+1;dC(ii,:) = diff(VtendA);
ii=ii+1;dC(ii,:) = diff(Vadvx);
ii=ii+1;dC(ii,:) = diff(Vadvy);
ii=ii+1;dC(ii,:) = diff(Vadvz);
ii=ii+1;dC(ii,:) = diff(Vbdn);

ii=0; clear t2
ii=ii+1;t2(ii,:) =       1:  365;
ii=ii+1;t2(ii,:) =   365+1:2*365;
ii=ii+1;t2(ii,:) = 2*365+1:3*365;

clear a,for iy = 1 : size(t2,1)
	a(:,iy,:) = dC(:,t2(iy,:));
end, dC = a; clear a

% Mean over 2004-2006
clear dCm,dCm = squeeze(nanmean(dC,2));

% Standard deviation over the 3 samples:
clear dCs
for iy = 1 : size(t2,1)
	for ii = 1 : size(dC,1)	
		a = squeeze(dC(ii,iy,:));
		a = circshift(a,pivot);
		dCs(ii,iy,:) = cumsum(a);
	end
end
Cs = squeeze(nanstd(dCs,1,2));

% Mean of the cumsum:
clear Cm
for ii = 1 : size(dC,1)
	Cm(ii,:) = cumsum(circshift(dCm(ii,:),[0 pivot]));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FIGURES:




