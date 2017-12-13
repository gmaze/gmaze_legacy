function varargout = viz3d(x,y,z,data,slice)
% viz3d 3D field exploration plot
%
% 	viz3d(x,y,z,data,slice)
% with
% 	data(x,y,z)
%	slice = [0 0 10] is the slice to plot as reference
%
% 
%
% EG:
%
% See Also: 
%
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire d'Océanographie Physique et Spatiale).
% Created: 2016-06-23 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire d'Océanographie Physique et Spatiale nor the names of its contributors may be used 
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

%- Default parameters:

%- Construct the data space:
plan{1} = x(:);
plan{2} = y(:);
plan{3} = z(:);
clear x y z

%- Determine the plan to be used:
planid = find(slice==0);

%- Determine the vizualisation level:
vizid = find(slice~=0);
level = slice(vizid);

%- Extract data to plot
switch vizid
	case 1, d = squeeze(data(level,:,:)); xl='Dimension 2';yl='Dimension 3';
	case 2, d = squeeze(data(:,level,:)); xl='Dimension 1';yl='Dimension 3';
	case 3, d = squeeze(data(:,:,level)); xl='Dimension 1';yl='Dimension 2';
end% switch 

%- Plot data
pcolor(plan{planid(1)},plan{planid(2)},d')
shading flat
xlabel(xl);ylabel(yl)

%- Define variables for the exploration tool:
%OBJ = getappdata(gcf,'OBJ');
setappdata(gcf,'DATA',data);
setappdata(gcf,'AX1',plan{planid(1)});
setappdata(gcf,'AX2',plan{planid(2)});
setappdata(gcf,'AX3',plan{vizid});
setappdata(gcf,'VIZID',vizid);
setappdata(gcf,'PLANID',planid);
setappdata(gcf,'LEV',level);

%- Add exploration tool
% We remove it and re-create it to update:
tbh0 = findall(0,'Tag','viz3d');
if ~isempty(tbh0),delete(tbh0);end
tbh  = uitoolbar(gcf,'Tag','viz3d');
% Add elements:
profiletool(tbh);
continuousprofiletool(tbh);

%stophere

end %functionviz3d

%- Profile button
function varargout = profiletool(varargin)

if nargin == 1
	if ischar(varargin{1})
		par = [];
	else
		% We have a parent to attach the button:
		par = varargin{1};
	end
else
	% We don't have a parent uitoolbar so we create one.
	% Before that, we check if doesn't already exists:
	tbh = findall(gcf,'Type','viz3d');
	delete(findobj(tbh,'Tag','profiletool'));
	% Create the toolbar:
	par = uitoolbar(gcf,'Tag','profiletool');		
end

if ~isempty(par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
droot = '~/work/Community/COPODA/forgerepos/svn/trunk/copoda/data';
CData = load(fullfile(droot,'icon_profile2.mat'));
CData.A = abs(CData.A-.2);

pth = uipushtool('Parent',par,'CData',CData.A,'Enable','on',...
          'TooltipString','Profile','Separator','off',...
          'HandleVisibility','on','ClickedCallback',{@profileit});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
	tbh = findall(gcf,'Type','viz3d');
	delete(findobj(tbh,'Tag','profiletool'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %functionprofiletool

%- continuous Profile button
function varargout = continuousprofiletool(varargin)

if nargin == 1
	if ischar(varargin{1})
		par = [];
	else
		% We have a parent to attach the button:
		par = varargin{1};
	end
else
	% We don't have a parent uitoolbar so we create one.
	% Before that, we check if doesn't already exists:
	tbh = findall(gcf,'Type','viz3d');
	delete(findobj(tbh,'Tag','cprofiletool'));
	% Create the toolbar:
	par = uitoolbar(gcf,'Tag','cprofiletool');		
end

if ~isempty(par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
droot = '~/work/Community/COPODA/forgerepos/svn/trunk/copoda/data';
CData  = load(fullfile(droot,'icon_profile2.mat'));
CData.A = abs(CData.A-.1);

pth = uipushtool('Parent',par,'CData',CData.A,'Enable','on',...
          'TooltipString','Continuous Profiling','Separator','off',...
          'HandleVisibility','on','ClickedCallback',{@cprofileit});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
	tbh = findall(gcf,'Type','viz3d');
	delete(findobj(tbh,'Tag','profiletool'));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end %functionprofiletool


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function profileit(hObject,eventdata)

%disp('profile this')
tbh  = get(hObject,'Parent');
ftop = get(tbh,'Parent');
set(0,'CurrentFigure',ftop);

delete(findall(ftop,'tag','profloc'))

% Get data:
DATA = getappdata(gcf,'DATA');
AX1  = getappdata(gcf,'AX1');
AX2  = getappdata(gcf,'AX2');
AX3  = getappdata(gcf,'AX3');
VIZID = getappdata(gcf,'VIZID');
LEV = getappdata(gcf,'LEV');
PLANID = getappdata(gcf,'PLANID');

% Get location of the mouse:
[x1 x2 but] = ginput(1);

% Find nearest grid point:
switch numel(find(size(AX1)~=1))
	case 1
		dx1 = (x1-AX1).^2;
		dx2 = (x2-AX2).^2;
		i1 = find(dx1==min(dx1),1);
		i2 = find(dx2==min(dx2),1);
		xl1 = AX1(i1);
		xl2 = AX2(i2);
%		figure;pcolorsf(AX1,AX2,dx1);vline(AX1(i1));hline(AX2(i2));
	case 2
		dsq = (x1-AX1).^2 + (x2-AX2).^2; whos dsq
		[i1 i2] = find(dsq==min(dsq(:)),1);
		xl1 = AX1(i1,i2);
		xl2 = AX2(i1,i2);
%		figure;pcolorsf(AX1,AX2,dsq);vline(AX1(i1,i2));hline(AX2(i1,i2));
end% switch 
h(1)=vline(x1,'linestyle','--','color','k'); 
h(2)=hline(x2,'linestyle','--','color','k');
h(3)=vline(xl1,'color','k','tag','profloc');
h(4)=hline(xl2,'color','k','tag','profloc');
set(h,'tag','profloc');

%- Plot profile
%stophere
figure;hold on
VIZID
switch VIZID
	case 1, plot(AX3,squeeze(DATA(:,i1,i2)));xl='Dimension 1';
	case 2, plot(AX3,squeeze(DATA(i1,:,i2)));xl='Dimension 2';
	case 3, plot(AX3,squeeze(DATA(i1,i2,:)));xl='Dimension 3';
end% switch
ylabel('Data');xlabel(xl);
grid on,box on,vline(AX3(LEV),'color','k','linestyle','--');
title(sprintf('Profile through Dimension %i\nat Dimension %i=%0.3f / Dimension %i=%0.3f',VIZID,PLANID(1),xl1,PLANID(2),xl2),'fontweight','bold','fontsize',14)
%stophere

set(0,'CurrentFigure',ftop);

end %function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cprofileit(hObject,eventdata)

%disp('profile this')
tbh  = get(hObject,'Parent');
ftop = get(tbh,'Parent');
set(0,'CurrentFigure',ftop);

% Get data:
DATA = getappdata(gcf,'DATA');
AX1  = getappdata(gcf,'AX1');
AX2  = getappdata(gcf,'AX2');
AX3  = getappdata(gcf,'AX3');
VIZID = getappdata(gcf,'VIZID');
LEV = getappdata(gcf,'LEV');
PLANID = getappdata(gcf,'PLANID');

% Set up the profile figure
gcfp = figure;
pos1 = get(ftop,'position');
pos2 = get(gcfp,'position');
set(gcfp,'position',[pos1(1)+pos1(2) pos2(2:4)]);

set(0,'CurrentFigure',ftop);
set(ftop, 'WindowButtonMotionFcn', @(object, eventdata) mouseMove(object, eventdata) )

function mouseMove (object, eventdata)
	C = get (gca, 'CurrentPoint');
	x1 = C(1,1);
	x2 = C(1,2);
	% Find nearest grid point:
	switch numel(find(size(AX1)~=1))
		case 1
			dx1 = (x1-AX1).^2;
			dx2 = (x2-AX2).^2;
			i1 = find(dx1==min(dx1),1);
			i2 = find(dx2==min(dx2),1);
			xl1 = AX1(i1);
			xl2 = AX2(i2);
		case 2
			dsq = (x1-AX1).^2 + (x2-AX2).^2; whos dsq
			[i1 i2] = find(dsq==min(dsq(:)),1);
			xl1 = AX1(i1,i2);
			xl2 = AX2(i1,i2);
	end% switch 

	%- Plot profile
	set(0,'CurrentFigure',gcfp);	
	switch VIZID
		case 1, plot(AX3,squeeze(DATA(:,i1,i2)));xl='Dimension 1';
		case 2, plot(AX3,squeeze(DATA(i1,:,i2)));xl='Dimension 2';
		case 3, plot(AX3,squeeze(DATA(i1,i2,:)));xl='Dimension 3';
	end% switch
	ylabel('Data');xlabel(xl);ylim(range(DATA));xlim(range(AX3))
	grid on,box on,vline(AX3(LEV),'color','k','linestyle','--');
	title(sprintf('Profile through Dimension %i\nat Dimension %i=%0.3f / Dimension %i=%0.3f',VIZID,PLANID(1),xl1,PLANID(2),xl2),'fontweight','bold','fontsize',14)
	
	set(0,'CurrentFigure',ftop);	
end% function

end %function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

