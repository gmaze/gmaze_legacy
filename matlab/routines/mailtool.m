% mailtool Email button to figure toolbar
%
% [] = mailtool()
% 
% Add an "send by email" button to the figure toolbar to
% email the figure.
%
% Created: 2008-11-13.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = mailtool(varargin)

if nargin == 1
	if ischar(varargin{1})
		par = NaN;
	else
		% We have a parent to attach the button:
		par = varargin{1};
	end
else
	% We don't have a parent uitoolbar so we create one.
	% Before that, we check if doesn't already exists:
	tbh = findall(gcf,'Type','uitoolbar');
	delete(findobj(tbh,'Tag','mailtool'));
	% Create the toolbar:
	par = uitoolbar(gcf,'Tag','mailtool');		
end
if ~isnan(par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CDdata = load_icons(4);

pth = uipushtool('Parent',par,'CData',CDdata,'Enable','on',...
          'TooltipString','Send this figure by email','Separator','off',...
          'HandleVisibility','on','ClickedCallback',{@mailit});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
	tbh = findall(gcf,'Type','uitoolbar');
	delete(findobj(tbh,'Tag','mailtool'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
end %function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mailit(hObject,eventdata)

th = get(hObject,'Parent');
gf = get(th,'Parent');

% Create a JPEG file form the figure:
alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
file = alphabet(randperm(length(alphabet)));
file = file(1:12);
file = strcat(file,'.jpg');
print(gf,'-djpeg90',file);
	
% Send the mail:
try
	emailpanel(file);
catch
	error('Error sending email');
end
	
end %function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function emailpanel(varargin);
	
	file = varargin{1};	
	posi = get(gcf,'position');	
	wgui = 500;
	hgui = 300;

	%%%%%%%%%%%% CREATE THE GUI FOR EMAILS:
	bgcolor = [1 1 1]*0.702;
	fguimail = builtin('figure');
	set(fguimail,'Tag','GUIemails');
	set(fguimail,'visible','off');
	set(fguimail,'menubar','none');
	set(fguimail,'color',bgcolor);
	set(fguimail,'position',[posi(1)+(posi(3)-wgui)/2 posi(2)+(posi(4)-hgui)/2 wgui hgui]);
	set(fguimail,'resize','off');
	set(fguimail,'NumberTitle','off')
	title_str = 'Send a Email';
	set(fguimail,'name',title_str);
	data.to = 'codes@guillaumemaze.org';
	data.sb = 'A word from matlab';
	data.bo = 'your text';
	data.file = file;
	guidata(fguimail,data);
	
	
	%% HEADER:
	w = 65; l = 5; b = 260;
	hfrom_title = uicontrol('Parent',fguimail,'Style','text','String','From:','fontunits','pixel','fontsize',14,...
					'Units','Pixel','Position',[l b w 21],'Horizontalalignment','left','fontweight','bold','fontname','Helvetica');
	hfrom_box   = uicontrol('Parent',fguimail,'Style','text','String',' your system email','fontname','Helvetica',...
					'Units','Pixel','Position',[l+w+5 b wgui-w-15 21],'Horizontalalignment','left','fontunits','pixel','fontsize',14);
%	align([hfrom_title hfrom_box],'distribute','middle')
					
	w = 65; l = 5; b = b - 25;
	hto_title = uicontrol('Parent',fguimail,'Style','text','String','To:','fontunits','pixel','fontsize',14,'fontname','Helvetica',...
					'Units','Pixel','Position',[l b w 21],'Horizontalalignment','left','fontweight','bold');
	hto_box   = uicontrol('Parent',fguimail,'Style','edit','String',data.to,'Tag','to','fontunits','pixel','fontsize',14,'fontname','Helvetica',...
					'Units','Pixel','Position',[l+w+5 b+7 wgui-w-15 21],'Horizontalalignment','left','backgroundcolor','w');
%	align([hto_title hto_box],'distribute','middle')
					
	w = 65; l = 5; b = b - 25;
	hsbj_title = uicontrol('Parent',fguimail,'Style','text','String','Subject:','fontunits','pixel','fontsize',14,'fontname','Helvetica',...
					'Units','Pixel','Position',[l b w 21],'Horizontalalignment','left','fontweight','bold');
	hsbj_box   = uicontrol('Parent',fguimail,'Style','edit','String',data.sb,'Tag','subject','fontunits','pixel','fontsize',14,'fontname','Helvetica',...
					'Units','Pixel','Position',[l+w+5 b+7 wgui-w-15 21],'Horizontalalignment','left','backgroundcolor','w');
%	align([hsbj_title hsbj_box],'distribute','middle')

	%% BODY:
	hbody_box   = uicontrol('Parent',fguimail,'Style','edit','String',data.bo,'Tag','body','max',11,'min',1,'Horizontalalignment','left','fontname','Helvetica',...
					'Units','Pixel','Position',[5 35 wgui-10 b-35-5],'Horizontalalignment','left','backgroundcolor','w','fontunits','pixel','fontsize',12);
	

	%% BUTTONS:
	hsend = uicontrol('Parent',fguimail,'Style','pushbutton','String','Send Email and Close',...
					'Units','pixels','Horizontalalignment','center',...
	                'Position',[wgui/2-150 5 150 20],'Callback',{@sendthis},'Tag','savepref_button','fontname','Helvetica');

	hcancel = uicontrol('Parent',fguimail,'Style','pushbutton','String','Discard',...
					'Units','pixels','Horizontalalignment','center',...
	                'Position',[wgui/2 5 100 20],'Callback',{@discard},'Tag','discardpref_button','fontname','Helvetica');
	align([hsend hcancel],'distribute','bottom');
	
	set(fguimail,'visible','on');	


	%%%%%%%%%%%% 
	function sendthis(hObject,eventdata)
		
		hgui = get(hObject,'Parent');
		data = guidata(hgui);		
		data.to = get(findobj(hgui,'Tag','to'),'String');
		data.sb = get(findobj(hgui,'Tag','subject'),'String');
		data.bo = get(findobj(hgui,'Tag','body'),'String');
		guidata(hgui,data);
		try 
			destinat = validemail(data.to);
			subject  = data.sb;
			body0    = data.bo;
			if size(body0,1) > 1
				for il = 1 : size(body0,1)
					body(il,:) = {sprintf('%s\n',body0(il,:))};
				end
			else
				body = body0;
			end
			
			% This is where we choose how to send the email: 
			
            if usejava('jvm') % Matlab runs with java, cool, it's easy !
				disp('Sending mail with Java sendmail ...');
                % Simple Matlab builtin function:
				set = load('private/email_settings.mat'); % This contains variables: mail and password
				mail     = set.mail;
				password = set.password;
				% Then this code will set up the preferences properly:
				setpref('Internet','E_mail',mail);
				setpref('Internet','SMTP_Server','smtp.gmail.com');
				setpref('Internet','SMTP_Username',mail);
				setpref('Internet','SMTP_Password',password);
				props = java.lang.System.getProperties;
				props.setProperty('mail.smtp.auth','true');
				props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
				props.setProperty('mail.smtp.socketFactory.port','465');
				sendmail(destinat,subject,body,data.file);
				disp('Done');
				
			% Oups, we need to find something else, Matlab is running with option -nojvm
				
            elseif ismac % With MAC will use a script to use Mail.app			
				disp('Sending mail with Mail.app ...');
				% Create the custom Apple Script:
				fida = fopen('./tmp_scpt.applescript','wt');
				fprintf(fida,'set theSubject to "%s"\n',subject);
				fprintf(fida,'set theBody to "%s"\n',body);
				fprintf(fida,'set theAddress to "%s"\n',destinat);
				fprintf(fida,'set theAttachment to "%s/%s"\n',pwd,data.file);				
				fprintf(fida,'tell application "Mail"\n');
				fprintf(fida,'	set newMessage to make new outgoing message with properties {subject:theSubject, content:theBody & return & return}\n');
				fprintf(fida,'	tell newMessage\n');
				fprintf(fida,'		set visible to false\n');
				fprintf(fida,'		make new to recipient at end of to recipients with properties {address:theAddress}\n');
				fprintf(fida,'		tell content\n');
				fprintf(fida,'			make new attachment with properties {file name:theAttachment} at after the last paragraph\n');
				fprintf(fida,'		end tell\n');
				fprintf(fida,'	end tell\n');
				fprintf(fida,'	send newMessage\n');
				fprintf(fida,'end tell');
				fclose(fida);
				
				% Run it:
				[st,re] = system('osascript ./tmp_scpt.applescript');
				delete('./tmp_scpt.applescript');
				disp('Done');
				
			elseif isunix % Under Linux, well, right now let's only use /usr/bin/mail 
						  % this means we can't attach the figure, s... !		
				disp('Sending mail with unix mail command ...');					
                [st,re] = system('which mail');
                if ~isempty(st)
                    mailsend_LINUX(destinat,subject,body,data.file);
					disp('Done');
                else
                    disp('We don''t know how to send your email !')
                end
			else
				disp('We don''t know how to send your email !')
            end
  			
			delete(get(hObject,'Parent'));
        catch
            la = lasterror
			la.message
			error('Error sending email');
		end	
		delete(data.file);
	end

	%%%%%%%%%%%% 	
	function email = validemail(to);
		if length(strfind(to,'@')) > 1
			error('Only 1 recipient please !');
			email = '';
		else
			email = to;
		end
	end
	%%%%%%%%%%%% 	
	function discard(hObject,eventdata)
		delete(get(hObject,'Parent'));
	end %function
	
	%%%%%%%%%%%%
	function mailsend_LINUX(email,subject,body,file)
		fid = fopen('./.matlab_email.txt','w');
		if ~iscell(body)
			% Check if we have multiple lines
			ll=findstr(body,'\n');
			if ~isempty(ll)
				body = ['\n' body '\n'];
				ll = findstr(body,'\n');
				for il = 1 : length(ll)-1
					fprintf(fid,'%s\n',body(ll(il)+2:ll(il+1)-1));
				end
			else
				fprintf(fid,'%s',body);
			end
		else
			for il = 1 : length(body)
				fprintf(fid,'%s',cell2mat(body(il)));
			end
		end	
		% now concat the figure:
		if 0
		fprintf(fid,'\n');
		fprintf(fid,'Content-Transfer-Encoding: base64\n');
		fprintf(fid,'Content-Type: image/pjpeg;name="Figure[1]"\n');
		fprintf(fid,'Content-Disposition: attachment;filename="file[1]"\n');		
		fidf = fopen(strcat(file,'_64'));
		while 1
			tline = fgetl(fidf)
			if ~ischar(tline), break
			elseif isempty(strfind(tline,'begin-base64')) & isempty(strfind(tline,'===='))
				fprintf(fid,'%s\n',strtim(tline));
			end
		end
		fclose(fidf);
		end
		fclose(fid);

		chaine = sprintf('mail -s ''%s'' %s < %s',subject,email,'./.matlab_email.txt'); % Don't attach the file right now !
		system(chaine);

		delete('./.matlab_email.txt');
		delete(strcat(file,'_64'));

	end %function
	
end %function	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  





