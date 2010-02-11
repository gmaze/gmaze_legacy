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
if nargin >= 2
	if ischar(varargin{2})
		select = varargin{2};
	end
end

% Default values:
if ~exist('sorting','var')
	sorting = 2; % Default sorting column (last touch)
end
if ~exist('select','var');
	select = '*'; % Default display all jobs
end

colT{1} = 'ID';
colT{2} = 'Log';
colT{3} = 'State';
colT{4} = 'Started';
colT{5} = 'Last touch';
colT{6} = 'Queue';
colT{7} = 'Length';
colT{sorting} = ['(*) ' colT{sorting}];

global diag_screen_default
diag_screen_default.forma = '%s\n';
diag_screen_default.PIDlist = [1];	

% Template:
tpl = sprintf('| %5s | %30s | %9s | %15s | %15s | %25s | %10s |','','','','','','','');
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
	diag_screen(sprintf('| %5s | %30s | %9s | %15s | %15s | %25s | %10s |',colT{1},colT{2},colT{3},colT{4},colT{5},colT{6},colT{7}));
	diag_screen(line);
	job = selectthesejobs(job,sorting,select);
	if ~isempty(job)
		
	if strfind(colT{sorting},'ID') % This one sorts jobs by id
			clear it,for ij = 1 : size(job,2),it(ij)=job(ij).id;end % ID	
			[y,or] = sort(it); clear y
			or = fliplr(or);
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end
			
	elseif strfind(colT{sorting},'touch') % This one sorts jobs by Last touch time
			clear it,for ij = 1 : size(job,2),it(ij)=job(ij).itR;end % Last touch
			[y,or] = sort(it); clear y % From the older to newer
			or = fliplr(or); % From the newer to the older		
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end


	elseif strfind(colT{sorting},'State') % This one sorts jobs by state:
			for ijob = 1 : size(job,2),if job(ijob).state == 'r',  print(job(ijob)); end,end
			for ijob = 1 : size(job,2),if job(ijob).state == 'qw', print(job(ijob)); end,end
			for ijob = 1 : size(job,2),if job(ijob).state == 'dr', print(job(ijob)); end,end


	elseif strfind(colT{sorting},'Queue') % This one sorts jobs by queue name
			clear it,for ij = 1 : size(job,2),it(ij)={job(ij).queue};end % Name
			[y,or] = sort(it); clear y % From the older to newer
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end	

	elseif strfind(colT{sorting},'Started') % sort by starting time
			clear it,for ij = 1 : size(job,2),it(ij)=job(ij).it0;end % Last touch
			[y,or] = sort(it); clear y % From the older to newer
			or = fliplr(or); % From the newer to the older		
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end	
			
	else  % strfind(colT{sorting},'Name') % Default,  This one sorts jobs by name
			clear it,for ij = 1 : size(job,2),it(ij)={job(ij).name};end % Name
			[y,or] = sort(it); clear y % From the older to newer
			for ij = 1 : size(job,2)
				ijob = or(ij);
				print(job(ijob));
			end
	end % if
	
	else
		diag_screen('No match');
	end %if not empty

	diag_screen(line);
	if nargout == 1
		varargout(1) = {job};
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
else
	diag_screen('Couldn''t use qstat');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [] = print(job);

ijob = 1;
try 
	dt = (job(ijob).itR-job(ijob).it0)*24*60;
catch	
	dt = 0;
end
if dt<60
	dt = sprintf('%i mins',fix(dt));
else
	dt = sprintf('%ih%i',fix(dt/60),fix(rem(dt,60)));
end

%diag_screen(sprintf('| %5d | %30s | %5s | %15s | %25s |',job(ijob).id,job(ijob).script,job(ijob).state,datestr(job(ijob).it0,'ddd at HH:MM:SS'),job(ijob).queue));
diag_screen(sprintf('| %5d | %30s | %9s | %15s | %15s | %25s | %10s |',job(ijob).id,job(ijob).script,job(ijob).state,datestr(job(ijob).it0,'ddd at HH:MM:SS'),datestr(job(ijob).itR,'ddd at HH:MM:SS'),job(ijob).queue,dt));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function varargout = selectthesejobs(jobs,sorting,select);
	
switch sorting
	case 1,    	namfield = 'id';
	case 2,   	namfield = 'script';
	case 3, 	namfield = 'state';
	case 4, 	namfield = 'it0'; 
	case 5, 	namfield = 'itR'; 
	case 6, 	namfield = 'queue';
end	

if ~strcmp(select,'*')
	
	% Clean multiple *: 
	select = strrep(select,'*','^');
	select = strrep(select,'^^','^');
	select = strrep(select,'^^^','^');
	select = strrep(select,'^^^','^');	
	select = strrep(select,'^','*');
	
	imatch = strfind(select,'*');
	nmatch = length(imatch);
	jobL = zeros(1,size(jobs,2));

	for ijob = 1 : size(jobs,2)
		tokeep = 0;
		str = getfield(jobs,{ijob},namfield);
		if sorting == 1, str = num2str(str); end
		if sorting == 4, str = datestr(str,'ddd at HH:MM:SS'); end
		if sorting == 5, str = datestr(str,'ddd at HH:MM:SS'); end
		
		if nmatch == 0 % We look for a perfect match
			if strcmp(str,select), tokeep = 1; end

		elseif nmatch == 1 & (select(1) == '*' | select(end) == '*' )
			tokeep = found(str,select);
			
		elseif nmatch == 1
			t1 = found(str,select(1:imatch-1));
			t2 = found(str,select(imatch:end));
			if t1 + t2 == 2, tokeep = 1; end
			
		elseif nmatch == 2 & (select(1) == '*' & select(end) == '*' )
			if strfind(str,select(2:end-1)), tokeep =1; end
			
			
		elseif nmatch == 3
			error('No more than 2 stars in regexp please');
		
		end % if number of *
		if tokeep == 1
			jobL(ijob) = 1;
		end
	end % for ijobs
	if sum(jobL) == 0
		newjobs = [];
	else
		newjobs = jobs(find(jobL==1));
	end
else
	newjobs = jobs;
end

if nargout == 1
	varargout(1) = {newjobs};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function tokeep = found(str,select)
	
tokeep = 0;	
if select(1) == '*'
	pat = strrep(select,'*',''); np = length(pat)-1;
	if strcmp(str(end-np:end),pat), tokeep=1; end
elseif select(end) == '*'
	pat = strrep(select,'*',''); np = length(pat);
	if strcmp(str(1:np),pat), tokeep=1; end
end 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	




