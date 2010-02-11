% pllist_gui H1LINE
%
% [] = pllist_gui()
% 
% HELPTEXT
%
% Created: 2009-11-22.
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

function varargout = pllist_gui(varargin)

if nargin == 1
	pl_list = pllist(varargin{1});
elseif nargin ==2
	pl_list = pllist(varargin{1},varargin{2});
end
if isa(pl_list,'struct')

	switch nargin
		case 1
			for ii = 1 : length(pl_list)
				pl_list(ii).root = '.';
			end
		case 2
			for ii = 1 : length(pl_list)
				pl_list(ii).root = varargin{2};
			end
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GUI Style:
if 1
itheme = 3;
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
bgcolor='w';
fgcolor=[1 1 1]*0.702;
ttcolor='k';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the GUI window:
% Check if it already exists:
ch  = get(0,'Children');
ich = findobj(ch,'Tag','pllist_gui');
if ~isempty(ich)
	for ii=1:length(ich)
		close(find(ch==ich(ii)));
	end
end
fgui = builtin('figure');

set(fgui,'Tag','pllist_gui');
set(fgui,'visible','on');
set(fgui,'menubar','none');
set(fgui,'color',bgcolor);
	
h     = 20*length(pl_list);
gui_w = 600; % GUI width
gui_h = 35;  % GUI Heigth
mb_h  = 35;  % Menu bar height
ival0 = 1; % Selected file by default on start up
fs = 10; % Font size
bt_h = 25; % Buttons and list height (px)
nv_bt = 2; % Nb of buttons on the vertical
gui_h = nv_bt*bt_h+(nv_bt+1)*5;  % Update GUI Heigth
bt_w = (gui_w-10)/5; % Action button widths (px)

s0 = get(0,'screensize');
%set(fgui,'position',[100 65 gui_w gui_h]);
set(fgui,'position',[1 s0(4)-gui_h-1 gui_w gui_h]);
%set(fgui,'position',[10 50 gui_w gui_h]);
set(fgui,'resize','off')
set(fgui,'name','Version 1.0','NumberTitle','off');

% Title:
%title_str = 'Available diagnostics';
switch nargin
	case 1
		title_str = sprintf('%s_pl*.m',varargin{1});
	case 2
		title_str = sprintf('%s/%s_pl*.m',varargin{2},varargin{1});
end

set(fgui,'name',title_str);
guidata(fgui,pl_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
for ii = 1 : length(pl_list)
	diag_list(ii) = {sprintf('%i: %s',pl_list(ii).index,pl_list(ii).description)};
end



%mhABOUT = uimenu('Parent',fgui,'Label','ILVB','Tag','MENU1');
%uimenu('Parent',mhABOUT,'Label','Run it','Callback',{@runit},'Accelerator','m','Enable','on');
%uimenu('Parent',mhABOUT,'Label','M-lint','Callback',{@mlintit},'Accelerator','m','Enable','on');

mb_run   = uimenu('Parent',fgui,'Label','Run it','Tag','MENU1','Callback',{@runit});
mb_mlint = uimenu('Parent',fgui,'Label','M-lint','Tag','MENU2','Callback',{@mlintit});
mb_req   = uimenu('Parent',fgui,'Label','Requirements','Tag','MENU3','Callback',{@mlintit});
mb_more  = uimenu('Parent',fgui,'Label','More','Tag','MENU3','Callback',{@mlintit});


diag_list_items = uicontrol('Parent',fgui,'Style','popupmenu','Units','normalized','Horizontalalignment','left',...
			                'String',diag_list,'Max',1,'Min',0,'units','pixels',...
			                'Value',ival0,'Position',[5 gui_h-bt_h-5 gui_w-5-5 bt_h],...
							'Callback',{@ifchanged},'Tag','PredefList','backgroundcolor',fgcolor,'foregroundcolor',ttcolor);

push_bt1 = uicontrol('Parent',fgui,'Style','pushbutton','String','Never run','Units','pixels','Horizontalalignment','center',...
                 'Position',[5 gui_h-5-bt_h-5-bt_h bt_w bt_h],'Callback',{@runit},'Tag','UpdateDomainbutton','backgroundcolor',fgcolor,'foregroundcolor',ttcolor);

% push_bt2 = uicontrol('Parent',fgui,'Style','pushbutton','String','M-lint','Units','pixels','Horizontalalignment','center',...
%                 'Position',[5+bt_w+5 gui_h-5-bt_h-5-bt_h bt_w bt_h],'Callback',{@mlintit},'Tag','UpdateDomainbutton','backgroundcolor',fgcolor,'foregroundcolor',ttcolor);


end%if found files
end %functionpllist_gui


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function ifchanged(hObject,eventdata)

% Load the setup
fgui  = get(hObject,'Parent');	

PredefList = findobj(fgui,'Tag','PredefList');
idiag      = get(PredefList,'Value');
pl_list    = guidata(fgui);

if isfield(pl_list(idiag),'trun')
	if ~isempty(pl_list(idiag).trun)
		set(findobj(fgui,'Tag','UpdateDomainbutton'),'String',sprintf('Last run: (%2.0f sec)',pl_list(idiag).trun));	
	else
		set(findobj(fgui,'Tag','UpdateDomainbutton'),'String',sprintf('Never run'));
	end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function runit(hObject,eventdata)

% Load the setup
fgui = get(hObject,'Parent');	

%
PredefList = findobj(fgui,'Tag','PredefList');
idiag      = get(PredefList,'Value');
pl_list    = guidata(fgui);
command    = sprintf('run(''%s/%s'')',pl_list(idiag).root,pl_list(idiag).name);
disp(command);
t = clock;
try
	evalin('base',command);
catch
	la =lasterror;
	disp(la.message);
	disp('Crashed ...');
end
t = etime(clock,t);
pl_list(idiag).trun = t; guidata(fgui,pl_list);
set(findobj(fgui,'Tag','UpdateDomainbutton'),'String',sprintf('Run in: %2.0f sec',t));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function mlintit(hObject,eventdata)

% Load the setup
fgui  = get(hObject,'Parent');	

%
PredefList = findobj(fgui,'Tag','PredefList');
idiag      = get(PredefList,'Value');
pl_list = guidata(fgui);
pl_list(idiag).name
mlint(sprintf('%s/%s',pl_list(idiag).root,pl_list(idiag).name),'string')

end


