% TBCONT Audit a directory and create html/wiki pages and a table of content
%
% [] = tbcont(PATH_TO_DIR,[OPTION1,VALUE1,...])
%
% Scan the directory PATH_TO_DIR and create html/wiki pages and table of content for
% matlab script files (*.m).
%
% The function creates under PATH_TO_DIR:
% 	- a tbcont.html file with an index of all .m routines
%		This is not a standlone html file because it has no header and body.
%		It contains a html table to be inserted in any webpage. However, 
%		most modern browsers will support this and display the content.
%	- a 'help' folder with html help file for each routines
%	- a 'wiki' folder with wiki help file for each routines
%	- a Contents.m file with an index of all .m routines
%
% OPTIONS:
%	link_pref (string): Absolute base path to source .m files
%		By default: 'http://guillaumemaze.googlecode.com/svn/trunk/matlab/'
%	link_rel (string): relative path to source .m files from link_pref
%		So that url to source file is: link_pref/link_rel/XXXX.m
%	link_wiki (string): Absolute path to wiki pages
%		By default: 'http://code.google.com/p/guillaumemaze/wiki'
%		All wiki pages are under the same directory PATH_TO_DIR/wiki/
%		Unlike html pages, no subfolders are created.
%	ndepth (integer): Depth of the recursive scan of folders
%		0 means only PATH_TO_DIR/*.m files will be incorporated
%		1 means only PATH_TO_DIR/*.m and PATH_TO_DIR/*/*.m files will be incorporated
%		etc
%		if ndpeth > 0, then url to source file is: link_pref/link_rel/SUBFOLDER/XXXX.m, etc ...
%
% TBCONT.HTML FILE DESCRIPTION:
% 	In tbcont.html, we create a first table 'Quick Links' which 
% 	lists all routines and link them to an url of the source file. 
% 	The url prefix for these links is by default relative to:
%		'http://guillaumemaze.googlecode.com/svn/trunk/matlab/';
% 	and it can be specified in the options list with opts link_rel.
%
% 	Then a second table lists all routines with there h1line as:
%		column 1: link to a wiki page for the routine
%		column 2: the h1line
%		column 3: link to the source file (similar to the one in the 'Quick Links' table)
%
% NOTES:
% - This function aims to be used in tight conjunction with a Google Code project svn repository.
% - If you want to have a clean TOC in Matlab, use function packver to manage packages versions
%
% EXAMPLE:
% Imagine there's one function called toto0.m under PATH_TO_DIR and one function called toto1.m
% under PATH_TO_DIR/test/
%	tbcont(PATH_TO_DIR,'link_rel',myexample);
% will create:
%	PATH_TO_DIR/tbcont.html
%	PATH_TO_DIR/Contents.m
%	PATH_TO_DIR/html/toto0.html
%	PATH_TO_DIR/html/test/toto1.html
%	PATH_TO_DIR/wiki/matlab_myexample_toto0.wiki
%	PATH_TO_DIR/wiki/matlab_myexample_test_toto1.wiki
% and links to source files points to:
%	http://guillaumemaze.googlecode.com/svn/trunk/matlab/myexample/toto0.m
%	http://guillaumemaze.googlecode.com/svn/trunk/matlab/myexample/test/toto1.m
% and links to wiki pages points to:
%	http://code.google.com/p/guillaumemaze/wiki/matlab_myexample_toto0
%	http://code.google.com/p/guillaumemaze/wiki/matlab_myexample_test_toto1
%
% 
% REQUIREMENTS:
%	Matlab function file_list()
%
% Created: 2008-10-30.
% Rev. by Guillaume Maze on 2009-09-28: Added Contents.m creation, ndepth option
% Rev. by Guillaume Maze on 2009-09-25: Added complete help, Handle options, Manage subfolders
% Copyright (c) 2008, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.

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

function varargout = tbcont(varargin)

%- Options and defaults parameters:
if nargin >= 1
	pathd = abspath(varargin{1});
else
	pathd = abspath('~/matlab/codes/');
end
if pathd(end) == '/'; pathd = pathd(1:end-1); end

%- Default parameters 
% The absolute path or url to source files:
link_pref = 'http://guillaumemaze.googlecode.com/svn/trunk/matlab/';

% The relative to link_pref path to source files:
link_rel  = 'routines/'; % tuned for the '~/matlab/routines' folder:

