% sgetool Add a button to a figure toolbar to check on SGE scripts in the queue
%
% [] = sgetool()
% 
% Add a button to a figure toolbar to check on SGE scripts in the queue
%
%
% Created: 2008-11-19.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = sgetool(varargin)

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
	delete(findobj(tbh,'Tag','sgetool'));
	% Create the toolbar:
	par = uitoolbar(gcf,'Tag','sgetool');		
end

if ~isnan(par)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pth = uipushtool('Parent',par,'CData',load_icons(7),'Enable','on',...
          'TooltipString','Check SGE Jobs','Separator','off',...
          'HandleVisibility','on','ClickedCallback',{@checkthis});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
	tbh = findall(gcf,'Type','uitoolbar');
	delete(findobj(tbh,'Tag','sgetool'));	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end %function

function checkthis(hObject,eventdata)
	try 
		run('~/work/Postdoc/work/coare/Tlayer_budget/extra/check_jobsX.m');
	catch
		disp('Error');
	end
end %function









