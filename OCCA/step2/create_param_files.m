%DEF Create fortran input parameter files
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

patho   = './param'; % This is where we print the param files
homedir = '/home/gmaze'; % This is what we replace as ~ into paths   

% Sub-domain boundaries:
%subdomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
%subdomain = [122 180 90 130 1 25]; % Western Pacific extended west
subdomain = [122 200 90 130 1 25]; % Western Pacific extended west and east
%subdomain = [110 260 90 147 1 25]; % Whole North Pacific

% Path definition:
tmp_path  = sprintf('~/data/OCCA/Tlayer_budget/KESS/r1/dom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d',subdomain);
lrf_path  = strcat(tmp_path,'/LRfiles');
time_path = '~/data/OCCA/Tlayer_budget/timeline';

% Fix paths:
tmp_path  = strrep(tmp_path,'~',strtrim(homedir));
lrf_path  = strrep(lrf_path,'~',strtrim(homedir));
time_path = strrep(time_path,'~',strtrim(homedir));


% A parameter file to use as input is as follow:
%1
%'~/data/OCCA/Tlayer_budget/timeline/TIMESERIE_Jan.bin'
%'~/data/OCCA/Tlayer_budget/KESS/TMP/'

% For each term into klist we need to create a param file with each time axis
% The nb of param files is thus length(klist)*length(tlist)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%klist = [1 3:16];
klist = [1 3:8];
%klist = 6;
% ' 1- LRvol.3yV2adv.bin '
% ' 2- LRtheta.3yV2adv.bin (NOT OK)'
% ' 3- LRadvTOT.3yV2adv.bin '
% ' 4- LRdiffTOT.3yV2adv.bin '
% ' 5- LRairsea3D.3yV2adv.bin '
% ' 6- LRtendNATIVE.3yV2adv.bin '
% ' 7- LRtendARTIF.3yV2adv.bin '
% ' 8- LRallotherTOT.3yV2adv.bin '
% ' 9- LRadvX.3yV2adv.bin '
% '10- LRadvY.3yV2adv.bin '
% '11- LRadvZ.3yV2adv.bin '
% '12- LRdifX.3yV2adv.bin '
% '13- LRdifY.3yV2adv.bin '
% '14- LRdifZ.3yV2adv.bin '
% '15- LRdifIZ.3yV2adv.bin '
% '16- LRghat.3yV2adv.bin '

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tlist = [1:15];
tlist = 1;
% 1 : Annual
% 2 : JFM
% 3 : JJA
% 4 : Jan
% 5 : Feb
% ...
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if patho exists;
if ~exist(patho,'dir')
	mkdir(patho);
end

% Do we clear the output params directory ?
s = input(sprintf('Do you want to clear the directory ([y]/n)?:\n%s\n',patho),'s');
if isempty(s) | lower(s)=='y' 	
	delete(sprintf('%s/*',patho));
end


for ik = 1 : length(klist)	
	k = klist(ik);
	
	for it = 1 : length(tlist)
		
		% 
		switch tlist(it)
			case 1, tim = 'YEAR';
			case 2, tim = 'JFM';
			case 3, tim = 'JJA';
			case 4, tim = 'Jan';
			case 5, tim = 'Feb';
			case 6, tim = 'Mar';
			case 7, tim = 'Apr';
			case 8, tim = 'May';
			case 9, tim = 'Jun';
			case 10, tim = 'Jul';
			case 11, tim = 'Aug';
			case 12, tim = 'Sep';
			case 13, tim = 'Oct';
			case 14, tim = 'Nov';
			case 15, tim = 'Dec';
			case 16, tim = '2003';
		end		
		
		% Create parameter file:
		fid = fopen(sprintf('%s/param_%2.2d_%s.p',patho,k,tim),'wt');
			
		% First line with term to integrate:
		fprintf(fid,'%i\n',k);
		
		% Second line with time axis:		
		fprintf(fid,'''%s/TIMESERIE_%s.bin''\n',time_path,tim);
		
		% Third line with the input files path:
		thispath = sprintf('%s/',lrf_path);
		fprintf(fid,'''%s''\n',thispath);
		
		% Fourth line with output dir:
		thispath = sprintf('%s/TMP_%s/',tmp_path,tim);
		% Ensure the directory exist:
		if ~exist(thispath,'dir')
			mkdir(tmp_path,sprintf('TMP_%s',tim));
		end
		fprintf(fid,'''%s''\n',thispath);

		fclose(fid);
		
	end %for it
end	
	
	






















