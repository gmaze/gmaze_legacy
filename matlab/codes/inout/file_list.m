% file_list Create a file list from a folder
%
% FLIST = file_list(FOLDER_PARENT,[OPTION1,VALUE1,...]);
% 
% Inputs:
%	FOLDER_PARENT (string): path to the folder to scan
%
% Options:
%	WFILE (double): 1 to backup all files, 0 to backup files with known extensions (defined in get_list_ext_ok);
%	NREC (double): depth of the recursive loop into folders (any integer or Inf)
%	EXTE (cell of strings): File extensions to select
%
% Output:
%	FLIST is a cell array:
%	FLIST{:,1}: Complete path to the file
%	FLIST{:,2}: File name
%	FLIST{:,3}: Size (bytes)
%	FLIST{:,4}: Folder to the file
%	FLIST{:,5}: Modification date as a Matlab serial number
%
% Created: 2009-09-25.
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

function flist = file_list(varargin)

% Default parameters:
WFILE = 1;
NREC  = 0;
EXTE  = {}; % All known extension defined here

% Load options:
if nargin >= 2
	if mod(nargin-1,2)~=0
		error('Options must come with their values !')
	else
		for ii = 2 : 2 : nargin-1
			opt = varargin{ii};
			val = varargin{ii+1};
			if isnumeric(val)
				eval(sprintf('%s = %f;',opt,val));
			elseif ischar(val)
				eval(sprintf('%s = ''%s'';',opt,val));
			elseif iscell(val) & opt=='EXTE'
				EXTE = val;
			end
		end
	end
end

if strcmp(varargin{1},'.')
	varargin{1} = pwd;
end

folder_list = {varargin{1}, WFILE, NREC};

% Log:
global diag_screen_default
diag_screen_default.PIDlist = 1;
fid_log = fopen('toto.txt','w');
diag_screen_default.fid = fid_log;
diag_screen_default.forma = '%s\n';


%%%%% Scan folders and get the list of ALL files (absolute path):
ifile = 0; t = now; itot = 0; irej = 0;
for ifold = 1 : size(folder_list,1);
	folder     = abspath(folder_list{ifold,1});
	%diag_screen(sprintf('# Scanning %s ...',folder));
	system(sprintf('/bin/ls -R -A -C -l -L -F %s > .ls',folder));
	
	fid = fopen('.ls');
	thisfold = folder;
	while 1
		tline = fgetl(fid);		
		if ~ischar(tline), break, end
		if length(tline)>1
			if tline(1) == '/'
				thisfold = strrep(tline,':','');
				thisfold = strrep(thisfold,' ','\ ');
			elseif tline(1) ~= 't'
				[file_mode nb_links owner group bytes month day year file] = readthisline(tline);			
				file = file{1};
				if file(end)=='*', file=file(1:end-1);end % The ls command put a * to show it's an executable but we don't care:
				fullpath_to_file = sprintf('%s/%s',thisfold,file);
%				disp(fullpath_to_file)
				
				if folder_list{ifold,3} ~= Inf
					str  = strrep(fullpath_to_file,[folder '/'],'');
					isla = strfind(str,'/');
					
					if length(isla) <= folder_list{ifold,3}
						itot = itot + 1;
						if folder_list{ifold,2} == 1 | scanfileext(file,EXTE)
							ifile = ifile + 1;
							a = dir(fullpath_to_file);
							flist(ifile,1) = {fullpath_to_file};
							flist(ifile,2) = {file};
							flist(ifile,3) = {a.bytes};
							flist(ifile,4) = {thisfold};				
							flist(ifile,5) = {a.datenum};
						else
							irej = irej + 1;
							rejected(irej,1) = {fullpath_to_file};
						end	
					end
				else			
					itot = itot + 1;		
					if folder_list{ifold,2} == 1 | scanfileext(file,EXTE)	
						ifile = ifile + 1;
						a = dir(fullpath_to_file);
						flist(ifile,1) = {fullpath_to_file};
						flist(ifile,2) = {file};
						flist(ifile,3) = {a.bytes};
						flist(ifile,4) = {thisfold};				
						flist(ifile,5) = {a.datenum};
					else	
						irej = irej + 1;
						rejected(irej,1) = {fullpath_to_file};						
					end%if to keep this one
				end%if recursive depth
			end%if this is a file, not a total or path given by ls
		end%if not an empty line
