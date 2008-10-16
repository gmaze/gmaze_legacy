%DEF Create scripts to launch the matlab routine into a queue
%
%
% Created by Guillaume Maze on 2008-10-11.
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

patho       = './scripts'; % This is where we print the queue files
workdir     = '/home/gmaze/work/Postdoc/work/coare/Tlayer_budget/step1/';
matlabpath  = '/home/software/matlab-2007a/bin/matlab'; % Where do we find matlab ? this is for Beagle
%matlabpath  = '/usr/local/pkg/matlab/matlab-7r14/bin/matlab'; % AO

klist = [1:7];
% 1: theta and volume elements
% 2: Tend. Native
% 3: Tend. Artif
% 4: Air-sea flux
% 5: All others (ssh, gtabt, ghatt)
% 6: total advection
% 7: total diffusion

% Check if the output dir exists:
if ~exist(patho,'dir')
	system(sprintf('mkdir %s',patho));
end

% Do we clear the output scripts directory ?
s = input(sprintf('Do you want to clear the directory ([y]/n)?:\n%s\n',patho),'s');
if isempty(s) | lower(s)=='y' 
	system(sprintf('\\rm %s/*',patho));
end

% Create individual run scripts:
for ik = 1 : length(klist)
	
	k = klist(ik);
		
	fid = fopen(sprintf('%s/ExtDom_set%2.2d.sh',patho,k),'wt');

	fprintf(fid,'#!/bin/csh\n');
	fprintf(fid,'#\n');
	fprintf(fid,'#  Created by Guillaume Maze on %s.\n',datestr(now,'yyyy-mm-dd'));
	fprintf(fid,'#  Copyright (c) 2008 Guillaume Maze.\n');	
	fprintf(fid,'#  Generated automatically by: create_queue_scripts.m\n');
	fprintf(fid,'#\n');
	fprintf(fid,'set workdir=''%s''\n',workdir);
	fprintf(fid,'set matlabpath=''%s''\n',matlabpath);
	fprintf(fid,'#\n');
	fprintf(fid,'# Move to the exec directory:\n');	
	fprintf(fid,'cd $workdir\n');
	fprintf(fid,'#\n');
	fprintf(fid,'# Start run:\n');
	fprintf(fid,'$matlabpath -nojvm -nodisplay -r ''extract_subdomain(%i)''\n',k);
	fprintf(fid,'#\n');
	fprintf(fid,'exit\n');

	fclose(fid);
		
end %for klist

% Create script to launch everything:
fid = fopen(sprintf('%s/launch_all.bat',patho),'wt');
fprintf(fid,'#!/bin/csh\n');
fprintf(fid,'#\n');
fprintf(fid,'#  Created by Guillaume Maze on %s.\n',datestr(now,'yyyy-mm-dd'));
fprintf(fid,'#  Copyright (c) 2008 Guillaume Maze.\n');	
fprintf(fid,'#  Generated automatically by: create_queue_scripts.m\n');
fprintf(fid,'#\n');
for ik = 1 : length(klist)
	k = klist(ik);
	fprintf(fid,'qsub ExtDom_set%2.2d.sh\n',k);
end %for ik
fprintf(fid,'#\n');
fclose(fid);
system(sprintf('chmod ugo+x %s',sprintf('%s/launch_all.bat',patho)));





