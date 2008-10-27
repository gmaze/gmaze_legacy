%DEF Create scripts to launch the fortran routine into a queue
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

patho           = './scripts'; % This is where we print the queue files
prog_to_compile = 'interpBudgetallinonceS.F90'; % This is the fortran code to compute the budget terms
prog_to_run     = 'intBdgS_ifort'; % This is compiled name of the code
workdir         = '/home/gmaze/work/Postdoc/work/coare/Tlayer_budget/step2/'; % This is the root dir

%klist = [1 3:16];
klist = [1 3:8];
%klist = [1 7 6 8];
klist = [1 8];

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

tlist = 1;
%tlist = [4:6];
%tlist = [7:9];
%tlist = [10:12];
%tlist = [13:15];
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

% Do we clear the output scripts directory ?
s = input(sprintf('Do you want to clear the directory ?:\n%s\n[y]/n: ',patho),'s');
if isempty(s) | lower(s)=='y' 
	delete(sprintf('%s/*',patho));	
end

% Create individual run scripts:
for ik = 1 : length(klist)
	
	k = klist(ik);
	for it = 1 : length(tlist)
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
		param_file = sprintf('param_%2.2d_%s.p',k,tim);
		
	fid = fopen(sprintf('%s/Bdg_%2.2d_%s.sh',patho,k,tim),'wt');

	fprintf(fid,'#!/bin/csh\n');
	fprintf(fid,'#\n');
	fprintf(fid,'#  Created by Guillaume Maze on %s.\n',datestr(now,'yyyy-mm-dd'));
	fprintf(fid,'#  Copyright (c) 2008 Guillaume Maze.\n');	
	fprintf(fid,'#  Generated automatically by: create_launch_scripts.m\n');
	fprintf(fid,'#\n');
	fprintf(fid,'set workdir=''%s''\n',workdir);
	fprintf(fid,'%s\n','set dat=`date +%Y%m%d_%HH%M%S_%N`');
	fprintf(fid,'set hostdir=$JOB_ID''_''$dat\n');
	fprintf(fid,'#\n');
	fprintf(fid,'echo ''This run will be hosted into:''\n');
	fprintf(fid,'echo  $workdir/output/$hostdir\n');
	fprintf(fid,'#\n');
	fprintf(fid,'# Create directories:\n');
	fprintf(fid,'mkdir $workdir/output/$hostdir\n');
	fprintf(fid,'#\n');
	fprintf(fid,'# Move to the exec directory:\n');	
	fprintf(fid,'cd $workdir/output/$hostdir\n');
	fprintf(fid,'#\n');
	fprintf(fid,'# Move the prog to the exec dir and compile it:\n');	
	fprintf(fid,'cp %s/%s . \n',workdir,prog_to_compile);
	fprintf(fid,'module load intel\n');
	fprintf(fid,'ifort -O3 -ipo -mp1 -align -convert big_endian -assume byterecl -assume nobuffered_io -quiet %s -o %s\n',prog_to_compile,prog_to_run);	
	fprintf(fid,'#\n');
	fprintf(fid,'# Move the parameter file:\n');	
	fprintf(fid,'cp %s/param/%s . \n',workdir,param_file);
	fprintf(fid,'#\n');	
	fprintf(fid,'# Start run:\n');
	fprintf(fid,'./%s < %s\n',prog_to_run,param_file);
	fprintf(fid,'#\n');
	fprintf(fid,'exit\n');

	fclose(fid);
	
	end %for it
	
end %for klist

% Create script to launch everything:
fid = fopen(sprintf('%s/launch_all.bat',patho),'wt');
fprintf(fid,'#!/bin/csh\n');
fprintf(fid,'#\n');
fprintf(fid,'#  Created by Guillaume Maze on %s.\n',datestr(now,'yyyy-mm-dd'));
fprintf(fid,'#  Copyright (c) 2008 Guillaume Maze.\n');	
fprintf(fid,'#  Generated automatically by: create_launch_scripts.m\n');
fprintf(fid,'#\n');
for ik = 1 : length(klist)
	k = klist(ik);
	for it = 1 : length(tlist)
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
		end
		fprintf(fid,'qsub Bdg_%2.2d_%s.sh\n',k,tim);
	end
end %for ik
fprintf(fid,'#\n');
fclose(fid);
system(sprintf('chmod ugo+x %s',sprintf('%s/launch_all.bat',patho)));



%%% JUST FOR FUN WE CHECK AT THE FORTRAN CODE PARAMETERS:
s = input(sprintf('If this is a classis set up, I can check the fortran code domain parameters for you ?:\n[y]/n: '),'s');
if isempty(s) | lower(s)=='y' 

	fid = fopen(strcat(workdir,'/',prog_to_compile),'r');
	done = 0; il = 0;
	while done ~= 1 
		tline = fgetl(fid);
		if ischar(tline) & ~isempty(tline)
			il = il + 1;
			if tline(1) ~= '!' 
				if strfind(tline,'jpi=') & strfind(tline,'jpj=')  & strfind(tline,'jpk=') & strfind(tline,'nb_in=') 
					gline = strtrim(tline); glineN = il;
					jpi = str2num(gline(strfind(gline,'jpi=')+4:strfind(gline,',jpj=')-1));
					jpj = str2num(gline(strfind(gline,'jpj=')+4:strfind(gline,',jpk=')-1));
					jpk = str2num(gline(strfind(gline,'jpk=')+4:strfind(gline,',nb_in=')-1));
					fclose(fid);
					done = 1;
				end	%if the line we look for
			end %if not a comment
		end %if good line
	end % while

	di = dir('param');
	if size(di,1) == 2
		disp('No parameter files were found in the param directory !')
		disp('Something''s wrong here !');
	else
		fid = fopen(strcat('param/',di(3).name),'r');
		for il=1:3,tline=fgetl(fid);end;fclose(fid);
		di = dir(tline(2:end-1));
	end
	if size(di,1) == 2
		disp('No input files were found in the ''LRfiles'' directory !')
		disp('Something''s wrong here !');
	else
		recl = jpi*jpj*jpk*4*1099; % Classic set up
		if recl ~= di(end).bytes
			disp('!!!! It seems that the domain size in the fortran code doesn''t match the input file size !!!!')
			disp(sprintf('You should look at the line %i:',glineN));
			disp(gline)
			disp(sprintf('into the %s code',prog_to_compile));
		else
			disp('Everything looks good so far !');
			disp(sprintf('Individual queue files were created into the ''%s'' folder',patho))
			disp(sprintf('You can go into the ''%s'' folder and launch from a shell the ''launch_all.bat'' script',patho));
		end
	end
	
end % Perfom the check


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if output dir exists;
if ~exist(strcat(workdir,'/output'),'dir')
	mkdir(strcat(workdir,'/output'));
	disp('We also created the ''output'' folder to ensure the fortran won''t crash');
end













