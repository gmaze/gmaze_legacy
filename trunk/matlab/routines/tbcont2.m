% TBCONT Create matlab table of content from a directory
%
% [] = tbcont(PATH_TO_DIR,[OPTION1,VALUE1,...])
%
% We explore the path PATH_TO_DIR for matlab .m files.
% We then create under PATH_TO_DIR:
% 	- a tbcont.html file with an index of all .m routines
%		This is not a standlone html file because it has no header and body.
%		It contains a html table to be inserted in any webpage. However, 
%		most modern browsers will support this and display the content.
%	- a 'help' folder with html help file for each routines
%	- a 'wiki' folder with wiki help file for each routines
%
% In tbcont.html, we create a first table 'Quick Links' which 
% lists all routines and link them to an url of the source file. 
% The url prefix for these links is by default relative to:
%	'http://guillaumemaze.googlecode.com/svn/trunk/matlab/';
% and it can be specified in the options list with opts link_rel.
% So url will be of the form: link_pref/link_rel
%
% Then a second table lists all routines with there h1line as:
%	column 1: link to a wiki page for the routine
%	column 2: the h1line
%	column 3: link to the source file (similar to the one in the 'Quick Links' table)
%
% This function aims to be used in tight conjonction with a Google Code project.
% 
% Example:
%	tbcont('~/matlab/routines','link_rel','matlab','pref_wiki','routines');
%
% Created: 2008-10-30.
% Rev. by Guillaume Maze on 2009-09-25: Added complete help
% Rev. by Guillaume Maze on 2009-09-25: Handle options
% Rev. by Guillaume Maze on 2009-09-25: Manage subfolders
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = tbcont2(varargin)

if nargin >= 1
	pathd = abspath(varargin{1});
else
	pathd = abspath('~/matlab/routines/');
end

% Default parameters tuned for the '~/matlab/routines' folder:
link_pref = 'http://guillaumemaze.googlecode.com/svn/trunk/matlab/';
link_rel  = 'routines/';
link_wiki = 'http://code.google.com/p/guillaumemaze/wiki';
pref_wiki = 'matlab';

% Load options:
if nargin >= 2
	if mod(nargin-1,2)~=0
		error('Options must come with their values !')
	else
		for ii = 2 : 2 : nargin-1
			eval(sprintf('%s = ''%s'';',varargin{ii},varargin{ii+1}));
		end
	end
end
if link_rel(1) == '/', link_rel = link_rel(2:end); end     % Remove any trailing slash in link_rel
pref_wiki = strrep(pref_wiki,'_','');
pref_wiki = sprintf('%s_%s',pref_wiki,strrep(link_rel,'/','_'));
if link_rel(end)  ~= '/',  link_rel = [link_rel '/']; end  % Add slash at the end of link_rel
if link_pref(end) ~= '/', link_pref = [link_pref '/']; end % Add slash at the end of link_pref
link_pref = sprintf('%s%s',link_pref,link_rel);


disp(sprintf('I will create:\n\t%s/tbcont.html',pathd))
disp(sprintf('where links to source files point to:\n\t%sXXXX.m',link_pref));
disp(sprintf('and links to wiki pages point to:\n\t%s/%s_XXXX',link_wiki,pref_wiki));
disp(sprintf('I will also create individual HTML pages here:\n\t%s/help/XXXX.html',pathd));
disp(sprintf('and wiki pages here:\n\t%s/wiki/XXXX.wiki',pathd));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the structure with all required informations about files (TB):
blk = ' ';
flist = file_list(pathd,'WFILE',0,'NREC',2,'EXTE',{'.m'});

ifct = 0;
for ifil = 1 : size(flist,1)
	name = flist{ifil,2};
	try 
		if isempty(strfind(lower(name),'content'))
			fid = fopen(flist{ifil,1},'r');
			if fid > 0
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
				rpath   = strrep(flist{ifil,4},pathd,'');
				isla    = strfind(rpath,'/');
				ifct = ifct + 1;
				TB(ifct).file  = name;
				TB(ifct).name  = fctname;
				TB(ifct).def   = fctdefi;
				TB(ifct).head  = head;
				TB(ifct).path  = flist{ifil,4};
				TB(ifct).date  = flist{ifil,5};
				TB(ifct).rpath = rpath;
				if ~isempty(isla)
					TB(ifct).ilevl = length(isla);
				else
					TB(ifct).ilevl = 0;
				end
				%disp(sprintf('%20s: %s',fctname,fctdefi));
			end
		end % we exclude this one
	catch
		disp(sprintf('Error processing file: %s',name))
	end %try		
