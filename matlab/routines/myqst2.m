% MYQST2 Display qstat results based on xml
%
% [JOBLIST] = MYQST2([ORDER])
% Display qstat results
%
% This function displays on a table the results of 'qstat -u <user>'
% ORDER indicates how to sort the results. It is one  of the number
% of the output columns:
% 1 - ID 		: Job id
% 2 - User		: Owner user name
% 3 - Name		: This is the name of the job
% 4 - State		: State of the run (r:running, dr:scheduled for deletion, qw: waiting in the queue)
% 5 - Started	: Date of the job starting time
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

function varargout = myqst2(varargin)

% Check options:
if nargin == 1
	if isnumeric(varargin{1})
		sorting = varargin{1};
	end
	if ischar(varargin{1})
		user = varargin{1};
	end
end
if nargin == 2
	if isnumeric(varargin{1})
		sorting = varargin{1};
	else
		user = varargin{1};
	end	
	if isnumeric(varargin{2})
		sorting = varargin{2};
	else
		user = varargin{2};
	end
end

% Default values:
if ~exist('sorting','var')
	sorting = 5; % Default sorting column
end
if ~exist('user','var')
	user = 'gmaze'; % Default user: everybody
%	user = ''; % Default user: everybody
end

ii = 0;
ii=ii+1; colT{ii} = 'ID';
ii=ii+1; colT{ii} = 'User';
ii=ii+1; colT{ii} = 'Name';
ii=ii+1; colT{ii} = 'State';
ii=ii+1; colT{ii} = 'Started';
%ii=ii+1; colT{ii} = 'Last touch';
ii=ii+1; colT{ii} = 'Queue';
colT{sorting} = ['(*) ' colT{sorting}];

global diag_screen_default
diag_screen_default.forma = '%s\n';
diag_screen_default.PIDlist = [1];	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get infos
job = parseqstatxml(user);
if nargout == 1
	varargout(1) = {job};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display:	
% Template:
tpl = sprintf('| %6s | %10s | %30s | %9s | %15s | %25s |','','','','','','');
line='-';for ic=1:length(tpl)-1,line=[line '-'];end

diag_screen(line);
diag_screen(sprintf('| %6s | %10s | %30s | %9s | %15s | %25s |',colT{1},colT{2},colT{3},colT{4},colT{5},colT{6}));
diag_screen(line);

if strfind(colT{sorting},'ID') % This one sorts jobs by id
		clear it,for ij = 1 : size(job,2),it(ij)=job(ij).id;end % ID	
		[y,or] = sort(it); clear y
		or = fliplr(or);
		for ij = 1 : size(job,2)
			ijob = or(ij);
			print(job(ijob));
		end
		
elseif strfind(colT{sorting},'Name') % This one sorts jobs by name
		clear it,for ij = 1 : size(job,2),it(ij)={job(ij).name};end % Name
		[y,or] = sort(it); clear y % From the older to newer
		for ij = 1 : size(job,2)
			ijob = or(ij);
			print(job(ijob));
		end
		
elseif strfind(colT{sorting},'State') % This one sorts jobs by state:
		for ijob = 1 : size(job,2),if job(ijob).state2 == 'r',  print(job(ijob)); end,end
		for ijob = 1 : size(job,2),if job(ijob).state2 == 'qw', print(job(ijob)); end,end
		for ijob = 1 : size(job,2),if job(ijob).state2 == 'dr', print(job(ijob)); end,end
		
		
elseif strfind(colT{sorting},'Queue') % This one sorts jobs by queue name
		clear it,for ij = 1 : size(job,2),it(ij)={job(ij).queue};end % Name
		[y,or] = sort(it); clear y % From the older to newer
		for ij = 1 : size(job,2)
			ijob = or(ij);
			print(job(ijob));
		end	
		
else % Default, sort by starting time
		clear it,for ij = 1 : size(job,2),it(ij)=job(ij).it0;end % Last touch
		[y,or] = sort(it); clear y % From the older to newer
		or = fliplr(or); % From the newer to the older		
		for ij = 1 : size(job,2)
			ijob = or(ij);
			print(job(ijob));
		end			
end % if




	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = print(job);

diag_screen(sprintf('| %6d | %10s | %30s | %9s | %15s | %25s |',job.id,job.owner,job.name,job.state2,datestr(job.it0,'ddd at HH:MM:SS'),job.queue));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = parseqstatxml(varargin)
	
% We gonna read the output of: qstat -xml -u gmaze 
% and return a structure with jobs information

