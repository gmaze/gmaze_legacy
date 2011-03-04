% grep Grep a string into definitions of functions
%
% [TB] = grep(PATTERN,[PATH])
% 
% Scan the optional folder name [PATH] (by default look into ~/matlab/routines/)
% for matlab functions and grep PATTERN into the definition
% 
% Example:
% grep('mean')
%
% See Also: gmat
%
% Created: 2009-08-25.
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

function varargout = grep(varargin)
		
switch nargin
	case 0
		pattern = ' ';  % List of functions ...
		pathd = abspath('~/matlab/routines/');
	case 1
		pattern = varargin{1};
		pathd = abspath('~/matlab/routines/');
	case 2
		pattern = varargin{1};
		pathd = abspath(varargin{2});
	otherwise
		error('Bad number of arguments');
end		

% Scan fcuntions:
di = dir(sprintf('%s/*.m',pathd));
ifct = 0; blk = ' '; ifou = 0;
for ifil = 1 : size(di,1)
	name = di(ifil).name;
	try 
		if isempty(strfind(lower(name),'content'))
			fid = fopen(sprintf('%s/%s',pathd,name),'r');
			if fid > 0
				ifct = ifct + 1;
				point = ftell(fid);
				done = 0;
				while done ~= 1
					tline = fgetl(fid);
					if tline(1) == '%'
						done = 1;
					end
				end		
				head = readheader(fid);
				fclose(fid);
				is = strfind(tline,blk);
				fctname = tline(is(1):is(2));
				fctdefi = tline(is(2)+1:end);
				TB(ifct).file = name;
%				TB(ifct).name = fctname;
				TB(ifct).name = strrep(strrep(name,'.m',''),'.M','');
				TB(ifct).def  = fctdefi;
				TB(ifct).head  = head;
				TBlist(ifct) = {name};
				% disp(sprintf('%20s: %s',fctname,fctdefi));
			end
		end % we exclude this one
	catch
		error(sprintf('Error processing file: %s',name))
	end %try	
end %for ifil

if exist('TB','var')
	[a is] = sort(TBlist);
	TB = TB(is);
	
	% Search pattern into name and definition:
	for ifct = 1 : length(TB)
		is  = strfind(lower(TB(ifct).def),lower(pattern));
		is2 = strfind(lower(TB(ifct).name),lower(pattern));
		if ~isempty(is) | ~isempty(is2)
			ifou = ifou + 1;
			keep(ifou) = ifct;
		end
	end%for ifct
	if exist('keep','var')
		TB = TB(keep);
		% Display result:
		disp(sprintf('Found %i result(s) into %s',length(keep),pathd));
		for ifct = 1 : length(TB)
			disp(sprintf('%30s: %s',TB(ifct).name,TB(ifct).def));
		end
	else
		disp('No results');
		TB = NaN;
	end

else
	disp('No results');
	TB = NaN;
end

switch nargout
	case 1
		varargout(1) = {TB};
end
end %function




%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function head = readheader(fid)
	
done = 0;
fseek(fid,0,'bof');
il = 0;
while done ~= 1
	tline = fgetl(fid);
	tl = strtrim(tline); 
	if ~isempty(tl)
		if tl(1) == '%' 
%			if length(strfind(tl,'%')) ~= length(tl) & isempty(strfind(lower(tl),'guillaumemaze.org')) & isempty(strfind(lower(tl),'copyright'))
			if isempty(strfind(lower(tl),'guillaumemaze.org')) & isempty(strfind(lower(tl),'copyright'))				
				il = il + 1;
				if exist('head','var')
					head = sprintf('%s<br>%s',head,tline);
				else
					head = sprintf('%s',tline);
				end
				%if il == 20, head = sprintf('%s<br>...',head); done = 1; end				
			end
		end
	else
		done = 1;
	end
end

end %function

