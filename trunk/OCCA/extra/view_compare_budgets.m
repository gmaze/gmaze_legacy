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
clear
pv_checkpath

prtimg = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% load grid:
grid_path = '~/data/OCCA/grid/';

% Check the fortran routine for these param:

% KESS:
jpiO = 360; jpjO = 160; jpkO = 50;
jpi  = 51; jpj = 46; jpk = 25; nb_in = 12; nbIn2Out = 3; nb_out = nb_in/nbIn2Out;
ind_x = [130 180];
ind_y = [90 135]; 
ind_z = [1 25];
check_grid;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load fields:
disp('Load results ...');
patho    = '~/data/OCCA/Tlayer_budget/';
%dirtofil = abspath(strcat(patho,dirtofil));
iter0 = 1;
iter1 = 1099;
THETAlow = 16;
THETAhig = 19;

%wrun = [1 2]; FIGlabel = 'ANNUAL_vs_JFM';
%wrun = [1 2 3]; FIGlabel = 'ANNUAL_vs_JFM_vs_JJA';
%wrun = [1 4 5 6]; FIGlabel = 'ANNUAL_vs_1_to_3';
%wrun = [4:15]; FIGlabel = 'Jan_to_Dec';
wrun = [1 16]; FIGlabel = 'devel';

nrun = length(wrun);
for irun = 1 : nrun
	run = wrun(irun);
	switch run
		case 1,	RUNlabel = 'YEAR';
		case 2,	RUNlabel = 'JFM';
		case 3,	RUNlabel = 'JJA';
		case 4,	RUNlabel = 'jan';
		case 5,	RUNlabel = 'feb';
		case 6,	RUNlabel = 'mar';
		case 7,	RUNlabel = 'apr';
		case 8,	RUNlabel = 'may';
		case 9,	RUNlabel = 'jun';
		case 10,	RUNlabel = 'jul';
		case 11,	RUNlabel = 'aug';
		case 12,	RUNlabel = 'sep';
		case 13,	RUNlabel = 'oct';
		case 14,	RUNlabel = 'nov';
		case 15,	RUNlabel = 'dec';
		case 16,	RUNlabel = 'devel';
	end		
	load(strcat('results_',RUNlabel,'.mat'));
	w = whos('M*');	for iw = 1 : size(w,1),	assignin('caller',strcat(RUNlabel,'_',w(iw).name),eval(w(iw).name)); end, clear M*
	w = whos('V*');	for iw = 1 : size(w,1),	assignin('caller',strcat(RUNlabel,'_',w(iw).name),eval(w(iw).name)); end, clear V*
	runl(irun).val = RUNlabel;
	clear timeline
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
mydomain=[1 25 90 135 130 180];
C = MLDjfm;
C = C(mydomain(3):mydomain(4),mydomain(5):mydomain(6));
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
C = C(mydomain(3):mydomain(4),mydomain(5):mydomain(6));
% Move it to the MR grid:
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