% The absolute path to wiki pages:
link_wiki = 'http://code.google.com/p/guillaumemaze/wiki';

% The prefix to all wiki page files:
pref_wiki = 'matlab';

% The depth of the recursive scan:
ndepth    = Inf;

% Build Contents.m ?
do_contentsm    = 1;
overw_contentsm = 0; % By default we do not overwrite the TOC file

% Build tbcont.html ?
do_tbcont      = 1;

% Build Individual html files under /help ?
do_single_html = 1;

% Build Individual wikie files under /wiki ?
do_single_wiki = 1;

% Display verbose:
verb = false;

%- Load options:
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
			end
		end
	end
end% if 

%- Format path links:
if link_rel(1) == '/', link_rel = link_rel(2:end); end     % Remove any trailing slash in link_rel
pref_wiki = strrep(pref_wiki,'_','');
pref_wiki = sprintf('%s_%s',pref_wiki,strrep(link_rel,'/','_'));
if link_rel(end)  ~= '/',  link_rel = [link_rel '/']; end  % Add slash at the end of link_rel
if link_pref(end) ~= '/',  link_pref = [link_pref '/']; end % Add slash at the end of link_pref
link_pref = sprintf('%s%s',link_pref,link_rel);

%- Screen log:
global tbcont_verbose
tbcont_verbose = verb;

local_disp(sprintf('I will create:'))
if do_contentsm
	local_disp(sprintf('\t%s/Contents.m',pathd))
end
if do_tbcont
	local_disp(sprintf('\t%s/tbcont.html',pathd))
	local_disp(sprintf('Links to source files point to:\n\t%sXXXX.m',link_pref));	
	local_disp(sprintf('Links to wiki pages point to:\n\t%s/%s_XXXX',link_wiki,pref_wiki));
end
if do_single_html
	local_disp(sprintf('Individual HTML pages are here:\n\t%s/help/XXXX.html',pathd));
end
if do_single_wiki
	local_disp(sprintf('Individual wiki pages are here:\n\t%s/wiki/XXXX.wiki',pathd));
end

%%%%%%%%%%%%% Misc
% Blank space:
blk = ' ';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the structure with all required informations about files (TB):
TB = get_TB_struct(pathd,ndepth);

%%% Eventualy reorder the list of files:
% clear it,
% for ij = 1 : size(TB,2)
% 	it(ij) = {TB(ij).name};
% end % Name
% [y,ord] = sort(it); clear y 
ord = 1 : size(TB,2);


%[murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB(end),link_pref,link_rel,link_wiki,pref_wiki,pathd)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create Contents.m
if do_contentsm 

if exist(sprintf('%s/Contents.m',pathd),'file') & overw_contentsm == 0
	a = input(sprintf('\n%s/Contents.m already exists, do you want to overwrite it (y/[n])?',pathd),'s');
	if isempty(a) 
		overw_contentsm = 0;
	elseif strcmp(lower(a),'y')
		overw_contentsm = 1;
	else		
		overw_contentsm = 0;
	end
else	
	overw_contentsm = 1; % Contents.m doesn't exist, we create it
end

