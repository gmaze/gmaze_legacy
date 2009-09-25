% backup Backup disk content to some remote directory
%
% [] = backup(FILE,ACTION)
% 
% 
%
%
% Created: 2009-09-24.
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

function varargout = backup(varargin)


growl('Starting backup');

return

backup_log = 'backup.log';
global diag_screen_default
diag_screen_default.PIDlist = [1 2];
fid_log = fopen(backup_log,'w');
diag_screen_default.fid = fid_log;
diag_screen_default.forma = '%s\n';

diag_screen(sprintf('# Backup start at %s',datestr(now)))
t0 = now;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the list of files to backup

%%%%% List of folders to backup, 
% row 1: is the folder path, 
% row 2: 1 to backup all files, 0 to backup files with known extensions (defined in get_list_ext_ok);
% row 3: depth of the recursive loop into folders (any integer or Inf)
%folder_list = { '~/bin'   , 0, Inf;...
%				'~/matlab', 0, Inf};
folder_list = { '~/matlab',0,2};
%folder_list = { '~/work/Postdoc/write/talk_MITworkshop_walin_map',0,Inf};
%folder_list = { '~/matlab/DODS/win32Install',0,Inf};
%folder_list = { '~/matlab/untitled\ folder',0,Inf};

%%%%% Get the list of files:
file_list = create_file_list(folder_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Now backup files
% Instead of using scp or sftp (we can't because we're not allowed to create directories remotely),
% we use sshfs and mount the remote disk localy, simple cp and mkdir do the job then
%diag_screen(sprintf('Start backing up files to X'));
%t = now;

%%%%%%%%%%%%%%%%%%%%%% First, set up the backup disk:
sshfs_location       = '/Users/gmaze/bin/sshfs';
backup_username      = 'gmaze';
backup_machine       = 'armen.ifremer.fr';
backup_destination   = '/home1/armen/perso/gmaze/backupMAC';
backup_mountingpoint = '/Users/gmaze/Volumes/backup';
diag_screen(sprintf('# Backup will be here -> %s:%s',backup_machine,backup_destination));
diag_screen(sprintf('# The backup size is: %0.2f Mo',sum(cell2mat(file_list(:,3)))*1e-6 ));

diag_screen(sprintf('# Mounting backup disk with sshfs ...'));
sshfs_command = sprintf('%s %s@%s:%s %s -oreconnect,volname=backup',sshfs_location,backup_username,backup_machine,backup_destination,backup_mountingpoint);
diag_screen(sprintf('# %s',sshfs_command));
if ~exist(backup_mountingpoint,'dir')
	mkdir(backup_mountingpoint);
end
[status,result] = system(sshfs_command);
if status == 0
	diag_screen('# Backup disk mounted correctly');
else
	diag_screen(result)
	error('Couldn''t mount backup disk, please check your installation of sshfs');
end

%%%%%%%%%%%%%%%%%%%%%% Next, perform the backup:
diag_screen('# Backup in progress ...');
diag_screen(sprintf('# Local | Remote | Date Local'),2,fid_log,'%s\n');
h = waitbar(0,'Backup in progress ...');
ierr = 0;
for ifile = 1 : size(file_list,1)
	waitbar(ifile/size(file_list,1),h);
	file_here    = file_list{ifile,1};
	file_there   = sprintf('%s%s',backup_mountingpoint,file_list{ifile,1});
	folder_there = sprintf('%s%s',backup_mountingpoint,file_list{ifile,5});
	% Manage blank space:
	file_here    = strrep(file_here,'\\','\\\\');
	file_there   = strrep(file_there,'\\','\\\\');
	folder_there = strrep(folder_there,'\ ',' ');

	% Do no overwride if similar files:
	d0 = dir(strrep(file_here,'\',''));
	d1 = dir(strrep(file_there,'\',''));
	if ~isempty(d1)
		if d0.datenum == d1.datenum & d0.bytes == d1.bytes
			skip = 1;
			diag_screen(sprintf('# skip %s',file_here),2,fid_log,'%s\n');				
		else 
			if d1.datenum > d0.datenum
				diag_screen(sprintf('# backup file more recent than file to backup ! %s',file_there),[1 2],fid_log,'%s\n');
			end
			skip = 0;
		end
	else
		skip = 0;
	end
	
	% Copy file:
	if skip == 0
		diag_screen(sprintf('# backup %s',file_here),2,fid_log,'%s\n');
		if ~exist(folder_there,'dir')
			mkdir(folder_there);
		end
		cp_command = sprintf('\\cp -p %s %s',file_here,file_there);
%		diag_screen(sprintf('%s | %s | %12s',file_here,file_there,datestr(file_list{ifile,6},'yyyymmddHHMM')),2,fid_log,'%s\n');	
		[status,result] = system(cp_command);
		if status ~= 0
			ierr = ierr + 1;
			err_list(ierr,1) = {file_here};
			err_list(ierr,2) = {file_there};
			err_list(ierr,3) = {cp_command};
			err_list(ierr,4) = {result};
		end
	end
end%for ifile
close(h);

if ierr ~= 0
	diag_screen(sprintf('# I encountered %i error(s) when performing these commands:',ierr));
	for ii = 1 : size(err_list,1)
		diag_screen(sprintf('# %s\n%s',err_list{ii,3},err_list{ii,4}));
	end%for ii
else
	diag_screen('# Backup fully successful');
end

%%%%%%%%%%%%%%%%%%%%%% Last, unmount the backup disk
diag_screen(sprintf('# Unmounting %s ...',backup_mountingpoint));
[status,result] = system(sprintf('umount %s',backup_mountingpoint));
if status == 0
	diag_screen('# Backup disk unmounted correctly');
else
	diag_screen('# Couldn''t unmount backup disk');
	diag_screen(result)
end

diag_screen(sprintf('# Backup end (%0.2f seconds)',(now-t0)*86400));
fclose(fid_log);
end %function



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file_list = create_file_list(folder_list);
	
%%%%% Scan folders and get the list of ALL files (absolute path):
ifile = 0; t = now; itot = 0; irej = 0;
for ifold = 1 : size(folder_list,1);
	folder     = abspath(folder_list{ifold,1});
	diag_screen(sprintf('# Scanning %s ...',folder));
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
				
				if folder_list{ifold,3} ~= Inf
					str  = strrep(fullpath_to_file,[folder '/'],'');
					isla = strfind(str,'/');
					if length(isla) <= folder_list{ifold,3}
						itot = itot + 1;
						if folder_list{ifold,2} == 1 | scanfileext(file)
							ifile = ifile + 1;
							file_list(ifile,1) = {fullpath_to_file};
							file_list(ifile,2) = {file};
							file_list(ifile,3) = {str2num(bytes{1})};
							file_list(ifile,4) = {folder};
							file_list(ifile,5) = {thisfold};							
							file_list(ifile,6) = {datenum([day{1} '-' month{1} '-' year{1}])};
						else
							irej = irej + 1;
							rejected(irej,1) = {fullpath_to_file};
						end	
					end
				else			
					itot = itot + 1;		
					if folder_list{ifold,2} == 1 | scanfileext(file)	
						ifile = ifile + 1;
						file_list(ifile,1) = {fullpath_to_file};
						file_list(ifile,2) = {file};
						file_list(ifile,3) = {str2num(bytes{1})};
						file_list(ifile,4) = {folder};
						file_list(ifile,5) = {thisfold};
						file_list(ifile,6) = {datenum([day{1} '-' month{1} '-' year{1}])};
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
	delete('.ls');
end%for ifold

%whos file_list
diag_screen(sprintf('# I found a total of %i files and selected %i among them to backup (%0.1f seconds)',itot,size(file_list,1),(now-t)*86400));
%diag_screen(sprintf('%i files were rejected',irej));

end%function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = scanfileext(filename)
	
	% To keep:
	files_ext     = get_list_ext_ok;
	
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dlist = dirthis1(pathe)
	d = dir(pathe);
	ii = 0;
	for id = 1 : length(d)
		if d(id).isdir & ~strcmp(d(id).name,'.') & ~strcmp(d(id).name,'..') 
			ii = ii + 1;
			dlist(ii) = {sprintf('%s/%s',pathe,d(id).name)};
		end
	end%for id
	if exist('dlist')
		dlist = dlist';
	else 
		dlist = {};
	end
end%function

















