% check_ethlog Update and view the my IFREMER working timeline
%
% INFO = check_ethlog([DOPLOT])
% 
% Scan the Macbook system log file for IFREMER network connections and
% detect when I'am connected at work.
% If any argument is given to the function, a graphical representation of
% the working timeline is done.
% Output INFO is:
%	INFO(1,:) : Length of the daily connection (in minutes)
%	INFO(2,:) : Time of connection
%	INFO(3,:) : Time of dis-connection
%	INFO(4,:) : Time axis as returned by datenum
%
% Created: 2009-10-29.
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

function varargout = check_ethlog(varargin)

pat = mfilename('fullpath');
pat = strrep(pat,'check_ethlog','data');
filo = sprintf('%s/work_ifremer_timeline.mat',pat);
disp(filo)
	
if nargin == 1
	[info timeline] = plotwtime(filo);
%	whos
	if nargout == 1
		varargout(1) = {cat(1,info,timeline)};
	end
	return
end

root = '/private/var/log';
di = dir(root); ik = 0;
for ii = 1 : length(di)
	if ~isempty(strfind(di(ii).name,'system.log')) %& isempty(strfind(di(ii).name,'4')) & isempty(strfind(di(ii).name,'5')) & isempty(strfind(di(ii).name,'6'))& isempty(strfind(di(ii).name,'7'))
		ik = ik + 1;
		flist(ik) = di(ii);
	end
end


timeline = datenum(2009,9,1,0,0,0) : now;
info = zeros(3,length(timeline));

if exist(filo,'file')
	loaded = load(filo,'timeline','info');
else
	loaded.timeline = timeline;
	loaded.info = info;
end


for ifile = 1 : length(flist)
	file = flist(ifile).name;
	disp(file);
	if strfind(file,'bz2')
		system(sprintf('bunzip2 -ckd %s/%s > .system.log',root,file));
	else
		system(sprintf('\\cp %s/%s .system.log',root,file));
	end
	file = '.system.log';

	fid = fopen(sprintf('%s',file),'r');
	disconnected = 1;
	connected = 0;
	ii = 0;
	while 1
		tline = fgetl(fid);
		if ~ischar(tline), break, end
		if ~isempty(strfind(lower(tline),'ethernet')) & ~isempty(strfind(tline,'link Valid and Active'))
			if disconnected == 1					
	%			disp(tline);
				connected = 1 ;
				disconnected = 0;
				a = strread(tline,'%s','delimiter',' ');
				ii = ii + 1;
				time_connect(1,ii) = datenum(sprintf('%s %s %s',a{1},a{2},a{3}),'mmm dd HH:MM:SS');
			end
		end
		if ~isempty(strfind(lower(tline),'ethernet')) & ~isempty(strfind(tline,'Link is down')) & ~isempty(strfind(tline,'br146-139'))
			if connected == 1			
	%			disp(tline);
				disconnected = 1;
				connected = 0;
				a = strread(tline,'%s','delimiter',' ');
				time_connect(2,ii) = datenum(sprintf('%s %s %s',a{1},a{2},a{3}),'mmm dd HH:MM:SS');
			end
		end
	end
	fclose(fid);

	if exist('time_connect')
		for ic = 1 : size(time_connect,2)
			if time_connect(2,ic) == 0
				dt = (now - time_connect(1,ic))*24*60; 
				dtstr = sprintf('From %s to now',datestr(time_connect(1,ic),'HH:MM:SS'));
			else
				dt = diff(time_connect(:,ic))*24*60;   
				dtstr = sprintf('From %s to %s',datestr(time_connect(1,ic),'HH:MM:SS'),datestr(time_connect(2,ic),'HH:MM:SS'));
			end
			if dt > 60
				d = sprintf('%iH%0.0f',fix(dt/60),rem(dt,60));
			else
				d = sprintf('%0.0fmin',dt);
			end
			disp(sprintf('%s: %s (%s)',datestr(time_connect(1,ic),'mmm dd'),d,dtstr));
			
			tc = datenum(2009,str2num(datestr(time_connect(1,ic),'mm')),str2num(datestr(time_connect(1,ic),'dd')),0,0,0);
			id = find(timeline==tc);
			if info(1,id) ~= 0
				info(1,id) = max([dt info(1,id)]);
				info(2,id) = min([info(2,id) time_connect(1,ic)]);
				info(3,id) = min([info(3,id) time_connect(2,ic)]);
			else
				info(1,id) = dt;
				info(2,id) = time_connect(1,ic);
				info(3,id) = time_connect(2,ic);
			end
		end%for ic
	end
