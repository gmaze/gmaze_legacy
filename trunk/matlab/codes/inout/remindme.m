% remindme Reminder using crontab and growl
%
% [] = remindme(TIME,[TXT])
% 
% This function use growlnotify to send you a reminder with message TXT at
% time given by TIME (as returned by datenum).
%
% Inputs:
%	TIME is a serial date number as return by datenum.
%		It can also be a string of the form 'HH:MM' to use the current day.
%	TXT is a string
%
% Eg:
%	remindme(now+10/60/24,'Coffee break !');
%	remindme('16:00','Thea break !');
%
% Extra:
% 	If TIME is set to NaN, the function simply clean the crontab file of all Matlab reminders
%	
%
% Created: 2009-10-15.
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function remindme(varargin)

dd   = varargin{1};
if ischar(dd)
	in = strread(dd,'%s','delimiter',':');
	cl = clock;
	dd = datenum(cl(1),cl(2),cl(3),str2num(in{1}),str2num(in{2}),0);
else
end

if nargin == 2
	mess = varargin{2};
else
	mess = 'You didn''t specified a message for this reminder';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Eventually, clear previous entries
if isnan(dd)
	cleancronfile;
	system('crontab crontab.txt'); % Install new crontab
	delete('crontab.txt');
	return
else
	[status,result] = system('crontab -l | grep -v "no crontab for" > crontab.txt');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Then we add the new line:
fid = fopen('crontab.txt','a+');
fseek(fid,0,1);
dds = dd;
for id = 1 : length(dd)	
	sticky = '-s';
	prior  = 0;
	% mess   = sprintf('Prochain bus a %s',datestr(dd(id),'HH:MM'));
	titl   = 'Matlab reminder';
	command = sprintf('/usr/local/bin/growlnotify %s -p %i --appIcon Matlab -m ''%s'' -t ''%s''',sticky,prior,mess,titl);
	tline = sprintf('%i\t%i\t%i\t%i\t*\t%s # matlab reminder',str2num(datestr(dds(id),'MM')),str2num(datestr(dds(id),'HH')),...
	str2num(datestr(dds(id),'dd')),str2num(datestr(dds(id),'mm')),command);	
	fprintf(fid,'%s\n',tline);
end%for id
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Install new crontab:
system('crontab crontab.txt');
delete('crontab.txt');


end %functionremindme



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% We clean previous entries:
function cleancronfile
	
	[status,result] = system('crontab -l | grep -v "no crontab for" > crontab.txt');

	fid = fopen('crontab.txt');ii=0;
	while 1
		tline = fgetl(fid);
		if ~ischar(tline), break, end
		ii = ii + 1;
		if strfind(tline,'# matlab reminder')
			keep(ii) = 0;
		else 	
			keep(ii) = 1;
		end		
	end
	fclose(fid);
	fid0 = fopen('crontab.txt');ii=0;
	fid1 = fopen('crontab1.txt','wt');
	while 1
		tline = fgetl(fid0);
		if ~ischar(tline), break, end
		ii = ii + 1;
		if keep(ii) == 1
			fprintf(fid1,'%s\n',tline);
		end		
	end
	fclose(fid0);
	fclose(fid1);
	fcopy('crontab1.txt','crontab.txt');
	delete('crontab1.txt');
	
	
end%function