if overw_contentsm
	local_disp(sprintf('Creating %s/Contents.m ...',pathd));
	
	global diag_screen_default
	diag_screen_default.PIDlist = [2];
	diag_screen_default.fid = fopen(sprintf('%s/Contents.m',pathd),'w');
	diag_screen_default.forma = '%% %s\n';
	
	try
		% Tips on how to get your toolbox to work with VER:
		%
		%   VER TOOLBOX_DIR looks for lines of the form
		%
		%     % Toolbox Description
		%     % Version xxx dd-mmm-yyyy
		%
		%   as the first two lines of the Contents.m in the directory specified.  
		%   The date cannot have any spaces in it and must use a 2 char day (that
		%   is, use 02-Mar-1997 instead of 2-Mar-1997).	
		packinfo = packver(pathd,'r');
		diag_screen(sprintf('%s',packinfo.Name));
		diag_screen(sprintf('Version %s %s %s',packinfo.Version,packinfo.Release,datestr(packinfo.Date,'dd-mmm-yyyy')));
	end%try
	
	diag_screen(sprintf(''));	
	diag_screen(sprintf('\t\tContents from %s',pathd));
	diag_screen(sprintf(''));
	diag_screen(sprintf('Last update: %s',datestr(now,'yyyy mmmm dd, HH:MM')));
	
	% Start loop over routines:
	for ij = 1 : size(TB,2)
		ifct = ord(ij);
		[murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB(ifct),link_pref,link_rel,link_wiki,pref_wiki,pathd);
		if ij==1, 
			thisr = rpath;
			diag_screen(sprintf(''));
			if ~isempty(rpath)
				diag_screen(sprintf('Files in: %s',rpath));
			end
		end
		if ~strcmp(thisr,rpath)
			thisr = rpath;
			diag_screen(sprintf(''));
			diag_screen(sprintf('Files in: %s',rpath));
		end
		tline = strjust(sprintf('%40s',sprintf('%s%s%s',rpath,strrep(TB(ifct).file,'.m',''))),'left');
		diag_screen(sprintf('\t%s - %s',tline,TB(ifct).def));

	end % for loop	
	
	
	diag_screen(sprintf(''));
	diag_screen(sprintf('This Contents.m file was automatically created using: %s',mfilename('fullpath')));
	diag_screen(sprintf(''));
	
	% Close Contents.m file
	fclose(diag_screen_default.fid);
	
end%if overw_contentsm
end%if do_contentsm


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create tbcont.html
if do_tbcont

local_disp(sprintf('Creating %s/tbcont.html ...',pathd));

global diag_screen_default
diag_screen_default.PIDlist = [2];
fid = fopen(sprintf('%s/tbcont.html',pathd),'w');
diag_screen_default.fid = fid;
diag_screen_default.forma = '%s\n';

% Insert Google toc:
%diag_screen(sprintf('%s','<img src="http://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BTable+of+contents%27%3D16%27f%5Cbf%5Chv%27a%5C%3D123%270%27%3D122%270%27dim%27%5Cbox1%27b%5CDBD9BB%27fC%5CDBD9BB%27eC%5C15%27sk%27%5C%5B%27%5Dh%27a%5CV%5C%3D12%27f%5Cbf%5C%5DV%5Cta%5C%3D124%27%3D0%27%3D123%27%3D297%27dim%27%5C%3D124%27%3D0%27%3D123%27%3D297%27vdim%27%5Cbox1%27b%5Cva%5CFFFEF0%27fC%5CDBD9BB%27eC%5Csites_toc%27i%5Chv-0-0%27a%5C%5Do%5CLauto%27f%5C&amp;sig=b45VIEKOHxw6Obq1kgHGMiw8YnI" id="44064812027861444" style="margin: 5px auto 5px 0pt; display: block; text-align: left;" origsrc="http://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BTable+of+contents%27%3D16%27f%5Cbf%5Chv%27a%5C%3D123%270%27%3D122%270%27dim%27%5Cbox1%27b%5CDBD9BB%27fC%5CDBD9BB%27eC%5C15%27sk%27%5C%5B%27%5Dh%27a%5CV%5C%3D12%27f%5Cbf%5C%5DV%5Cta%5C%3D124%27%3D0%27%3D123%27%3D297%27dim%27%5C%3D124%27%3D0%27%3D123%27%3D297%27vdim%27%5Cbox1%27b%5Cva%5CFFFEF0%27fC%5CDBD9BB%27eC%5Csites_toc%27i%5Chv-0-0%27a%5C%5Do%5CLauto%27f%5C&amp;sig=b45VIEKOHxw6Obq1kgHGMiw8YnI" type="toc" props="width:250" height="300">'));

% Insert last update time:
diag_screen(sprintf('%5s<b>Last update: %s</b>',blk,datestr(now,'yyyy mmmm dd, HH:MM')));

