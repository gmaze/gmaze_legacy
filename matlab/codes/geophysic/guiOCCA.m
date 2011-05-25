% guiOCCA GUI to OCCA dataset
%
% [] = guiOCCA()
% 
% Graphical User Interface to hlpe create scripts for
% Integral Layer Volume Budget (ILVB) diagnostics.
%
%
% Created: 2008-12-12.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = guiOCCA(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GUI Style:
if 1
itheme = 1;
switch itheme
	case 1 % Classic
		% General Back Ground color
		bgcolor = [1 1 1]*0.702;		
		% Text color:
		ttcolor = [0 0 0]; 
		%
		fgcolor = bgcolor;
	case 2 % Light over dark
		bgcolor = [0 128 255]/255; % Medium Blue
		bgcolor = [220 20 60]/255; % Dark red
		bgcolor = [0 0 103]/255; % Dark blue
		fgcolor = [0 128 255]/255;
		ttcolor = [1 1 1]*.8;
	case 3 % Dark over light
		bgcolor = 1 - [0 0 103]/255; % Dark blue
		fgcolor = 1- [0 128 255]/255;
		ttcolor = 1 -[1 1 1]*.8;
end
end
%bgcolor='r';
%fgcolor='r';
%ttcolor='r';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the GUI window:
% Check if it already exists:
ch  = get(0,'Children');
ich = findobj(ch,'Tag','ILVBgui');
if ~isempty(ich)
	close(find(ch==ich));
end
fgui = builtin('figure');

set(fgui,'Tag','ILVBgui');
set(fgui,'visible','off');
set(fgui,'menubar','none');
set(fgui,'color',bgcolor);
gui_w = 600;
gui_h = 500;
%set(fgui,'position',[100 65 gui_w gui_h]);
%set(fgui,'position',[100 510 gui_w gui_h]);
set(fgui,'position',[10 50 gui_w gui_h]);
set(fgui,'resize','off')
set(fgui,'name','Version 1.0','NumberTitle','off');

% Title:
title_str = 'OCCA (Version 1.0 Beta)';
set(fgui,'name',title_str);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INIT THE SETUP
setup = init_setup;
guidata(fgui,setup);
[lon lat dpt] = load_axis;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE THE MAP:
%hmap = uipanel('Parent',fgui,'Title','Select a region','fontweight','bold',...
%             'Position',[.01 .58 .98 .4],'backgroundcolor',bgcolor,'Units','normalized','Tag','DomainPanel');
hmap = uipanel('Parent',fgui,'Title','Select a region','fontweight','bold','Units','pixels',...
             'Position',[5 190 gui_w-10 305],'backgroundcolor',bgcolor,'Tag','DomainPanel','foregroundcolor',ttcolor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT THE OCCA CLIM SST:
ah = axes('Parent',hmap,'Units','pixels','Position',[20 20 (gui_w-10)/1.5 200],'Tag','map','color',ttcolor);
if ~exist('guiOCCA_sst.mat','file')
	sst = load_climOCCA('sst','y');
	save('guiOCCA_sst.mat','sst');
else
	load guiOCCA_sst.mat
end
sst(isnan(sst)) = 9999;
lon = setup.lon;
lat = setup.lat;
cmap = jet; cmap(end,:) = [1 1 1]; colormap(cmap);
p=imagesc(lon,lat,sst); caxis([0 40]); set(gca,'ydir','normal');
shading flat;axis([lon(1) lon(end) lat(1) lat(end)]);box on
%hold on;[cs,h]=contour(lon,lat,sst,[0:1:30]);set(h,'edgecolor','k');
%line([lon(1) lon(end) lon(end) lon(1) lon(1)],[lat(1) lat(1) lat(end) lat(end) lat(1)],'Tag','boxmap');
set(ah,'xtick',[0:30:360],'ytick',[-80:10:80],'fontsize',7,'xcolor',ttcolor,'ycolor',ttcolor);
th = title(''); set(th,'Tag','maptitle','fontsize',10,'color',ttcolor);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE 4 BOXES TO ENTER THE SUBDOMAIN POSITION:
eth_w = 50; eth_h = 20; % Dimensions of coord text boxes
eth_pivot = [10+(gui_w-10)/1.5+20+eth_w 200+20-eth_h*3]; % Centering point, also use to align other button and region list
bgcolor2 = [1 1 1]*1;
bgcolor = [1 1 1]*.5;

eth_title = uicontrol('Parent',hmap,'Style','text','backgroundcolor',bgcolor,'foregroundcolor',ttcolor,...
                'String','> Enter coordinates:','Horizontalalignment','left',...
                'Position',[eth_pivot(1)-eth_w eth_pivot(2)-eth_h 3*eth_w eth_h*4],'Units','pixels','Tag','CoordTitle');
set(eth_title,'fontweight','normal','fontsize',11);
ethW = uicontrol('Parent',hmap,'Style','edit','Units','pixels','Tag','Xwest',...
                'String',num2str(setup.x1),'Callback',{@edit_domain},...
                'Position',[eth_pivot(1)-eth_w eth_pivot(2) eth_w eth_h],'backgroundcolor',ttcolor,'foregroundcolor',bgcolor);
ethS = uicontrol('Parent',hmap,'Style','edit','Units','pixels','Tag','Ysouth',...
                'String',num2str(setup.y1),'Callback',{@edit_domain},...
                'Position',[eth_pivot(1) eth_pivot(2)-eth_h eth_w eth_h],'backgroundcolor',ttcolor,'foregroundcolor',bgcolor);
ethE = uicontrol('Parent',hmap,'Style','edit','Units','pixels','Tag','Xeast',...
                'String',num2str(setup.x2),'Callback',{@edit_domain},...
                'Position',[eth_pivot(1)+eth_w eth_pivot(2) eth_w eth_h],'backgroundcolor',ttcolor,'foregroundcolor',bgcolor);
ethN = uicontrol('Parent',hmap,'Style','edit','Units','pixels','Tag','Ynorth',...
                'String',num2str(setup.y2),'Callback',{@edit_domain},...
                'Position',[eth_pivot(1) eth_pivot(2)+eth_h eth_w eth_h],'backgroundcolor',ttcolor,'foregroundcolor',bgcolor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE THE Z-AXIS CHOICE
ethZ_title = uicontrol('Parent',hmap,'Style','text',...
                'String','> Pick 2 levels:','Horizontalalignment','left',...
                'Position',[eth_pivot(1)-eth_w eth_pivot(2)-eth_h*3 3*eth_w eth_h*1.8],'Units','pixels','Tag','ztitle','backgroundcolor',bgcolor,'foregroundcolor',ttcolor);
set(ethZ_title,'fontweight','normal','fontsize',11);
ethZ1 = uicontrol('Parent',hmap,'Style','popupmenu','horizontalalignment','left',...
                'String',fix(dpt*10)/10,'Tag','zlist1',...
                'Max',1,'Min',1,'Value',setup.iz1,'Callback',{@update_depth1},...
                'Units','pixels','Position',[eth_pivot(1)-eth_w*.8 eth_pivot(2)-eth_h*3 eth_w eth_h],'backgroundcolor',ttcolor,'foregroundcolor',bgcolor);
ethZ2 = uicontrol('Parent',hmap,'Style','popupmenu','horizontalalignment','left',...
                'String',fix(dpt*10)/10,'Tag','zlist2',...
                'Max',1,'Min',1,'Value',setup.iz2,'Callback',{@update_depth2},...
                'Units','pixels','Position',[eth_pivot(1)+eth_w*.8 eth_pivot(2)-eth_h*3 eth_w eth_h],'backgroundcolor',ttcolor,'foregroundcolor',bgcolor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE THE PRE-SELECTED REGION LIST:
lbh_title = uicontrol('Parent',hmap,'Style','text','Tag','PredefListTitle','backgroundcolor',bgcolor,'foregroundcolor',ttcolor,...
                'String','> Or choose a region:','Horizontalalignment','left',...
                'Position',[eth_pivot(1)-eth_w eth_pivot(2)-eth_h*5 3*eth_w eth_h*1.8],'Units','pixels');
set(lbh_title,'fontweight','normal','fontsize',11);
lbh_region = uicontrol('Parent',hmap,'Style','popupmenu','Units','normalized','Horizontalalignment','left',...
			                'String',predef_regionlist,'Max',1,'Min',0,'units','pixels',...
			                'Value',2,'Position',[eth_pivot(1)-eth_w eth_pivot(2)-eth_h*5 3*eth_w eth_h],...
							'Callback',{@predef_region_and_plot},'Tag','PredefList','backgroundcolor',ttcolor,'foregroundcolor',bgcolor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE THE REFRESH REGION BUTTON
pbh_region = uicontrol('Parent',hmap,'Style','pushbutton','String','> Update Region','Units','pixels','Horizontalalignment','center',...
                'Position',[eth_pivot(1)-eth_w eth_pivot(2)-eth_h*6 3*eth_w eth_h*1],'Callback',{@drawbox},'Tag','UpdateDomainbutton','backgroundcolor',ttcolor,'foregroundcolor',bgcolor);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE THE CONTROL PANEL:
hcont = uipanel('Parent',fgui,'Title','Control Panel','fontweight','bold','Units','pixels',...
             'Position',[5 5 gui_w-10 110],'backgroundcolor',bgcolor,'Tag','ContPanel','backgroundcolor',bgcolor,'foregroundcolor',ttcolor);

hcont_extq = uicontrol('Parent',hcont,'Style','pushbutton','String','Create scripts to extract fields',...
				'Units','pixels','Horizontalalignment','center',...
                'Position',[5 70 160 20],'Callback',{@create_extract_code},'Tag','extq_button','backgroundcolor',ttcolor,'foregroundcolor',bgcolor);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE THE MENU BAR:
mhABOUT = uimenu('Parent',fgui,'Label','ILVB','Tag','MENU1');
uimenu('Parent',mhABOUT,'Label','About','Enable','off');
uimenu('Parent',mhABOUT,'Label','Preferences','Callback',{@show_pref},'Accelerator','p');

mhSETUP = uimenu(fgui,'Label','Budget setup','Enable','off','Tag','MENU2');
uimenu('Parent',mhSETUP,'Label','Load a setup');
uimenu('Parent',mhSETUP,'Label','Save this setup');

mhHELP = uimenu('Parent',fgui,'Label','Help','Enable','off','Tag','MENU3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Execute at startup once everything's loaded
update_maptitle(th,setup.z1,setup.z2);
drawbox(ah); % 
update_depth1(ah);
update_depth2(ah);

%%%%%%%%%%%%%%%% Add the tool to the path:
if 0
	here = pwd;
	dir1 = sprintf('%s',strrep(here,'gui','step1'));
	dir2 = sprintf('%s',strrep(here,'gui','step2'));
	dir3 = sprintf('%s',strrep(here,'gui','extra'));
	addpath(dir1,dir2,dir3);
	clear dir1 dir2 dir3 here
end

%%%%%%%%%%%%%%%% Apply the color style:
%applytheme(fgui);

%%%%%%%%%%%%%%% Finaly reveal the GUI:
%movegui(fgui,'center')
set(fgui,'visible','on');
if nargout ==1 
	varargout(1) = {fgui};
end

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREFERENCES PANEL  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function show_pref(hObject,eventdata)

mhABOUT = get(hObject,'Parent');
fgui = get(mhABOUT,'Parent');
posi = get(fgui,'position');	
w = 2/3*posi(3);
h = 2/3*posi(4);

%%%%%%%%%%%% CREATE THE GUI FOR PREFERENCES:
bgcolor = [1 1 1]*0.702;
fguipref = builtin('figure');
set(fguipref,'Tag','ILVBgui_pref');
set(fguipref,'visible','off');
set(fguipref,'menubar','none');
set(fguipref,'color',bgcolor);
set(fguipref,'position',[posi(1)+(posi(3)-w)/2 posi(2)+(posi(4)-h)/2 w h]);
set(fguipref,'resize','off');
set(fguipref,'NumberTitle','off')
title_str = 'ILVB';
set(fguipref,'name',title_str);

mhABOUT_pref = uipanel('Parent',fguipref,'Title','Preferences','fontweight','bold','Units','pixels','fontsize',18,...
             'Position',[5 5 w-10 h-10],'backgroundcolor',bgcolor,'Tag','PrefPanel','Visible','on');

habout_pref_done = uicontrol('Parent',mhABOUT_pref,'Style','pushbutton','String','Save and Close',...
				'Units','pixels','Horizontalalignment','center',...
                'Position',[w/2-100 5 100 20],'Callback',{@save_pref},'Tag','savepref_button');

habout_pref_discard = uicontrol('Parent',mhABOUT_pref,'Style','pushbutton','String','Discard',...
				'Units','pixels','Horizontalalignment','center',...
                'Position',[w/2 5 100 20],'Callback',{@discard_pref},'Tag','discardpref_button');

habout_pref_scptdel = uicontrol('Parent',mhABOUT_pref,'Style','checkbox','String','Systematically delete script files',...
					'Units','pixels','Horizontalalignment','center',...
	                'Position',[5 h-50 200 20],'Tag','script_delete');

load_pref(fguipref);
set(fguipref,'visible','on');

%%%%%%%%%%%% 
function save_pref(hObject,eventdata)

mhABOUT_pref = get(hObject,'Parent');
fguipref 	 = get(mhABOUT_pref,'Parent');
fguipref_ch	 = get(fgui,'Children');
mhABOUT_pref_ch = get(mhABOUT_pref,'Children');

% Load preferences:
pref = load('guiOCCA_preferences.mat');
data = pref.data;

% Update them:
ch = findobj(mhABOUT_pref_ch,'Tag','script_delete');
data.script_delete = 1 - get(ch,'Value');

% Save and close
save('guiOCCA_preferences.mat','data');
discard_pref(hObject,eventdata);

end

%%%%%%%%%%%% 
function discard_pref(hObject,eventdata)

close(get(get(hObject,'Parent'),'Parent'));

end %function

%%%%%%%%%%%% 
function load_pref(hObject)

% Load preferences:
pref = load('guiOCCA_preferences.mat');
data = pref.data; clear pref

% Update the panel:
set(habout_pref_scptdel,'Value',1 - data.script_delete);

end % end function


allthetime(hObject,eventdata)
end % function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function varargout = init_setup(varargin)

[lon lat dpt] = load_axis;
setup.lon = lon;
setup.lat = lat;
setup.dpt = dpt;

setup.x1 = 110.5; setup.y1 = 9.5;
setup.x2 = 184.5; setup.y2 = 66.5;
setup.z1 = -5;    setup.z2 = -634.7;
setup.iz1 = find(setup.dpt<=setup.z1,1,'first');
setup.iz2 = find(setup.dpt<=setup.z2,1,'first');
setup.ix1 = find(setup.lon>=setup.x1,1,'first');
setup.ix2 = find(setup.lon>=setup.x2,1,'first');
setup.iy1 = find(setup.lat>=setup.y1,1,'first');
setup.iy2 = find(setup.lat>=setup.y2,1,'first');

setup.path_occa   = '~/data/OCCA/r2/daily/';
setup.path_output = '~/data/OCCA/Tlayer_budget/domains/r2/';

setup.extlist = [1:7];
setup.bdglist = [];

setup.THETAlow = 16;
setup.THETAhig = 19;
setup.THETAbin = 0.5;

setup.tim = 1;

setup.Rfact = 12;
setup.Rfdw  = 3;
setup.dsc = 1;
setup.rec = 1;

if nargout == 1
	varargout(1) = {setup};
end	

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function create_extract_code(hObject,eventdata);

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);
subdomain = [setup.ix1 setup.ix2 setup.iy1 setup.iy2 setup.iz1 setup.iz2];
pref = load('guiOCCA_preferences.mat'); data = pref.data; clear pref
confirm = data.script_delete;

pathi = setup.path_occa;
patho = sprintf('%s/dom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d/LRfiles/',setup.path_output,subdomain);

par(1).name = 'PATHI';
par(1).fields(1).name = 'pathi';
par(1).fields(1).val  = sprintf('''%s'';',pathi);
par(2).name = 'PATHO';
par(2).fields(1).name = 'patho';
par(2).fields(1).val  = sprintf('''%s'';',patho);
par(3).name = 'DOMAIN';
par(3).fields(1).name = 'subdomain';
par(3).fields(1).val  = sprintf('[%i %i %i %i %i %i];',subdomain);

pat1 = sprintf('%s/dom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d/scripts/',setup.path_output,subdomain);
if ~exist(pat1,'dir'), mkdir(pat1); end
pat = sprintf('%s/dom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d/scripts/extract_this_subdomain.m',setup.path_output,subdomain);

try 

	if confirm == 1
		s = input(sprintf('Do you want to clear the directory ([y]/n)?:\n%s/\n',pat1),'s');
		if isempty(s) | lower(s)=='y' 
			system(sprintf('\\rm %s/ExtD_set*',pat1));
		end
	else
		system(sprintf('\\rm %s/*',pat1));	
	end

	% First we create the matlab code to extract fields with tuned parameters:
	fprintf('\nCreate code from template ...\n');	
	create_code('extract_subdomain_template.m',par,pat,confirm);
	fprintf('Done\n');

	% Then we create the scripts (shell and SGE queue) to launch the computation:
	fprintf('Create queue scripts to extract fields ...\n');	
	scripts_extract_fields(hObject,eventdata);
	fprintf('Done\n');

	%msgbox(sprintf('Scripts created successfuly\nGo to:\n%s',pat1),'Success','modal');
	fprintf('All scripts to extract your fields are here:\n%s\n',pat1);
catch
	disp('We encountered the following error when creating the code:')
	la = lasterror;
	la.message
end	

allthetime(hObject,eventdata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function scripts_extract_fields(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);
subdomain = [setup.ix1 setup.ix2 setup.iy1 setup.iy2 setup.iz1 setup.iz2];
pref = load('guiOCCA_preferences.mat'); data = pref.data; clear pref
confirm = data.script_delete;

% Create script files:
pat 	= sprintf('%sdom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d/',setup.path_output,subdomain);
workdir = strcat(pat,'scripts');

% We look for the absolute path of matlab:
m = which('plot');
m = m(strfind(m,'(')+1:strfind(m,')')-1); 
m = strrep(m,'toolbox/matlab/graph2d/plot','bin');
di = dir(sprintf('%s%s%s',m,m(1),'matlab'));
if strcmp(di.name,'matlab')
	matlabpath = strcat(m,m(1),'matlab');
else
	errordlg(sprintf('We couldn''t get the absolute path of Matlab,\nlook at function extract_fields in launch_gui to help me'),'Internal error','modal')		
end
klist = setup.extlist;

try 
	create_queue_scripts(workdir,matlabpath,klist,confirm);
catch
	disp('We encountered the following error:')
	la = lasterror;
	la.message
end

allthetime(hObject,eventdata);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function setrec(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
rec = get(hObject,'String');	
if rec ~= 0 | rec ~= 1
	errordlg('Record must be 0 or 1','Bad Input','modal')		
	% Keep text box unchanged
	set(hObject,'String',num2str(setup.rec));
else	
	% Update setup:
	setup.rec = str2num(rec);
	guidata(fgui,setup);
end

allthetime(hObject);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function setdsc(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
dsc = get(hObject,'String');	
if dsc ~= 0 | dsc ~= 1
	errordlg(sprintf('Screen \n(display screen informations during interpolation)\n must be 0 or 1'),'Bad Input','modal')		
	% Keep text box unchanged
	set(hObject,'String',num2str(setup.dsc));	
else
	% Update setup:
	setup.dsc = str2num(dsc);
	guidata(fgui,setup);
end

allthetime(hObject);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function setrfdw(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);
rfact = setup.Rfact;

% Read new value:
rfdw = get(hObject,'String');
if rem(rfact,str2num(rfdw)) ~= 0
	errordlg('Downscaling factor must be a divider of the Interpolation factor','Bad Input','modal')
	% Keep text box unchanged
	set(hObject,'String',num2str(setup.Rfdw));	
else	
	% Update setup:
	setup.Rfdw = str2num(rfdw);
	guidata(fgui,setup);
end
allthetime(hObject);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function setrfact(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
rfact = get(hObject,'String');	

% Update setup:
setup.Rfact = str2num(rfact);
guidata(fgui,setup);

allthetime(hObject);
end	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function update_time(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
itim = get(hObject,'Value');

% Update setup:
setup.tim = itim;
guidata(fgui,setup);


allthetime(hObject);
end	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function tim = timelabel

ii = 0;
ii = ii + 1; tim(ii) = {'Year'};
ii = ii + 1; tim(ii) = {'JFM'};
ii = ii + 1; tim(ii) = {'JJA'};
ii = ii + 1; tim(ii) = {'Jan'};
ii = ii + 1; tim(ii) = {'Feb'};
ii = ii + 1; tim(ii) = {'Mar'};
ii = ii + 1; tim(ii) = {'Apr'};
ii = ii + 1; tim(ii) = {'Jun'};
ii = ii + 1; tim(ii) = {'Jul'};
ii = ii + 1; tim(ii) = {'Aug'};
ii = ii + 1; tim(ii) = {'Sep'};
ii = ii + 1; tim(ii) = {'Oct'};
ii = ii + 1; tim(ii) = {'Nov'};
ii = ii + 1; tim(ii) = {'Dec'};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function settbin(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
bin = get(hObject,'String');	

% Update setup:
setup.THETAbin = str2num(bin);
guidata(fgui,setup);

allthetime(hObject);
end	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function sett2(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
t2 = get(hObject,'String');	

% Update setup:
setup.THETAhig = str2num(t2);
guidata(fgui,setup);

allthetime(hObject);
end	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function sett1(hObject,eventdata)

% Load the setup
hpar  = get(hObject,'Parent');	
fgui  = get(hpar,'Parent');	
setup = guidata(fgui);

% Read new value:
t1 = get(hObject,'String');	

% Update setup:
setup.THETAlow = str2num(t1);
guidata(fgui,setup);

allthetime(hObject);
end	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function update_bdglist(hObject,eventdata)

% Load the setup
hbdg  = get(hObject,'Parent');	
fgui  = get(hbdg,'Parent');	
setup = guidata(fgui);

% Load new fields to extract:
selected = get(hObject,'Value');

% Update setup:
setup.bdglist = selected;
guidata(fgui,setup);	

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function copyext2bdg(hObject,eventdata)

% Load the setup
hbdg   = get(hObject,'Parent');	
fgui   = get(hbdg,'Parent');	
fgui_ch = get(fgui,'Children');
setup  = guidata(fgui);

% Load new fields to budget from list of extracted fields:
hfldext  = findobj(fgui_ch,'Tag','ExtFldPanel');
hfldextl = findobj(hfldext,'Tag','EList');
selected = get(hfldextl,'Value');

% Update panel list:
hbdg  = findobj(fgui_ch,'Tag','BdgPanel');
hfldbdgl = findobj(hbdg,'Tag','BList');
set(hfldbdgl,'Value',selected);

% Update setup:
setup.bdglist = selected;
guidata(fgui,setup);	

allthetime(hObject);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function update_extlist(hObject,eventdata)

% Load the setup
hfldext = get(hObject,'Parent');	
fgui   = get(hfldext,'Parent');	
setup  = guidata(fgui);

% Load new fields to extract:
selected = get(hObject,'Value');

% Update setup:
setup.extlist = selected;
guidata(fgui,setup);	

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function extsets = load_extsets

extsets(1) = {'Theta and dv'};
extsets(2) = {'Tend. Native'};
extsets(3) = {'Air-sea flux'};
extsets(4) = {'Total advection'};
extsets(5) = {'Total diffusion'};
extsets(6) = {'All others'};
extsets(7) = {'Tend. Artif'};
extsets(8) = {'Advection X'};
extsets(9) = {'Advection Y'};
extsets(10) = {'Advection Z'};
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function pick_atlas_path(hObject, eventdata)

% Load the setup
hpaths = get(hObject,'Parent');	
fgui = get(hpaths,'Parent');	
setup = guidata(fgui);

% Pick a dir:
pathname = uigetdir('~/', 'Path to OCCA files');

% First update the parameter:
setup.path_occa = pathname; 
guidata(hObject,setup);

% Then update the text box:
set(findobj(hpaths,'Tag','path_atlas'),'String',pathname);

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function pick_output_path(hObject, eventdata)

% Load the setup
hpaths = get(hObject,'Parent');	
fgui = get(hpaths,'Parent');	
setup = guidata(fgui);

% Pick a dir:
pathname = uigetdir('~/', 'Select a path for outputs');

% First update the setup:
setup.path_output = pathname; 
guidata(hObject,setup);

% Then update the text box:
set(findobj(hpaths,'Tag','path_output'),'String',pathname);

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function liste = predef_regionlist;

ii = 0;
ii = ii + 1; liste(ii) = {'North Atlantic'};
ii = ii + 1; liste(ii) = {'Western North Pacific'};
ii = ii + 1; liste(ii) = {'Eastern North Pacific'};
ii = ii + 1; liste(ii) = {'A Simple Box for test purposes'};

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This predefined limits of some domains
function domain = predef_region(ireg)

switch ireg
	case 1,  % North Atlantic
		domain.x1 = 249.5; domain.y1 = 4.5;
		domain.x2 = 359.5; domain.y2 = 64.5;
		domain.z1 = -5; domain.z2 = -634.7;
	case 2,  % Western North Pacific
		domain.x1 = 110.5; domain.y1 = 9.5;
		domain.x2 = 184.5; domain.y2 = 66.5;
		domain.z1 = -5; domain.z2 = -634.7;
	case 3,  % Eastern North Pacific
		domain.x1 = 184.5; domain.y1 = 9.5;
		domain.x2 = 259.5; domain.y2 = 66.5;
		domain.z1 = -5; domain.z2 = -634.7;
	case 4,  % A Simple Box for test purposes		
		domain.x1 = 180.5; domain.y1 = 20.5;
		domain.x2 = 190.5; domain.y2 = 30.5;
		domain.z1 = -5; domain.z2 = -634.7;
end
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function update_depth1(hObject,eventdata);

% Load setup	
hmap    = get(hObject,'Parent');
fgui    = get(hmap,'Parent');
hmap_ch = get(hmap,'Children');
setup = guidata(fgui);

% Load new value from the list:
ethZ = findobj(hObject,'Tag','zlist1');
iz = get(ethZ,'Value');
if isempty(iz)
	iz = setup.iz1;
end
setup.z1 = setup.dpt(iz);
setup.iz1 = find(setup.dpt<=setup.z1,1,'first');
guidata(fgui,setup);

% Update title of the map
ah = findobj(hmap_ch,'Type','axes');
update_maptitle(get(ah,'Title'),setup.z1,setup.z2);

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function update_depth2(hObject,eventdata);

% Load setup	
hmap    = get(hObject,'Parent');
fgui    = get(hmap,'Parent');
hmap_ch = get(hmap,'Children');
setup = guidata(fgui);

% Load new value from the list:
ethZ = findobj(hObject,'Tag','zlist2');
iz = get(ethZ,'Value');
if isempty(iz)
	iz = setup.iz2;
end
setup.z2 = setup.dpt(iz);
setup.iz2 = find(setup.dpt<=setup.z2,1,'first');
guidata(fgui,setup);

% Update title of the map
ah = findobj(hmap_ch,'Type','axes');
update_maptitle(get(ah,'Title'),setup.z1,setup.z2);


allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function update_maptitle(ah,z1,z2)
str = sprintf('Z = [%i;%i]',fix(z1),fix(z2));
set(ah,'String',str,'verticalalignment','middle','background','none','fontweight','bold')

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot the box on the map
function varargout = drawbox(hObject,eventdata)

% Load setup	
hmap = get(hObject,'Parent');	
fgui = get(hmap,'Parent');	
setup = guidata(fgui);

sw(1) = setup.x1;
sw(2) = setup.y1;
ne(1) = setup.x2;
ne(2) = setup.y2;
hmap_ch = get(hmap,'Children');
if isempty(findobj(hmap_ch,'Tag','box'))
	l = line([sw(1) ne(1) ne(1) sw(1) sw(1)],[sw(2) sw(2) ne(2) ne(2) sw(2)]);
	set(l,'Tag','box');
else
	l = findobj(hmap_ch,'Tag','box');
	set(l,'XData',[sw(1) ne(1) ne(1) sw(1) sw(1)],'YData',[sw(2) sw(2) ne(2) ne(2) sw(2)]);
end
set(l,'linewidth',2,'color','w')

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is used to update the box when the user change the predefined region
function predef_region_and_plot(hObject,eventdata)

% Load the setup
hmap = get(hObject,'Parent');	
fgui = get(hmap,'Parent');	
setup = guidata(fgui);

% Load predefined region coord:
ireg = get(hObject,'Value');
domain = predef_region(ireg);

% Update the setup
setup.x1 = domain.x1;
setup.y1 = domain.y1;
setup.x2 = domain.x2;
setup.y2 = domain.y2;
setup.ix1 = find(setup.lon>=setup.x1,1,'first');
setup.ix2 = find(setup.lon>=setup.x2,1,'first');
setup.iy1 = find(setup.lat>=setup.y1,1,'first');
setup.iy2 = find(setup.lat>=setup.y2,1,'first');
guidata(fgui,setup);

% Update the box on the map
drawbox(hObject);

% We  also need to update the text in the coordinates boxes:
hmap = get(hObject,'Parent');
hmap_ch = get(hmap,'Children');
set(findobj(hmap_ch,'Tag','Xwest'),'String',num2str(domain.x1));
set(findobj(hmap_ch,'Tag','Xeast'),'String',num2str(domain.x2));
set(findobj(hmap_ch,'Tag','Ysouth'),'String',num2str(domain.y1));
set(findobj(hmap_ch,'Tag','Ynorth'),'String',num2str(domain.y2));

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is used to update the box when the user change coordinates in text boxes
function edit_domain(hObject,eventdata)

% Load the setup
hmap = get(hObject,'Parent');	
fgui = get(hmap,'Parent');	
setup = guidata(fgui);

% Read text box value:	
user_entry = get(hObject,'string');
if strfind(get(hObject,'Tag'),'X')
	[val ok] = clean_domainX(hObject,user_entry);
else
	[val ok] = clean_domainY(hObject,user_entry);
end
if ok == 1, 
	user_entry = val;
	% Update the setup:
	switch lower(get(hObject,'Tag'))
		case 'xwest',  setup.x1 = user_entry;setup.ix1 = find(setup.lon>=setup.x1,1,'first');
		case 'ysouth', setup.y1 = user_entry;setup.iy1 = find(setup.lat>=setup.y1,1,'first');
		case 'xeast',  setup.x2 = user_entry;setup.ix2 = find(setup.lon>=setup.x2,1,'first');
		case 'ynorth', setup.y2 = user_entry;setup.iy2 = find(setup.lat>=setup.y2,1,'first');
	end
	guidata(fgui,setup);

	% Update the box on the map:
	drawbox(hObject);
	set(hObject,'String',user_entry);

else
	% Restore the text box value:
	switch lower(get(hObject,'Tag'))
		case 'xwest',  set(hObject,'String',setup.x1);
		case 'ysouth', set(hObject,'String',setup.y1);
		case 'xeast',  set(hObject,'String',setup.x2);
		case 'ynorth', set(hObject,'String',setup.y2);
	end
end

allthetime(hObject);
end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check validity of zonal limits
function [val ok] = clean_domainX(hObject,str)

val = str2double(lower(str));
if isnan(val) | val > 360 | val < 0
	ok = 0;
	errordlg('You must enter a numeric value between 0 and 360','Bad Input','modal')
else
	ok = 1;
	val = fix(val)+.5; % Because OCCA grid is on the half
end

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check validity of meridional limits
function [val ok] = clean_domainY(hObject,str)

val = str2double(lower(str));
if isnan(val)
	ok = 0;
	errordlg('You must enter a numeric value for latitude','Bad Input','modal');
elseif val > 90
	ok = 0;
	errordlg('You must enter a numeric value lower than 90','Bad Input','modal');
elseif val < -90
	ok = 0;
	errordlg('You must enter a numeric value higher than -90','Bad Input','modal');
else
	ok = 1;
	val = fix(val)+.5; % Because OCCA grid is on the half
end

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [lon lat dpt] = load_axis;

pv_checkpath;load('LSmask_MOA','LONmask','LATmask','DPTmask');
lon = LONmask; clear LONmask; lat = LATmask; clear LATmask;	
dpt = DPTmask; clear DPTmask

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function varargout = create_queue_scripts(varargin);

workdir 	= varargin{1};
matlabpath 	= varargin{2};
klist 		= varargin{3};
confirm     = varargin{4};

if ~exist(sprintf('%s',workdir),'dir')
	mkdir(sprintf('%s',workdir));
end


% Create individual run scripts:
for ik = 1 : length(klist)

	k = klist(ik);

	fid = fopen(sprintf('%s/ExtD_set%2.2d.sh',workdir,k),'wt');

	fprintf(fid,'#!/bin/csh\n');
	fprintf(fid,'#\n');
	fprintf(fid,'#  Created by Guillaume Maze on %s.\n',datestr(now,'yyyy-mm-dd'));
	fprintf(fid,'#  Copyright (c) 2008 Guillaume Maze.\n');	
	fprintf(fid,'#  Generated automatically by the ILVB-GUI.m\n');
	fprintf(fid,'#\n');
	fprintf(fid,'set workdir=''%s''\n',workdir);
	fprintf(fid,'set matlabpath=''%s''\n',matlabpath);
	fprintf(fid,'#\n');
	fprintf(fid,'# Move to the exec directory:\n');	
	fprintf(fid,'cd $workdir\n');
	fprintf(fid,'#\n');
	fprintf(fid,'# Start run:\n');
	fprintf(fid,'$matlabpath -nojvm -nodisplay -r ''extract_this_subdomain(%i)''\n',k);
	fprintf(fid,'#\n');
	fprintf(fid,'exit\n');

	fclose(fid);
	system(sprintf('chmod ugo+x %s',sprintf('%s/ExtD_set%2.2d.sh',workdir,k)));


end %for klist

% Create script to launch everything:
fid = fopen(sprintf('%s/launch_all_ExtD.bat',workdir),'wt');
fprintf(fid,'#!/bin/csh\n');
fprintf(fid,'#\n');
fprintf(fid,'#  Created by Guillaume Maze on %s.\n',datestr(now,'yyyy-mm-dd'));
fprintf(fid,'#  Copyright (c) 2008 Guillaume Maze.\n');	
fprintf(fid,'#  Generated automatically by: ILVB-GUI.m\n');
fprintf(fid,'#\n');
for ik = 1 : length(klist)
	k = klist(ik);
	fprintf(fid,'qsub ExtD_set%2.2d.sh\n',k);
end %for ik
fprintf(fid,'#\n');
fclose(fid);
system(sprintf('chmod ugo+x %s',sprintf('%s/launch_all_ExtD.bat',workdir)));


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This function is executed at all events (debugging)
function allthetime(hObject,eventdata)

% Load the setup
htop = get(hObject,'Parent');	
fgui = get(htop,'Parent');	
setup = guidata(fgui);
%disp(setup);

if 0
	ch = get(fgui,'Children');
	for ii = 1 : length(ch)
		tag1  = get(ch(ii),'Tag');
		ch_ch = get(ch(ii),'children');
		tag   = get(ch_ch,'Tag');
		disp(sprintf('> %s:',tag1));
		if size(tag,1) == 1
			disp(tag);
		else
			disp(tag');
		end
	end
end


end % function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function applytheme(gui);
pref   = load('guiOCCA_preferences.mat'); data=pref.data; clear pref;
itheme = data.itheme;

% Theme:
theme.gui.bgcolor 	= [220 20 60]/255;
theme.gui.bgcolor 	= [100 149 237]/255;
theme.gui.bgcolor 	= [0 0 139]/255;

theme.panel.bgcolor   = [0 0 139]/255;
theme.panel.ttcolor   = [1 1 1];

theme.control.bgcolor = theme.panel.bgcolor;
theme.control.ttcolor = theme.panel.ttcolor;
theme.control.text.bgcolor = theme.control.bgcolor;
theme.control.text.ttcolor = theme.control.ttcolor;
theme.control.edit.bgcolor = theme.control.bgcolor;
theme.control.edit.ttcolor = theme.control.ttcolor;
theme.control.button.bgcolor = theme.control.bgcolor;
theme.control.button.ttcolor = theme.control.ttcolor;
%theme.control.button.bgcolor = [0 0 1];
%theme.control.button.ttcolor = [1 1 1];
theme.control.popup.bgcolor = theme.control.bgcolor;
theme.control.popup.ttcolor = theme.control.ttcolor;
theme.control.liste.bgcolor = theme.control.bgcolor;
theme.control.liste.ttcolor = theme.control.ttcolor;

theme.axes.bgcolor = theme.control.bgcolor;
theme.axes.xcolor = theme.control.ttcolor;
theme.axes.ycolor = theme.control.ttcolor;
theme.axes.bgcolor = [1 1 1];

%theme.control.edit.bgcolor = [100 149 237]/255;
%theme.control.button.bgcolor = [100 149 237]/255;
%theme.control.popup.bgcolor = [100 149 237]/255;
%theme.control.liste.bgcolor = [100 149 237]/255;

theme.control.text.ttcolor = [220 20 60]/255;

% Apply it:
set(gui,'color',theme.gui.bgcolor);

ch = get(gui,'Children');
for ich = 1 : length(ch)
	%disp(get(ch(ich),'Type'));
	thistheme(theme,ch(ich));

	chh = get(ch(ich),'Children');
	for ichh = 1 : length(chh)
		%disp(get(chh(ichh),'Type'));
		thistheme(theme,chh(ichh));

		chhh = get(chh(ichh),'Children');
		if ~isempty(chhh)
			%disp(get(chhh,'Type'))
		end
	end
end


function thistheme(theme,h);
	switch lower(get(h,'Type'))
		case 'uipanel'
			set(h,'Foregroundcolor',theme.panel.ttcolor);	
			set(h,'Backgroundcolor',theme.panel.bgcolor);

		case 'uicontrol'
			set(h,'Foregroundcolor',theme.control.ttcolor);	
			set(h,'Backgroundcolor',theme.control.bgcolor);		
			switch lower(get(h,'Style'))
				case 'text'
					set(h,'Backgroundcolor',theme.control.text.bgcolor);
					set(h,'Foregroundcolor',theme.control.text.ttcolor);	
				case 'edit'
					set(h,'Backgroundcolor',theme.control.edit.bgcolor);
					set(h,'Foregroundcolor',theme.control.edit.ttcolor);	
				case 'pushbutton'
					set(h,'Backgroundcolor',theme.control.button.bgcolor);
					set(h,'Foregroundcolor',theme.control.button.ttcolor);
				case 'popupmenu'
					set(h,'Backgroundcolor',theme.control.popup.bgcolor);
					set(h,'Foregroundcolor',theme.control.popup.ttcolor);					
				case 'listbox'
					set(h,'Backgroundcolor',theme.control.liste.bgcolor);
					set(h,'Foregroundcolor',theme.control.liste.ttcolor);	
			end
		case 'axes'
			set(h,'Color',theme.axes.bgcolor);
			set(h,'xColor',theme.axes.xcolor);
			set(h,'yColor',theme.axes.ycolor);
	end
end


end %function