end %for ifil

%%% Eventualy reorder the list of files:
% clear it,
% for ij = 1 : size(TB,2)
% 	it(ij) = {TB(ij).name};
% end % Name
% [y,ord] = sort(it); clear y 
ord = 1 : size(TB,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create tbcont.html
global diag_screen_default
diag_screen_default.PIDlist = [2];
fid = fopen(sprintf('%s/tbcont.html',pathd),'w');
diag_screen_default.fid = fid;
diag_screen_default.forma = '%s\n';

% Insert Google toc:
%diag_screen(sprintf('%s','<img src="http://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BTable+of+contents%27%3D16%27f%5Cbf%5Chv%27a%5C%3D123%270%27%3D122%270%27dim%27%5Cbox1%27b%5CDBD9BB%27fC%5CDBD9BB%27eC%5C15%27sk%27%5C%5B%27%5Dh%27a%5CV%5C%3D12%27f%5Cbf%5C%5DV%5Cta%5C%3D124%27%3D0%27%3D123%27%3D297%27dim%27%5C%3D124%27%3D0%27%3D123%27%3D297%27vdim%27%5Cbox1%27b%5Cva%5CFFFEF0%27fC%5CDBD9BB%27eC%5Csites_toc%27i%5Chv-0-0%27a%5C%5Do%5CLauto%27f%5C&amp;sig=b45VIEKOHxw6Obq1kgHGMiw8YnI" id="44064812027861444" style="margin: 5px auto 5px 0pt; display: block; text-align: left;" origsrc="http://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BTable+of+contents%27%3D16%27f%5Cbf%5Chv%27a%5C%3D123%270%27%3D122%270%27dim%27%5Cbox1%27b%5CDBD9BB%27fC%5CDBD9BB%27eC%5C15%27sk%27%5C%5B%27%5Dh%27a%5CV%5C%3D12%27f%5Cbf%5C%5DV%5Cta%5C%3D124%27%3D0%27%3D123%27%3D297%27dim%27%5C%3D124%27%3D0%27%3D123%27%3D297%27vdim%27%5Cbox1%27b%5Cva%5CFFFEF0%27fC%5CDBD9BB%27eC%5Csites_toc%27i%5Chv-0-0%27a%5C%5Do%5CLauto%27f%5C&amp;sig=b45VIEKOHxw6Obq1kgHGMiw8YnI" type="toc" props="width:250" height="300">'));

% Insert last update time:
diag_screen(sprintf('%5s<b>Last update: %s</b>',blk,datestr(now,'yyyy mmmm dd, HH:MM')));

%%%%%%%%%%%%%%% First create the 'Quick links' list:
diag_screen(sprintf('%5s<center><table><tbody>',blk));
diag_screen(sprintf('%10s<tr>',blk))
diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px;"><center><h3>%s</h3></center></td>',blk,'Quick links:'))
%diag_screen(sprintf('%10s</tr>',blk));
%diag_screen(sprintf('%10s<tr>',blk))
diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px;">',blk));
for ij = 1 : size(TB,2)
	ifct = ord(ij);
%	diag_screen(sprintf('%5s<a href="%s%s" title="%s">%s</a> ',blk,link_pref,TB(ifct).file,TB(ifct).def,lower(strtrim(TB(ifct).name))));
	[murl murlname] = get_murl(TB(ifct),link_pref);
	diag_screen(sprintf('%5s<a href="%s" title="%s">%s</a> ',blk,murl,TB(ifct).def,murlname));
end
diag_screen(sprintf('%13s</td>',blk));
diag_screen(sprintf('%10s</tr>',blk));
diag_screen(sprintf('%5s</tbody></table></center>',blk));
diag_screen(sprintf('%5s<br>',blk))

%%%%%%%%%%%%%%% Second create the table with short descriptions only
if 1
	
ii = 0;
col(1).val = '#fff';
col(2).val = '#ddd';
		
% Start table:	
diag_screen(sprintf('%5s<table><tbody>',blk));

% First line with columns definitions:
	diag_screen(sprintf('%10s<tr>',blk))
		diag_screen(sprintf('%13s<td colspan="2" style="border: 1px solid rgb(170, 170, 170); padding: 25px; font-size:16px;font-weight:bold;">',blk));
			diag_screen(sprintf('%18s%s',blk,'Function Name'));
		diag_screen(sprintf('%13s</td>',blk))
		diag_screen(sprintf('%13s<td colspan="2" style="border: 1px solid rgb(170, 170, 170); padding: 25px; font-size:16px;font-weight:bold;">',blk));
			diag_screen(sprintf('%18s%s',blk,'Description'));
		diag_screen(sprintf('%13s</td>',blk));
	diag_screen(sprintf('%10s</tr>',blk));


% Start loop over routines:
for ij = 1 : size(TB,2)
	ifct = ord(ij);
	ii = flip(ii);	

	rpath = TB(ifct).rpath; if ~isempty(rpath), if rpath(end) ~= '/', rpath = [rpath '/'];end,if rpath(1) == '/', rpath = rpath(2:end);end,end
	pref  = sprintf('%s_%s',pref_wiki,strrep(rpath,'/','_'));
	wikipage_link = sprintf('%s/%s%s',link_wiki,pref,lower(strtrim(TB(ifct).name)));
	
	% Create a line in the table:
	diag_screen(sprintf('%10s<tr>',blk))
	
	% Fill columns:
		% Col 1 with routine number:
		diag_screen(sprintf('%13s<td style="border: 0px solid rgb(170, 170, 170); padding: 5px;">',blk));
			diag_screen(sprintf('%18s%d',blk,ij));
		diag_screen(sprintf('%13s</td>',blk))
	
		% Col 2 with link to the wiki page:
		diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px; background-color: %s;">',blk,col(ii).val));
			diag_screen(sprintf('%18s<a href="%s" title="Click to get more details" target="_blank">%s%s</a>',blk,wikipage_link,rpath,strtrim(TB(ifct).name)));				
		diag_screen(sprintf('%13s</td>',blk))
	
		% Col 3 with the H1line:
		diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px;; background-color: %s;">',blk,col(ii).val));
			diag_screen(sprintf('%18s%s',blk,TB(ifct).def));
		diag_screen(sprintf('%13s</td>',blk));	

		% Col 4 with the source link .m:
		[murl murlname] = get_murl(TB(ifct),link_pref);
		
		diag_screen(sprintf('%13s<td style="border: 0px solid rgb(170, 170, 170); padding: 5px;; background-color: %s;">',blk,col(ii).val));
			diag_screen(sprintf('%18s<a href="%s" title="Download the .m file">.m</a>',blk,murl));
		diag_screen(sprintf('%13s</td>',blk));
	
	diag_screen(sprintf('%10s</tr>',blk));
	% Close line
	
end % for loop

% Close table:
diag_screen(sprintf('%5s</tbody></table>',blk));

end %if 0/1


% Close tbcont.html file
fclose(diag_screen_default.fid);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create individual html help files
ii = 1;
col(1).val = '#fff';
col(2).val = '#ddd';

pa = sprintf('%s/help',pathd);
rmdir(pa,'s');
mkdir(pa);

for ifct = 1 : size(TB,2)

	% Folder:
	pa = sprintf('%s/help%s',pathd,TB(ifct).rpath);
	if ~exist(pa,'dir'),mkdir(pa);end
	global diag_screen_default
	diag_screen_default.PIDlist = [2];
	fid = fopen(sprintf('%s/%s.html',pa,strtrim(TB(ifct).name)),'w');
	diag_screen_default.fid = fid;
	diag_screen_default.forma = '%s\n';

	diag_screen('<html>');
	diag_screen('<head>');
		diag_screen(sprintf('%5s<title>Help: %s</title>',blk,lower(strtrim(TB(ifct).name))));
	diag_screen('</head>');	
	diag_screen('<body>');
		
	ii = flip(ii);	
	diag_screen(sprintf('%5s<center><table><tbody>',blk));	
	
	diag_screen(sprintf('%10s<tr>',blk))
		diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px; background-color: %s;">',blk,col(ii).val));
			diag_screen(sprintf('%18s<h4>%s</h4>%s',blk,strtrim(TB(ifct).name),TB(ifct).def));	
			diag_screen(sprintf('%18s<br><small>Last modified: %s</small>',blk,datestr(TB(ifct).date)));
		diag_screen(sprintf('%13s</td>'));
	diag_screen(sprintf('%10s</tr>',blk));
	diag_screen(sprintf('%10s<tr>',blk));	
	diag_screen(sprintf('%13s<td style="border: 0px solid rgb(170, 170, 170); padding: 5px; background-color: %s;">',blk,col(ii).val));
	[murl murlname] = get_murl(TB(ifct),link_pref);	
		diag_screen(sprintf('%18s<a href="%s">Download here</a>',...
								blk,murl));
	diag_screen(sprintf('%13s</td>',blk))
	diag_screen(sprintf('%10s</tr>',blk));
	
	ii = flip(ii);
	diag_screen(sprintf('%10s<tr>',blk))
	diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px; background-color: %s; font-size:12px;">',blk,col(ii).val));
	diag_screen(sprintf('%18s%s',blk,TB(ifct).head));
	diag_screen(sprintf('%13s</td>',blk));		
	diag_screen(sprintf('%10s</tr>',blk));
	
	ii = flip(ii);
	diag_screen(sprintf('%10s<tr>',blk))
	diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px; background-color: %s; font-size:12px;">',blk,col(ii).val));
	diag_screen(sprintf('%18sLast update: %s<br>',blk,datestr(now,'yyyy mmmm dd, HH:MM')));
	diag_screen(sprintf('%18sCreated by Guillaume Maze<br>',blk));
	diag_screen(sprintf('%18sMore informations at: <a href="http://codes.guillaumemaze.org/matlab">codes.guillaumemaze.org/matlab</a><br>',blk));
	diag_screen(sprintf('%13s</td>',blk));		
	diag_screen(sprintf('%10s</tr>',blk));

	
	diag_screen(sprintf('%5s</tbody></table></center>',blk));
	diag_screen('</body>');
	diag_screen('</html>');
	
	fclose(diag_screen_default.fid);
	
end %for ij




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Also create individual wiki help files
if ~exist(sprintf('%s/wiki',pathd))
	mkdir(sprintf('%s/wiki',pathd));
else
	delete(sprintf('%s/wiki/*',pathd));
end


ii = 1;
col(1).val = '#fff';
col(2).val = '#ddd';

for ifct = 1 : size(TB,2)
%for ifct = 12:12

	global diag_screen_default
	diag_screen_default.PIDlist = [2];
	fid = fopen(sprintf('%s/wiki/matlab_routines_%s.wiki',pathd,lower(strtrim(TB(ifct).name))),'w');
	diag_screen_default.fid = fid;
	diag_screen_default.forma = '%s\n';

	diag_screen(sprintf('== %s.m ==',strtrim(TB(ifct).name)));
	diag_screen(sprintf('%s',TB(ifct).def));
	diag_screen(sprintf(''));
	diag_screen(sprintf('[%s%s Download here]',link_pref,TB(ifct).file));	
	diag_screen(sprintf(''));
	
	diag_screen(sprintf('{{{'));
	file = sprintf('%s/%s',TB(ifct).path,strtrim(TB(ifct).file));
	fid = fopen(file,'r');
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
					diag_screen(sprintf('%s',tline));
					%if il == 20, head = sprintf('%s<br>...',head); done = 1; end				
				end
			end
		else
			done = 1;
		end
	end
	fclose(fid);
	diag_screen(sprintf('}}}'));
	
	diag_screen(sprintf('----'));
	diag_screen(sprintf('Last update: %s',datestr(now,'yyyy mmmm dd, HH:MM')));
	diag_screen(sprintf(''));
	diag_screen(sprintf('Created by Guillaume Maze'));
	diag_screen(sprintf(''));
	diag_screen(sprintf('More informations at: [http://codes.guillaumemaze.org/matlab codes.guillaumemaze.org/matlab]'));

	fclose(diag_screen_default.fid);
	
end %for ij



%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% %%%%%%%%%%%%%%% %%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
if nargout == 1
	varargout(1) = {TB};
end



end%function



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
end%while


end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function [murl murlname] = get_murl(TB,link_pref);
	
	rpath = TB.rpath; 
	if ~isempty(rpath), 
		if rpath(end) ~= '/', 
			rpath = [rpath '/'];
		end,
		if rpath(1) == '/', 
			rpath = rpath(2:end);
		end,
	end
	murl = sprintf('%s%s%s',link_pref,rpath,TB.file);
	murlname = sprintf('%s%s',rpath,strtrim(TB.file));
	
end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function ii = flip(ii);

	ii = ii + 1;
	if ii == 3, ii = 1; end

end%function