% Insert google widget to share the page:
share = '<img src="https://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BGoogle+Gadget''%3D20''f%5Cv''a%5C%3D0''10''%3D449''0''dim''%5Cbox1''b%5CF6F6F6''fC%5CF6F6F6''eC%5C0''sk''%5C%5B%22AddThis+6+by+TVS!%22''%5D''a%5CV%5C%3D12''f%5C%5DV%5Cta%5C%3D10''%3D0''%3D450''%3D157''dim''%5C%3D10''%3D10''%3D450''%3D157''vdim''%5Cbox1''b%5Cva%5CF6F6F6''fC%5CC8C8C8''eC%5C''a%5C%5Do%5CLauto''f%5C&amp;';
share = sprintf('%s%s',share,'sig=vz20UQShVhTn3xY5t2cX4y69ubs" data-igsrc="http://59.gmodules.com/ig/ifr?mid=59&amp;synd=trogedit&amp;url=http%3A%2F%2Fhosting.gmodules.com%2Fig%2Fgadgets%2Ffile%2F101665793460931063207%2Fcloudsters-add-this01.xml&amp;');
share = sprintf('%s%s',share,'up_ID=ra-4d9393d217d0c596&amp;up_URL=http%3A%2F%2Fcodes.guillaumemaze.org%2Fmatlab&amp;up_Title=Matlab%20scripts&amp;up_Description=A%20list%20of%20useful%20and%20free%20Matlab%20scripts%20&amp;up_BackCol=White&amp;');
share = sprintf('%s%s',share,'up_button1=addthis_button_twitter&amp;up_button2=addthis_button_google_plusone&amp;up_button3=addthis_button_facebook&amp;up_button4=addthis_button_linkedin&amp;up_button5=addthis_button_blogger&amp;');
share = sprintf('%s%s',share,'up_button6=addthis_button_digg&amp;up_iconsize=addthis_32x32_style&amp;h=160&amp;w=450" data-type="ggs-gadget" data-props="align:right;borderTitle:AddThis 6 by TVS!;height:160;');
share = sprintf('%s%s',share,'igsrc:http#58//59.gmodules.com/ig/ifr?mid=59&amp;synd=trogedit&amp;url=http%3A%2F%2Fhosting.gmodules.com%2Fig%2Fgadgets%2Ffile%2F101665793460931063207%2Fcloudsters-add-this01.xml&amp;');
share = sprintf('%s%s',share,'up_ID=ra-4d9393d217d0c596&amp;up_URL=http%3A%2F%2Fcodes.guillaumemaze.org%2Fmatlab&amp;up_Title=Matlab%20scripts&amp;up_Description=A%20list%20of%20useful%20and%20free%20Matlab%20scripts%20&amp;');
share = sprintf('%s%s',share,'up_BackCol=White&amp;up_button1=addthis_button_twitter&amp;up_button2=addthis_button_google_plusone&amp;up_button3=addthis_button_facebook&amp;up_button4=addthis_button_linkedin&amp;');
share = sprintf('%s%s',share,'up_button5=addthis_button_blogger&amp;up_button6=addthis_button_digg&amp;up_iconsize=addthis_32x32_style&amp;h=160&amp;w=450;mid:59;scrolling:auto;showBorder:false;showBorderTitle:null;');
share = sprintf('%s%s',share,'spec:http#58//hosting.gmodules.com/ig/gadgets/file/101665793460931063207/cloudsters-add-this01.xml;up_BackCol:White;up_Description:A list of useful and free Matlab scripts ;up_ID:ra-4d9393d217d0c596;');
share = sprintf('%s%s',share,'up_Title:Matlab scripts;up_URL:http#58//codes.guillaumemaze.org/matlab;up_button1:addthis_button_twitter;up_button2:addthis_button_google_plusone;up_button3:addthis_button_facebook;');
share = sprintf('%s%s',share,'up_button4:addthis_button_linkedin;up_button5:addthis_button_blogger;up_button6:addthis_button_digg;up_iconsize:addthis_32x32_style;view:default;width:450;wrap:true;"');
share = sprintf('%s%s',share,' width="450" height="160" style="display:inline;float:right;margin:5px 0 5px 20px;" class="igm">');
diag_screen(sprintf('%s%s',blk,share));

%%%%%%%%%%%%%%% First create the 'Quick links' list:
diag_screen(sprintf('%5s<center><table><tbody>',blk));
diag_screen(sprintf('%10s<tr>',blk))
diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px;"><center><h3>%s</h3></center></td>',blk,'Quick links:'))
%diag_screen(sprintf('%10s</tr>',blk));
%diag_screen(sprintf('%10s<tr>',blk))
diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px;">',blk));
for ij = 1 : size(TB,2)
	ifct = ord(ij);
	[murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB(ifct),link_pref,link_rel,link_wiki,pref_wiki,pathd);	
	diag_screen(sprintf('%5s<a href="%s" title="%s">%s</a> ',blk,murl,TB(ifct).def,murlname));
