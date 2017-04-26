% gmat Grep a string into comments of Matlab routines within a given folder or file
%
% [] = gmat(STRING,[[FOLDER],[OPT]])
% 
% This function sparses all *.m files into the optional directory FOLDER
% (default is ".") and look for occurances of STRING (case insensitive)
% into the file comments.
%
% OPT is also an optional parameter with values:
% 	OPT = 1 (default): will look for all comments
% 	OPT = 2: will look only for comment lines
%	OPT = 3: will look anywhere in the file
%
% Example:
% gmat('matrix',which('intro'))
%
%
% Created: 2009-06-23.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = gmat(varargin)

if isnumeric(varargin{1})
	disp('gmat.m: pattern argument must be char')
	error('Bad parameters');
else
	pattern = varargin{1};
end

if nargin == 2
	if        ischar(varargin{2})
		folder = varargin{2};
		method = 1;
	elseif isnumeric(varargin{2})
		folder = pwd;
		method = varargin{2};
	else
		error('Bad parameters');
	end
elseif nargin == 3
	if        ischar(varargin{2}) & isnumeric(varargin{3})
		folder = varargin{2};
		method = varargin{3};	
	elseif isnumeric(varargin{2}) &    ischar(varargin{3})
		folder = varargin{3};
		method = varargin{2};
	else
		disp('gmat.m: there must be one string and one numeric arguments')
		error('Bad parameters');
	end
else % Default:
	folder = pwd;
	method = 1;
end

folder = abspath(folder);
if length(folder)>2
	if strcmp(folder(end-1:end),'.m')
		disp(sprintf('Scanning: %s',folder));
	else
		disp(sprintf('Scanning: %s/*.m',folder));
	end
else
	disp(sprintf('Scanning: %s/*.m',folder));
end

%%% Get m files:
di = dir(folder); 
ifil = 0;
for ii = 1 : size(di,1);
	if ~ di(ii).isdir
		if strfind(lower(di(ii).name),'.m')
			ifil = ifil + 1;
			filL(ifil).name = di(ii).name;
		end
	end
end,clear ii%for ii



if exist('filL','var')
%%% Look for the pattern
il = 0; ipt = 0;
for ii = 1 : size(filL,2)
	fid = fopen(filL(ii).name,'r');
	done = 0;
	fseek(fid,0,'bof');
	foundhere = 0; nl=0;
	while done ~= 1
		tline = fgetl(fid);
		if ~ischar(tline), done=1;end
		tl = tline;
		nl = nl + 1;
		if size(tl,1)~=0 & size(tl,2)~=0
			switch method
				%%%%%%%%%%%%
				case 1 % All comments
					if ~isempty(strfind(tl,'%'))
%					if tl(1) == '%' 
						if isempty(strfind(lower(tl),'guillaumemaze.org')) & isempty(strfind(lower(tl),'copyright')) & isempty(strfind(lower(tl),'created'))
							%disp(tline)
							if strfind(lower(tline),lower(pattern))
								il = il + 1;
								found(il).name  = filL(ii).name;
								found(il).iline = nl;
								found(il).tline = tline;
								foundhere = 1;
							end			
						end
					end
				%%%%%%%%%%%%
				case 2
					if tl(1) == '%' 
						if isempty(strfind(lower(tl),'guillaumemaze.org')) & isempty(strfind(lower(tl),'copyright')) & isempty(strfind(lower(tl),'created'))
							%disp(tline)
							if strfind(lower(tline),lower(pattern))
								il = il + 1;
								found(il).name  = filL(ii).name;
								found(il).iline = nl;
								found(il).tline = tline;
								foundhere = 1;
							end			
						end
					end	
					
				%%%%%%%%%%%%
				case 3
					if isempty(strfind(lower(tl),'guillaumemaze.org')) & isempty(strfind(lower(tl),'copyright')) & isempty(strfind(lower(tl),'created'))
						%disp(tline)
						if strfind(lower(tline),lower(pattern))
							il = il + 1;
							found(il).name  = filL(ii).name;
							found(il).iline = nl;
							found(il).tline = tline;
							foundhere = 1;
						end			
					end
								
			end%switch method
		end %if line ok
	end %while
	if foundhere
		ipt = ipt + 1;
		Mfound(ipt).name = filL(ii).name;
	end
	fclose(fid);
end,clear ii%for ii

%%% DISPLAY
if exist('found','var')
	disp(sprintf('Pattern ''%s'' found %i time(s) over here:',lower(pattern),il))
	for ii = 1 : size(Mfound,2)
		disp(sprintf('%2s %s',' ',strrep(Mfound(ii).name,'.m','')));
		for ij = 1 : size(found,2)
			if strcmp(found(ij).name,Mfound(ii).name)
				disp(sprintf('%10s line %2i>> %s',' ',found(ij).iline,found(ij).tline))
			end
		end%forij 
	end
else
	disp(sprintf('Pattern ''%s'' not found',lower(pattern)))
end


%%%%%%%%%%
else
	disp('No m file over there');
end


end %function


















