% CANOM Center the color axis around zero
%
% [CX] = CANOM()
%
% Center the coloraxis on zero
% and change the colormap to:
%	AdvancedColormap('kbswopk') if AdvancedColormap is available
% otherwise to:
% 	mapanom2
% 
%
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org
% Revised: 2016-05-25 (G. Maze) Changed colormap 

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = canom(varargin)

deb = 0;
cl  = [];

% Look for contour values in the plot:
ch = get(gca,'children');
ch = setdiff(ch,findall(ch,'type','text'));

% Is this a contour plot ?
ct = findall(ch,'type','hggroup');
v = [];
for ii=1:length(ct)
	v  = cat(1,v,cell2mat(get(get(ct(ii),'children'),'userdata')));
end% for ii
if ~isempty(ct)
	cl = max(abs(range(v(:))));
	if deb,disp('Found a contour plot'),end% if 
end% if 
	
% Is this a pcolor/surf plot ?
if isempty(cl)
	ct = findall(ch,'type','surface');
	v = get(ct,'zdata');
	if length(unique(range(v(:)))) == 1
		v = get(ct,'cdata');
	end% if 
	if ~isempty(ct)
		cl = max(abs(range(v(:))));
		if deb,disp('Found a pcolor/surf  plot'),end% if 		
	end% if 
end% if 

% Let's see if these are m_map stuff
if isempty(cl)
	ct = findall(ch,'tag','m_contourf');
	v  = cell2mat(get(ct,'userdata'));
	if ~isempty(ct)
		cl = max(abs(range(v(:))));
		if deb,disp('Found m_map stuff'),end% if 				
	end% if
end% if 	

if nargin==1
	cl = varargin{1};
	if deb,disp('User defined axis'),end% if 					
end% if 
	
if isempty(cl)
	warning('I don''t know how to retrieve values from this plot ...')
else	
	if exist('AdvancedColormap') == 2
		AdvancedColormap('kbswopk')
	else
		load mapanom2
		colormap(mapanom)
	end% if 
	caxis([-1 1]*max(cl));
end% if 
	
varargout(1) = {cl};