end
diag_screen(sprintf('%13s</td>',blk));
diag_screen(sprintf('%10s</tr>',blk));
diag_screen(sprintf('%5s</tbody></table></center>',blk));
diag_screen(sprintf('%5s<br>',blk))

%%%%%%%%%%%%%%% Second, create the table with short descriptions only
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
	[murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB(ifct),link_pref,link_rel,link_wiki,pref_wiki,pathd);	

	% rpath = TB(ifct).rpath; if ~isempty(rpath), if rpath(end) ~= '/', rpath = [rpath '/'];end,if rpath(1) == '/', rpath = rpath(2:end);end,end
	% if ~isempty(rpath)
	% 	pref  = sprintf('%s%s',pref_wiki,strrep(rpath,'/','_'));
	% else
	% 	pref  = sprintf('%s',pref_wiki);
	% end
	% wikipage_link = sprintf('%s/%s%s',link_wiki,pref,lower(strtrim(TB(ifct).name)));
	
	% Create a line in the table:
	diag_screen(sprintf('%10s<tr>',blk))
	
	% Fill columns:
		% Col 1 with routine number:
		diag_screen(sprintf('%13s<td style="border: 0px solid rgb(170, 170, 170); padding: 5px;">',blk));
			diag_screen(sprintf('%18s%d',blk,ij));
		diag_screen(sprintf('%13s</td>',blk))
	
		% Col 2 with link to the wiki page:
		diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px; background-color: %s;">',blk,col(ii).val));
			diag_screen(sprintf('%18s<a href="%s" title="Click to get more details" target="_blank">%s</a>',blk,wurl,strrep(murlname,'.m','')));
		diag_screen(sprintf('%13s</td>',blk))
	
		% Col 3 with the H1line:
		diag_screen(sprintf('%13s<td style="border: 1px solid rgb(170, 170, 170); padding: 5px;; background-color: %s;">',blk,col(ii).val));
			diag_screen(sprintf('%18s%s',blk,TB(ifct).def));
		diag_screen(sprintf('%13s</td>',blk));	

		% Col 4 with the source link .m:		
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

end%if do_tbcont

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create individual html help files
if do_single_html

ii = 1;
col(1).val = '#fff';
col(2).val = '#ddd';

pa = sprintf('%s/help',pathd);
if exist(pa,'dir')
	rmdir(pa,'s');
end
mkdir(pa);

for ifct = 1 : size(TB,2)

	[murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB(ifct),link_pref,link_rel,link_wiki,pref_wiki,pathd);

	% Folder:
	pa = sprintf('%s/help%s',pathd,TB(ifct).rpath);
	if ~exist(pa,'dir'),mkdir(pa);end
	local_disp(sprintf('Creating %s ...',indiv_html));
	
	global diag_screen_default
	diag_screen_default.PIDlist = [2];
	diag_screen_default.fid = fopen(indiv_html,'w');
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
		diag_screen(sprintf('%18s<a href="%s">Download here</a>',blk,murl));
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

end%if do_singlehtml

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Also create individual wiki help files
if do_single_wiki

if ~exist(sprintf('%s/wiki',pathd))
	mkdir(sprintf('%s/wiki',pathd));
else
	delete(sprintf('%s/wiki/*',pathd));
end


ii = 1;
col(1).val = '#fff';
col(2).val = '#ddd';

for ifct = 1 : size(TB,2)
	[murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB(ifct),link_pref,link_rel,link_wiki,pref_wiki,pathd);
	
	local_disp(sprintf('Creating %s ...',indiv_wiki));
	
	global diag_screen_default
	diag_screen_default.PIDlist = [2];
	fid = fopen(indiv_wiki,'w');
	diag_screen_default.fid = fid;
	diag_screen_default.forma = '%s\n';

	diag_screen(sprintf('== %s.m ==',strtrim(TB(ifct).name)));
	diag_screen(sprintf('%s',TB(ifct).def));
	diag_screen(sprintf(''));
	diag_screen(sprintf('[%s Download here]',murl));
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

end%if do_single_wiki


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear global tbcont_verbose
if nargout == 1
	varargout(1) = {TB};
end



end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB-FUNCTIONS

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function TB = get_TB_struct(pathd,ndepth);
	
