% grep Grep a string into definitions of functions
%
% [TB] = grep(PATTERN,[PATH])
% 
% Scan the optional folder name [PATH] (by default look into ~/matlab/codes/*)
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
		
% Rev. by Guillaume Maze on 2011-03-07: Now the variable di is set
%	directly in the nargin check. This allows me to use my personal
%	default directory with subdirectories.
% Rev. by Guillaume Maze on 2011-03-16: Also search in Copoda/utils by default

t0 = now;
		
switch nargin
	case 0
		% pattern = ' ';  % List of functions ...
		% pathd = abspath('~/matlab/codes/*');
		% di = getdiprivate;
		% di = cat(1,di,dir(abspath('~/matlab/copoda_project/svn/trunk/copoda/utils'),'*.m'));
		error('Please specify a string to search for !');		
	case 1
		pattern = varargin{1};
		pathd   = abspath('~/matlab/codes/*');
		di = getdiprivate;
		di = cat(1,di,getdicopoda);
	case 2
		pattern = varargin{1};
		pathd = abspath(varargin{2});
		di = dir(fullfile(pathd,'*.m'));
		di = fixlist(pathd,di);
	otherwise
		error('Bad number of arguments');
end		

% Scan fcuntions:
ifct = 0; blk = ' '; ifou = 0;
for ifil = 1 : size(di,1)
	name = di(ifil).name;
	try 
		if isempty(strfind(lower(name),'content'))
			fid = fopen(name,'r');
%			fid = fopen(fullfile(pathd,name),'r');
%			fid = fopen(sprintf('%s/%s',pathd,name),'r');
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
				[fpath,fname,fext] = fileparts(name);
				TB(ifct).file = name;
				TB(ifct).path = fpath;
%				TB(ifct).name = fctname;
				TB(ifct).name = strrep(strrep(fname,'.m',''),'.M','');
%				TB(ifct).def  = fctdefi;
				TB(ifct).def  = regexprep(fctdefi,sprintf('(\\w*)%s(\\w*)',pattern),sprintf('$1[%s]$2',pattern),'ignorecase');
				TB(ifct).head = head;
				TBlist(ifct) = {name};
				% disp(sprintf('%20s: %s',fctname,fctdefi));
			else
				disp(sprintf('Couldn''t open file: %s',name))
			end
		end % we exclude this one
	catch
		disp(sprintf('Error processing file: %s',name))
		ifct = ifct - 1;	
	end %try	
end %for ifil

if exist('TB','var')
	[a is] = sort(TBlist);
	TB = TB(is);
	
	% Search pattern into matlab file name and definition:
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
		n = get(0,'commandWindowSize');
		res = sprintf('Found %i result(s) into %s',length(keep),pathd);
		tim = stralign(n(1)-length(res)-1,sprintf('(in %0.2f seconds)',(now-t0)*86400),'right');
		disp(sprintf('%s %s',res,tim))
		
%		disp(sprintf('Found %i result(s) into %s',length(keep),pathd));
		for ifct = 1 : length(TB)
%			disp(sprintf('%s: %s',strjust(sprintf('%30s',TB(ifct).name),'left'),strjust(sprintf('%30s',TB(ifct).def),'left')));
			disp(sprintf('%s: %s (%s)',stralign(20,TB(ifct).name,'left'),stralign(50,TB(ifct).def,'left'),TB(ifct).file));
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

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function di = getdiprivate;

% We look in the path for any folders with root: ~/matlab/codes:
p = path;
plist = strread(p,'%s','delimiter',':');
droot = abspath('~/matlab/codes');

for ip = 1 : length(plist)
	p = plist{ip};
	if length(p)>=length(droot) & strcmp(p(1:length(droot)),droot)
		keep(ip) = 1;
	else
		keep(ip) = 0;
	end% if 
end% for ip
plist = plist(keep==1);

di = dir(fullfile(plist{1},'*.m'));
di = fixlist(plist{1},di);
for ip = 2 : length(plist)
	di0 = dir(fullfile(plist{ip},'*.m'));
	di0 = fixlist(plist{ip},di0);
	di = cat(1,di,di0);
end% for ip


end %function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function di = getdicopoda;

% We look in the path for any folders with root: ~/matlab/copoda_project/svn/trunk/copoda/utils
cpdir = abspath('~/matlab/copoda_project/svn/trunk/copoda/utils');
di = dir(fullfile(cpdir,'*.m'));
di = fixlist(cpdir,di);

end %function
%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function di = fixlist(droot,di)
	for ifi = 1 : size(di,1)
		di(ifi).name = fullfile(droot,di(ifi).name);
	end% for ifi
end% function