%		if ifile == 10, break; end
	end%while loop over ls output
	fclose(fid);
%	delete('.ls');
end%for ifold

%whos flist
%diag_screen(sprintf('# I found a total of %i files and selected %i among them (%0.1f seconds)',itot,size(flist,1),(now-t)*86400));
%diag_screen(sprintf('%i files were rejected',irej));

fclose(fid_log);
end %function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = scanfileext(filename,EXTE)
	
	% To keep:
	if isempty(EXTE)
		files_ext = get_list_ext_ok;
	else
		files_ext = EXTE;
	end
	
	% To reject:
	files_ext_rej = {'.tar';'.gz';'.tmp';'.dvi';'.log';'.zip'};
	
	% Not a file !
	if filename(end) == '/'
		res = false;
		return
	end
	
	% Archive file:
	if filename(end) == '~'
		res = false;
		return
	end
	
	% Apple Keynote special file:
	% (Exception for .gz file)
	if strcmp(filename,'index.apxl.gz')
		res = true;
		return
	end
	
	% Hidden file:
	if filename(1) == '.'
		res = false;
		return
	end
	
	% does the file has a dot:
	dots = strfind(filename,'.');
	
	% Get the extension:
	if length(dots) >= 1
		ext = filename(dots(end):end);
	else % no dots
		ext = 'none';
	end
	
	% Scan for extensions to keep, if match, return true
	for iok = 1 : length(files_ext)
		if strcmp(files_ext{iok},lower(ext))
			res = true;
			return
		end
	end
	
	% Scan for extensions to remove, if match, return false
	for inotok = 1 : length(files_ext_rej)
		if strcmp(files_ext_rej{inotok},lower(ext))
			res = false;
			return
		end
	end
	
	% if we arrived here, it means the extension is unknown, return false
	res = false;
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function liste = get_list_ext_ok
	
	% Matlab:
	ext_matlab = {'.m';'.mat';'.mexglx';'.fig';'.mexmaci';'.dat'};
	
	% Fortran, C:
	ext_codes = {'.f';'.f90';'.c';'.h';'.p';'.h90';'.h';'.cpp';'.hh';'.in';'.arch'};
	
	% Binaries:
	ext_bin   = {'.b';'.nc';'.cdf'};
	
	% Pictures:
	ext_pict = {'.gif';'.jpeg';'.jpg';'.psd';'.png';'.eps';'.ps';'.pict';'.tiff'};
	
	% Shell Scripts:
	ext_scpt = {'.sh';'.csh';'.py';'.scpt';'.bat'};
	
	% Web:
	ext_web = {'.html';'.htm';'.php';'.cgi';'.js';'.css'};
	
	% Texts:
	ext_txt  = {'.txt';'.readme'};
	
	% LaTeX:
	ext_ltx  = {'.tex';'.bib';'.gloss';'.sty';'.cls'};
	
	% Misc:
	ext_misc = {'.pdf';'.xml';'.tab';'.tmproj';'.cfg'};
	
	% Mac:
	ext_mac = {'.plist';'.app'};
	
	% No extension:
	ext_none = {'none'};
		
	% Form the complete list: 
	liste = [ext_matlab; ext_codes; ext_pict; ext_scpt; ext_web; ext_txt; ext_ltx; ext_misc; ext_mac; ext_bin; ext_none ];

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [file_mode nb_links owner group bytes month day year file] = readthisline(tline);
	[file_mode nb_links owner group bytes month day year ...
	 file0{1} file0{2} file0{3} file0{4} file0{5} file0{6} file0{7} ...
	 file0{8} file0{9} file0{10} file0{11} file0{12} file0{13} file0{14} file0{15}] = ...
		strread(tline,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');

	% If there're blank in the file, we nedd to concat file
	file = file0{1}{1};
	for ii = 2 : length(file0)
		if ~isempty(file0{ii})
			file = [file '\ ' file0{ii}{1}];
		end
	end
	file = {file};
	
end%function