blk = ' ';
if strcmp(pathd,'.')
	pathd = pwd;
end
flist = file_list(pathd,'WFILE',0,'NREC',ndepth,'EXTE',{'.m'});

ifct = 0;
for ifil = 1 : size(flist,1)
	name = flist{ifil,2};
	
	% Is this file a script or a function ?
	[res fname] = isfunction(flist{ifil,1});
	if res
		%-- Ensure that this is a file we want to share publicly:
		if mtags(flist{ifil,1},'has','public')
			h1line = get_h1line(flist{ifil,1},fname);
	%		local_disp(sprintf('%20s - %s (%s)',fname,h1line,flist{ifil,1}));
		
			fid    = fopen(flist{ifil,1},'r');
			head   = readheader(fid);
			fclose(fid);	
			rpath  = strrep(flist{ifil,4},pathd,'');
			isla   = strfind(rpath,'/');		
		
			ifct = ifct + 1;
			TB(ifct).file = flist{ifil,2};
			TB(ifct).name = fname;
			TB(ifct).def  = h1line;
			TB(ifct).head  = head;
			TB(ifct).path  = flist{ifil,4};
			TB(ifct).date  = flist{ifil,5};
			TB(ifct).rpath = rpath;
			if ~isempty(isla)
				TB(ifct).ilevl = length(isla);
			else
				TB(ifct).ilevl = 0;
			end
		else
			local_disp(sprintf('%s won''t be included in TOC files because it does not contain the tag ''public''',flist{ifil,1}));
		end% if 
		
	else
%		local_disp(sprintf('%s : Not a function !',flist{ifil,1}));
	end

end%for ifil

end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function h1line = get_h1line(file,fname);

	% Get the h1line
	fid = fopen(file,'r');
	h1line = '';
	while 1
	    tline = fgetl(fid);
	    if ~ischar(tline), break, end
		tl = strrep(tline,' ','');
		if ~isempty(tl) & tl(1) == '%'
			tline = strrep(tline,'%','');
			if ~isempty(tline)
				a  = strread(tline,'%s'); 
				a1 = a{1};
				if strcmp(lower(a1),lower(fname))						
					h1line = a{2};
					if length(a)>2,for ii=3:length(a),h1line = [h1line ' ' a{ii}];end;end
				else
					h1line = a{1};
					if length(a)>1,for ii=2:length(a),h1line = [h1line ' ' a{ii}];end;end						
				end
			end
			break
		end
	end
	fclose(fid);
	if isempty(h1line)
		h1line = 'H1LINE MISSING';
	end

end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function [foundfct tline] =  isfunction(file);
	
fid = fopen(file,'r');
foundfct = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), 
		break, 
	end			
	isf = strfind(tline,'function');
	if ~isempty(isf)
		iscom = strfind(tline,'%');
		if ~isempty(iscom)
			tline = tline(1:iscom(1));				
			isf = strfind(tline,'function');
			if ~isempty(isf)
				
				tline = tline(strfind(tline,'function')+9:end);
				if strfind(tline,'=')
					tline = tline(max(strfind(tline,'='))+1:end);
				end
				if strfind(tline,'(')
					tline = tline(1:min(strfind(tline,'('))-1);
				end
				foundfct = 1;
				break
			end
		else
			%
			tline = tline(strfind(tline,'function')+9:end);
			if strfind(tline,'=')
				tline = tline(max(strfind(tline,'='))+1:end);
			end
			if strfind(tline,'(')
				tline = tline(1:min(strfind(tline,'('))-1);
			end	
			foundfct = 1;
			break
		end
	end
end

if foundfct
	tline = strrep(tline,' ','');
	tline = deblank(tline);
	tline = strtrim(tline);
	if isspace(tline(1)),tline = tline(2:end); end
end

fclose(fid);

end%fucntion

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function TB = get_TB_struct0(pathd,ndepth);
	
blk = ' ';
flist = file_list(pathd,'WFILE',0,'NREC',ndepth,'EXTE',{'.m'});

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
				ifct    = ifct + 1;
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
				%local_disp(sprintf('%20s: %s',fctname,fctdefi));
			end
		end % we exclude this one
	catch
		local_disp(sprintf('Error processing file: %s',name))
	end %try		
end %for ifil

end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function head = readheader(fid)
	
