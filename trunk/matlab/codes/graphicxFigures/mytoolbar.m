% mytoolbar Add my personnal buttons to the figure toolbar
%
% [] = mytoolbar()
% 
% Add mailtool, sgetool and graphtool to the figure toolbar.
%
%
% Created: 2008-11-18.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = mytoolbar(varargin)

	% Existing toolbars:
	tbh0 = findall(gcf,'Type','uitoolbar');
	
	% We remove it and re-create it to update:
	if ~isempty(tbh0)
		delete(findobj(tbh0,'Tag','mytool'));
	end
	tbh  = uitoolbar(gcf,'Tag','mytool');	
	
	% Add elements:
	mailtool(tbh);
	%graphtool(tbh);
	sgetool(tbh);
	

end %function