if nargin == 1 & ~isempty(varargin{1})
	system(sprintf('qstat -u %s -xml > myqst.xml',varargin{1}));
else
	system('qstat -xml > myqst.xml');
end

fid = fopen('myqst.xml');
if fid>0
	%%%%%%%%%%%%%% First we check how many jobs are in the xml file:
	cestfini=0;
	njob = zeros(1000,2);
	ijob = 0;
	while cestfini ~= 1
		point = ftell(fid);
		tline = fgetl(fid);
		if ~ischar(tline),cestfini=1;end

		if strfind(tline,'<job_list')
			ijob = ijob + 1;
			njob(ijob,1) = point;
		end
		if strfind(tline,'</job_list>')
			njob(ijob,2) = point;
		end		
	end %while
	njob = njob(1:ijob,:); % This contains where to get info in the file for each jobs
	
	%%%%%%%%%%%%% Then we read the values
	for ijob = 1 : size(njob,1)
		fseek(fid,njob(ijob,1),'bof');
		tline = fgetl(fid);
		job(ijob) = initajob; % Initialise all fields		
		job(ijob).state  = retrievevalue(tline,1);
		thisonedone = 0;		
		while thisonedone ~= 1				
			point = ftell(fid);	
			if point ~= njob(ijob,2)	
				tline = fgetl(fid);
				[prop val] = retrievevalue(tline,2);
				switch lower(prop)
					case 'jb_job_number', 	job(ijob).id = str2num(val);
					case 'jat_prio', 		job(ijob).priority = val;
					case 'jb_name', 		job(ijob).name = val;
					case 'jb_owner', 		job(ijob).owner = val;
					case 'state', 			job(ijob).state2 = val;
					case 'jat_start_time', 	% This should be in the form: 2008-10-29T11:53:57						
											job(ijob).it0 = datenum(val,'yyyy-mm-ddTHH:MM:SS');
					case 'queue_name', 		job(ijob).queue = val;
					case 'slots', 			job(ijob).slots = val;
					% case '', job(ijob). = ; 
				end
				%disp(sprintf('%s: %s',prop,val));
			else
				thisonedone = 1;
			end
		end
	end %for ijob
	varargout(1) = {job};
	delete('myqst.xml');	
else
	diag_screen('Couldn''t use qstat');
end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function job = initajob(job)

job.state = '*';
job.id = 0;
job.priority = '*';
job.name = '*';
job.owner = '*';
job.state2 = '*';
job.it0 = datenum('190001010000','yyyymmddHHMM');
job.queue = '*';
job.slots = '*';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = retrievevalue(tline,typ,varargin)

switch typ
	case 1 % <job_list state="running">
		is = strfind(tline,'"');
		if iseven(length(is))
			is = reshape(is,[2 length(is)/2]);
			for ip = 1 : size(is,2)
				val = tline(is(1,ip)+1:is(2,ip)-1);
			end		
		else
			disp('Something''s wrong with this propertie')
		end
		varargout(1) = {val};
		
	case 2 % <JB_job_number>46581</JB_job_number>
		iso = strfind(tline,'<');
		isc = strfind(tline,'>');
		if length(iso) ~= length(isc)	
			disp('Something''s wrong with this propertie')
		else
			prop = strtrim(tline(iso(1)+1:isc(1)-1)); % Property name
			val  = strtrim(tline(isc(1)+1:iso(2)-1)); % Property value
			varargout(1) = {prop};
			varargout(2) = {val};
		end
end

	
	
	

% <?xml version='1.0'?>
% <job_info  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
%   <queue_info>
%     <job_list state="running">
%       <JB_job_number>46581</JB_job_number>
%       <JAT_prio>0.50500</JAT_prio>
%       <JB_name>Bdg_06_YEAR.sh</JB_name>
%       <JB_owner>gmaze</JB_owner>
%       <state>r</state>
%       <JAT_start_time>2008-10-29T11:53:57</JAT_start_time>
%       <queue_name>darwin@compute-3-13.local</queue_name>
%       <slots>1</slots>
%     </job_list>
%     <job_list state="running">
%       <JB_job_number>46602</JB_job_number>
%       <JAT_prio>0.50500</JAT_prio>
%       <JB_name>QLOGIN</JB_name>
%       <JB_owner>gmaze</JB_owner>
%       <state>r</state>
%       <JAT_start_time>2008-10-30T10:06:51</JAT_start_time>
%       <queue_name>darwin@compute-3-15.local</queue_name>
%       <slots>1</slots>
%     </job_list>
%   </queue_info>
%   <job_info>
%   </job_info>
% </job_info>


	
	
	
	








