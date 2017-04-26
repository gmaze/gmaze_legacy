% machine_list List all network machine with system command 'nslookup'
%
% [] = machine_list(DOMAIN)
% 
% From: nslookup DOMAIN, iterates on the III = 1:255 ip
% of XXX.XXX.III to get the list of machine's names available.
% No ping is done, so no informations about the machine's
% status is provided.
% The machine list is written in the text file:
% 	~/matlab/routines/data/machine_list_DOMAIN.txt
%
%
% Created: 2009-08-19.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = machine_list(varargin)


domain = varargin{1};
tmp    = strrep(num2str(randperm(24)),' ','');
system(sprintf('nslookup %s > %s',domain,tmp));
fid = fopen(tmp,'r');
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
	disp(tline)
	if strfind(tline,'Server')
		server = strtrim(strrep(tline,'Server:',''));
	end
	if strfind(tline,'Address')
		address = strtrim(strrep(tline,'Address:',''));
	end
end
fclose(fid);
delete(tmp)

isub = max(strfind(address,'.'));
ip_base = address(1:isub);
filo = abspath(sprintf('~/matlab/routines/data/machine_list_%s.txt',domain));
if exist(filo,'file')
	r = input('Overwrite results [y]/n ?','s');
	if ~isempty(r)
		if lower(r) == 'n'
			disp(sprintf('List of results available here: \ntype %s',filo));			
			return
		end
	end
end	
fid = fopen(filo,'w');
fprintf(fid,'List of machine(s) within the domain: %s\n',domain);
fprintf(fid,'Created: %s\n',datestr(now,'yyyy/mmm/dd'));
for ii = 1 : 255
	name = get_name(sprintf('%s%i',ip_base,ii));
	disp(sprintf('%40s (%s%i)',name,ip_base,ii))
	if ~isempty(name)
		fprintf(fid,'%40s (%s%i)\n',strtrim(name),ip_base,ii);
	end
end
disp('')
disp(sprintf('List of results written into: \n%s',filo));


end %function


function name = get_name(ip)
	tmp    = strrep(num2str(randperm(24)),' ','');
	system(sprintf('nslookup %s > %s',ip,tmp));
	name = '';
	try
		fid = fopen(tmp,'r');
		while 1
		    tline = fgetl(fid);
		    if ~ischar(tline), break, end
			if strfind(tline,'name')
				name = tline(strfind(tline,'name =')+6:end-1);
				break
			end
		end
		fclose(fid);
	end
	delete(tmp)
end %function






