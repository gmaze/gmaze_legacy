% MYQST Display qstat results
%
% [JOBLIST] = MYQST([ORDER])
% Display qstat results
%
% This function displays on a table the results of 'qstat -u <user>'
% ORDER indicates how to sort the results. It is a number designating
% of the output columns:
% 1 - ID 		: Job id
% 2 - Log		: This is the name of the job
% 3 - State		: State of the run (r:running, dr:scheduled for deletion, qw: waiting in the queue)
% 4 - Started	: Date of the job starting time
% 5 - Last touch: Date of the last modification of the output log file (DEFAULT SORTING COLUMN)
% 6 - Queue		: Name of the queue where the job is running
% The sorting column is indicated by a (*) mark.
%
% Created by Guillaume Maze on 2008-10-28.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
function varargout = myqst(varargin)

% Check options:
if nargin >= 1
	if isnumeric(varargin{1})
		sorting = varargin{1};
	end
end

% Default values:
if ~exist('sorting','var')
	sorting = 5; % Default sorting column (last touch)
end

colT{1} = 'ID';
colT{2} = 'Log';
colT{3} = 'State';
colT{4} = 'Started';
colT{5} = 'Last touch';
colT{6} = 'Queue';
colT{sorting} = ['(*) ' colT{sorting}];

global diag_screen_default
diag_screen_default.forma = '%s\n';
diag_screen_default.PIDlist = [1];	

% Template:
tpl = sprintf('| %5s | %30s | %9s | %15s | %15s | %25s |','','','','','','');
line='-';for ic=1:length(tpl)-1,line=[line '-'];end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
system('qstat -u gmaze > myqst.txt');
%system('qstat  > myqst.txt');
fid = fopen('myqst.txt');il=0;
if fid>0
	ijob = 0;
	cestfini=0;
	while cestfini ~= 1
		tline = fgetl(fid);
		if ~ischar(tline),cestfini=1;end
		if tline(1) == ' '
%			diag_screen('');
			ijob = ijob+1;
			job(ijob).id  = str2num(tline(3:8));
			job(ijob).prior  = str2num(tline(10:16));
			job(ijob).name   = strtrim(tline(17:27));
			job(ijob).user   = strtrim(tline(28:38));
			job(ijob).state  = strtrim(tline(39:45)); 
			job(ijob).submit = strtrim(tline(47:57));
			job(ijob).start  = strtrim(tline(58:66));
			job(ijob).queue  = strtrim(tline(67:97));
			job(ijob).slot   = str2num(tline(98:end));	
			job(ijob).it0 = datenum([job(ijob).submit '/' job(ijob).start],'mm/dd/yy/HH:MM:SS');	
			di = dir(sprintf('~/*.o%d',job(ijob).id));
			if isempty(di)
				di(1).name = 'unknow or QLOGIN';
				job(ijob).itR = now;
			else
				job(ijob).itR = di.datenum;			
			end
			job(ijob).script = di.name;
		end %if tline
	end
	delete('myqst.txt');
	if nargout == 1
		varargout(1) = {job};
	end
	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DISPLAY	
	diag_screen(line);
	diag_screen(sprintf('| %5s | %30s | %9s | %15s | %15s | %25s |',colT{1},colT{2},colT{3},colT{4},colT{5},colT{6}));
	diag_screen(line);
	
	switch sorting
		case 3 % This one sorts jobs by state:
			for ijob = 1 : size(job,2),if job(ijob).state == 'r',  print(job(ijob)); end,end
			for ijob = 1 : size(job,2),if job(ijob).state == 'qw', print(job(ijob)); end,end
			for ijob = 1 : size(job,2),if job(ijob).state == 'dr', print(job(ijob)); end,end
			
		case 4
			clear it,for ij = 1 : size(job,2),it(ij)=job(ij).it0;end % Start time
			[y,or] = sort(it); clear y % From the older to newer
			or = fliplr(or); % From the newer to the older		
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end
			
		otherwise % 5
			clear it,for ij = 1 : size(job,2),it(ij)=job(ij).itR;end % Last touch
			[y,or] = sort(it); clear y % From the older to newer
			or = fliplr(or); % From the newer to the older		
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end			
	end % Switch

	
	
	diag_screen(line);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
else
	diag_screen('Couldn''t use qstat');
end



function [] = print(job);

ijob = 1;
%diag_screen(sprintf('| %5d | %30s | %5s | %15s | %25s |',job(ijob).id,job(ijob).script,job(ijob).state,datestr(job(ijob).it0,'ddd at HH:MM:SS'),job(ijob).queue));
diag_screen(sprintf('| %5d | %30s | %9s | %15s | %15s | %25s |',job(ijob).id,job(ijob).script,job(ijob).state,datestr(job(ijob).it0,'ddd at HH:MM:SS'),datestr(job(ijob).itR,'ddd at HH:MM:SS'),job(ijob).queue));













