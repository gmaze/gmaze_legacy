% [] = check_jobs([email])
%
% Draw a small report on running jobs
% This routine relies on the default package !
% If an email is specified, output are printed into 
% the text file: jobs_report.txt and sent by email
%
% Created by Guillaume Maze on 2008-10-27.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function varargout = check_jobs(varargin)

global diag_screen_default
diag_screen_default.forma = '%s\n';

if nargin == 1
	report_file_name = 'jobs_report.txt';	
	diag_screen_default.PIDlist = [1 2];
	fid = fopen(report_file_name,'w');
	diag_screen_default.fid = fid;
	fid = fopen(report_file_name,'w');
	if isempty(varargin{1})
		email = 'codes@guillaumemaze.org'; % Default
	else
		email = varargin{1};
	end
else		
	diag_screen_default.PIDlist = [1];	
end

system('qstat -u gmaze > myqst.txt');
fid = fopen('myqst.txt');il=0;
if fid>0
	while 1
		tline = fgetl(fid);
		if ~ischar(tline),break,end
	%		diag_screen(tline)
		if tline(1) == ' '
			diag_screen('/ -------------------------------------------------------------------------------------------------- \');
			
			jobid  = str2num(tline(3:8));
			prior  = str2num(tline(10:16));
			name   = strtrim(tline(17:27));
			user   = strtrim(tline(28:38));
			state  = strtrim(tline(39:45)); 
			submit = strtrim(tline(47:57));
			start  = strtrim(tline(58:66));
			queue  = strtrim(tline(67:97));
			slot   = str2num(tline(98:end));
			di = dir(sprintf('~/*.o%d',jobid));
			if ~isempty(di)
				it0 = datenum([submit '/' start],'mm/dd/yy/HH:MM:SS');
				itR = di.datenum;
				diag_screen(sprintf('Job: %i running on node: %s',jobid,queue))
				diag_screen(sprintf('%5s ----------------------------------',' '));
				switch state
					case 'r'
						diag_screen(sprintf('%5s Log file  : %s',' ',di.name))
						diag_screen(sprintf('%5s Start     : %s',' ',datestr(it0,'yyyy mmm,dd at HH:MM:SS')))
						diag_screen(sprintf('%5s Last print: %s',' ',datestr(itR,'yyyy mmm,dd at HH:MM:SS')))
						diag_screen(sprintf('%5s This job has been running for: %s day(s), %s hour(s), %s min(s) and %s sec(s)',' ',...
										datestr(itR-it0,'dd'),...
										datestr(itR-it0,'HH'),...
										datestr(itR-it0,'MM'),...
										datestr(itR-it0,'SS')))				
						try 
							dt = get_time(strcat('~/',di.name));
							if itR-it0 < 1/24 & itR-now > 1/24
								diag_screen(sprintf('!!%3s It''s weird because the log file didn''t change after 1 hour of processing',' '))
								warn(jobid);
								moreI(di.name,0);
								%moreI(jobid,1);
							else
								diag_screen(sprintf('%5s Will end : %s',' ',datestr(dt/86400+it0,'yyyy mmm,dd at HH:MM:SS')))
							end
				
						catch
							if 0
								la = lasterror;
								diag_screen(sprintf('We encountered the following error:'))
								diag_screen(la.message);
								diag_screen('Abort abort !');
							end
							diag_screen(sprintf('!!%3s Couldn''t determine an estimated run length',' '))
							warn(jobid);
							%moreI(jobid,1);
							moreI(di.name,0);
						end
						
					case 'dr'
						diag_screen(sprintf('%5s This job is being terminated !',' '))
					case 'qw'
						diag_screen(sprintf('%5s This job is waiting !',' '))
						
				end %switch state
				diag_screen('\ -------------------------------------------------------------------------------------------------- /');
			end
		end
	end
	delete('myqst.txt');
	if nargin == 1	
		chaine = sprintf('mail -s ''%s'' %s < %s',sprintf('Job(s) report from %s: %s',wherearewe,datestr(now,'dddd HH:MM')),email,report_file_name);
		system(chaine);
	end

else
	diag_screen('Couldn''t use qstat');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = moreI(varargin)
	
method = varargin{2};
switch method
	case 0
		logfile = varargin{1};
		fid = fopen(strcat('~/',logfile));
		fgetl(fid);
		hostdir = fgetl(fid); fclose(fid);
		di = dir(strcat(hostdir,'/param*'));
		diag_screen(sprintf('!!%3s This was the parameter file:\n%5s %s/%s',' ',' ',hostdir,di.name));
		fid = fopen(strcat(hostdir,'/',di.name));
		for il = 1 : 4
			tline = fgetl(fid);
			diag_screen(sprintf('%5s %s',' ',tline));
		end
		fclose(fid);
			
	
	case 1	
	
		jobid = varargin{1};	
		system(sprintf('qstat -j %i > jobI.txt',jobid));

		fid = fopen('jobI.txt');il=0;
		if fid>0
			while 1
				tline = fgetl(fid);
				if ~ischar(tline),break,end
				if strfind(tline,'sge_o_workdir');
					workdir = strtrim(tline(length('sge_o_workdir')+2:end));
				end
				if strfind(tline,'script_file');
					script = strtrim(tline(length('script_file')+2:end));
				end
			end
			fclose(fid);
		end	
		scriptfile = [workdir '/' script];
		switch script(1:3)
			case 'Bdg'
				fig=fopen(scriptfile);
				while 1
					tline = fgetl(fid);
					if ~ischar(tline),break,end
					if strfind(tline,'# Move the parameter file:')
						tline = fgetl(fid);
						break;
					end
				end
				fclose(fid);
				paramfile = strtrim(tline(4:end));
				paramfile = paramfile(1:end-2);
				diag_screen(sprintf('!!%3s This was the parameter file:\n%s',' ',paramfile));
				fid=fopen(paramfile);
				while 1
					tline = fgetl(fid);
					if ~ischar(tline),break,end
					diag_screen(tline);
				end
				fclose(fid);
			
		end
		delete('jobI.txt');

end %switch



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = warn(varargin);
	
diag_screen(sprintf('!!%3s It probably means the job is dead and out of control ! Abort abort DC132 ;-)',' '));
diag_screen(sprintf('!!%3s Kill it with command:\n qdel -f %i',' ',varargin{1}));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = get_time(varargin);
	
fili = varargin{1};

fid = fopen(fili);
if fid > 0
	
	
	iter = 0;
	pate = 'Etime it-1:it =';
	pate2 = '  and for iterations: ';
	while 1
		tline = fgetl(fid);
		if ~ischar(tline),break,end
		if ~isempty(strfind(tline,pate))
			%# ITER =   39 # LRdiffTOT.3yV2adv.bin # Etime it-1:it = 91.69
%			diag_screen(tline); % Full line
			ii=strfind(tline,pate);
			iter = iter + 1;
			et(iter) = str2num(tline(ii+length(pate):end));
		end
		if ~isempty(strfind(tline,pate2))
			ii=strfind(tline,pate2);
			%  and for iterations:           1 TO:        1099
%			diag_screen(tline)
			it1=str2num(tline(ii+length(pate2):strfind(tline,'TO:')-1));
			it2=str2num(tline(strfind(tline,'TO:')+3:end));
		end
			
	end
	et = et(2:end);
	nt = it2-it1+1;
	to = mean(et)*nt;
	if to > 60
		if to/60 > 60
			if to/60/60/24 > 1
				diag_screen(sprintf('%5s Time left: %g day(s) and %g hour(s)',' ',fix(to/60/60/24),round((to-fix(to/86400)*86400)/3600)))
			else
				diag_screen(sprintf('%5s Time left: %g (hours)',' ',to/60/60))
			end
		else
			diag_screen(sprintf('%5s Time left: %g (mins)',' ',to/60))
		end
	else
		diag_screen(sprintf('%5s Time left: %g (secs)',' ',to))
	end	
end %if 
fclose(fid);

if nargout >= 1
	varargout(1) = {to};
%	varargout(1) = {et(2:end)};
end




	
	