end%for ifile


% Update archive file:
	t0 = loaded.timeline;
	T = min([t0 timeline]):max([t0 timeline]);
	for id = 1 : length(T)
		it0 = find(t0==T(id));
		it  = find(timeline==T(id));
		
		if info(2,it) ~=0 & loaded.info(2,it0) ~= 0
			% IN(2,id) = min([info(2,it) loaded.info(2,it0)]);
			% IN(3,id) = max([info(3,it) loaded.info(3,it0)]);
			% IN(1,id) = IN(3,id) - IN(2,id);
			IN(:,id) = loaded.info(:,it0);
		elseif info(2,it) == 0 & loaded.info(2,it0) ~= 0
			IN(:,id) = loaded.info(:,it0);
		elseif info(2,it) ~= 0 & loaded.info(2,it0) == 0
			IN(:,id) = info(:,it);
		else			
			IN(:,id) = [0 0 0];
		end
		
	end%for id
	info = IN;
	timeline = T;

save(filo,'timeline','info');

if nargout == 1
	varargout(1) = {cat(1,info,timeline)};
end

end %functioncheck_ethlog




function [info timeline] = plotwtime(filo)
	
	load(filo);
	it = find(info(1,:)~=0);
	info = info(:,it);
	timeline = timeline(it);
	itB = find(info(1,:)/60>24 & info(1,:)/60<48);
	info(1,itB)/60;
	% it = find(info(1,:)/60<24);
	% info = info(:,it);
	% timeline = timeline(it);
	
	tcont = timeline(1) : timeline(end);
	itwe = [strmatch('Sat',datestr(tcont,'ddd')) ; strmatch('Sun',datestr(tcont,'ddd'))]; 
	
	figure;figure_land;
	subp = ptable([2 2],[1 2 ; 3 3; 4 4]);
	iw=2;jw=2;ipl=0;
	
	ipl=ipl+1;axes(subp(ipl));hold on
	bwork = bar(timeline,info(1,:)/60); set(bwork,'facecolor','k','edgecolor','k');
%	bwork = bar(timeline(itB),info(1,itB)/60); set(bwork,'facecolor','r','edgecolor','r');
	bwe = bar(tcont(itwe),48*ones(1,length(itwe))); set(bwe,'facecolor',[1 1 1]*.8,'edgecolor',[1 1 1]*.8,'barwidth',1);
	set(gca,'xlim',timeline([1 end]));
	set(gca,'ylim',[0 12]);
	ylabel('Connection length in hours');title('Time connected at IFREMER per day');
	grid on, box
	datetick('x','dd/mm');
	
	ipl=ipl+1;axes(subp(ipl));hold on
	n  = histc(info(1,:)/60,[0:12]);
	b1 = bar([0:12],n); set(b1,'facecolor','k','edgecolor','k');
	grid on,box on,set(gca,'xlim',[0 12]);
	xlabel('Connection length in hours');
	ylabel('Nb of days connected');
	
	ipl=ipl+1;axes(subp(ipl));hold on
	t = str2num(datestr(info(2,:),'HH'));
	n = histc(t,[0:24]);
	b1=bar([0:24],n); set(b1,'facecolor','b','edgecolor','b');
	t = str2num(datestr(info(3,:),'HH'));
	n = histc(t,[0:24]);
	b2 = bar([0:24],n); set(b2,'facecolor','r','edgecolor','r');
	grid on,box on,set(gca,'xlim',[6 21]);
	set(gca,'xtick',[6:2:20]);
	xlabel('Time of arrival (blue) / departure (red)');
	ylabel('Nb of days connected');
	
end%function