done = 0;
fseek(fid,0,'bof');
il = 0;
head = '';
while done ~= 1
	tline = fgetl(fid);
	tl = strtrim(tline); 
	if ~ischar(tline)
		done = 1;
	elseif ~isempty(tl)
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
if isempty(head)
	head = 'NO HEADER';
end

end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function [murl murlname rpath indiv_html indiv_wiki wurl] = get_murl(TB,link_pref,link_rel,link_wiki,pref_wiki,pathd)
	
	% The absolute path or url to source files:
	% link_pref = 'http://guillaumemaze.googlecode.com/svn/trunk/matlab/';
	% The relative to link_pref path to source files:
	% link_rel  = 'routines/'; % tuned for the '~/matlab/routines' folder:
	% The absolute path to wiki pages:
	% link_wiki = 'http://code.google.com/p/guillaumemaze/wiki';
	% The prefix to all wiki page files:
	% pref_wiki = 'matlab';
	
	rpath = TB.rpath;
	if ~isempty(rpath), 
		if rpath(end) ~= '/', 
			rpath = [rpath '/'];
		end,
		if rpath(1) == '/', 
			rpath = rpath(2:end);
		end,
	end
	if strcmp(rpath,pathd),rpath = '';end
	% Rq: link_pref, link_rel and rpath all end with a /
	% not pathd
	murl     = sprintf('%s%s%s',link_pref,rpath,TB.file);
	murlname = sprintf('%s%s',rpath,strtrim(TB.file));
						
	pa = sprintf('%s/help%s',pathd,TB.rpath);
	indiv_html = sprintf('%s/%s.html',pa,lower(strtrim(TB.name)));
	
	
	pa = strrep(strrep(rpath,'/','_'),'@','');
	pa = strrep(pa,'__','_');
	if ~isempty(pa)
		indiv_wiki = sprintf('%s/wiki/matlab_%s_%s%s.wiki',pathd,strrep(link_rel,'/','_'),pa,lower(strtrim(TB.name)));
	else
		indiv_wiki = sprintf('%s/wiki/matlab_%s_%s.wiki',pathd,strrep(link_rel,'/','_'),lower(strtrim(TB.name)));
	end
	indiv_wiki = strrep(indiv_wiki,'__','_');
	indiv_wiki = strrep(indiv_wiki,'__','_');
	
	pa = strrep(strrep(rpath,'/','_'),'@','');
	pa = strrep(pa,'__','_');				
	if ~isempty(pa)
		if pref_wiki(end) ~= '_', pref_wiki = [pref_wiki '_']; end
		pref  = sprintf('%s%s',pref_wiki,pa);
	else
		pref  = sprintf('%s',pref_wiki);
	end
	if pref(end) ~= '_', pref = [pref '_']; end
%	local_disp(pref_wiki),local_disp(pref)
	wurl = sprintf('%s/%s%s',link_wiki,pref,lower(strtrim(TB.name)));
	wurl = strrep(wurl,'@','');
	
	
%	local_disp(sprintf('\t%s/Contents.m',pathd))
%	local_disp(sprintf('\t%s/tbcont.html',pathd))
	% local_disp(sprintf('Links to source file point to:\n\t%s',murl));	
%	local_disp(sprintf('Links to wiki page point to:\n\t%s',wurl));
	% local_disp(sprintf('Individual HTML page is here:\n\t%s',indiv_html));
%	local_disp(sprintf('Individual wiki page is here:\n\t%s',indiv_wiki));
	
end%function

%%%%%%%%%%%%%%% %%%%%%%%%%%%%%% 
function ii = flip(ii);

	ii = ii + 1;
	if ii == 3, ii = 1; end

end%function

function local_disp(str)
	global tbcont_verbose
	if tbcont_verbose == 1
		disp(str);
	end% if 
end%function

function outcome = ispublic(fname)
	
	outcome = false;

	fid = fopen(fname,'r');
	fseek(fid,0,'bof');
	
	done = 0;
	il = 0;
	while done ~= 1
		tline = fgetl(fid);
		tl = strtrim(tline); 
		if ~ischar(tline)
			done = 1;
		elseif ~isempty(tl)
			if length(tl) > 5
				if strcmp(tl(1:4),'%TAG')
					stophere
				end% if 
			end% if 
		else
			done = 1;			
		end% if 

	end%while


end%function

