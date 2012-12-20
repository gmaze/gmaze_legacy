% top Give back informations about the memory use of Matlab
%
% [] = top()
% 
% Using system command top, give back informations about the memory use of Matlab
%
% Created: 2009-12-09.
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

function top_stats = top(varargin)


disp('--------------------');
user = getenv('USER');
switch wherearewe
	case 'beagle'
		comd = sprintf('top -n 1 -U %s > .top_matlab',user);
		system(comd);
		top_stats = read_topfile('.top_matlab');
		top_stats.mem
		top_stats.matlab
	otherwise
		disp(sprintf('Sorry I don''t know how to do this on ''%s''',wherearewe));
end


%delete('.top_matlab');
end %functiontop




function top_stats = read_topfile(file)
	
	fid = fopen(file,'r');
	imatlab = 0;
	while 1
		tline = fgetl(fid);
		if ~ischar(tline), break, end
		if strfind(tline,'Mem:')
			disp(tline);
			a = strread(tline,'%s','delimiter',',')
			a = strread(strrep(tline,' ','_'),'%s','delimiter',',')
			top_stats.mem.total = str2num(strrep(strrep(strrep(strrep(a{1},'Mem:',''),'k',''),'total',''),'_',''));
			top_stats.mem.used = str2num(strrep(a{2},'k used',''));
			top_stats.mem.free = str2num(strrep(a{3},'k free',''));
			top_stats.mem.buffers = str2num(strrep(a{4},'k buffers',''));
			top_stats.mem
		end
		if strfind(tline,'MATLAB')
			disp(tline)
			imatlab = imatlab + 1;			
			a = strread(tline,'%s','delimiter',' ');
			a = a(2:end)
			top_stats.matlab(imatlab).pid = str2num(strrep(a{1},'',''));
			top_stats.matlab(imatlab).user = str2num(strrep(a{2},'',''));
			top_stats.matlab(imatlab).PR = str2num(strrep(a{3},'',''));
			top_stats.matlab(imatlab).NI = str2num(strrep(a{4},'',''));
			top_stats.matlab(imatlab).VIRT = str2num(strrep(a{5},'m',''));
			top_stats.matlab(imatlab).RES = str2num(strrep(a{6},'m',''));
			top_stats.matlab(imatlab).SHR = str2num(strrep(a{7},'m',''));
			top_stats.matlab(imatlab).state = strrep(a{8},'','');
			top_stats.matlab(imatlab).CPU = str2num(strrep(a{9},'',''));
			top_stats.matlab(imatlab).MEM = str2num(strrep(a{10},'',''));
			top_stats.matlab(imatlab).TIME = a{11};
			top_stats.matlab(imatlab).COMMAND = a{12};
		end
	end
	
	
end

% PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND 















