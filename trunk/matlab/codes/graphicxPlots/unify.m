% unify Uniforms y-axis limits on different figures
%
% [] = unify(FLIST,[YL])
% 
% Rev. by Guillaume Maze on 2013-11-06: Do no include colormap anymore
% Created: 2008-11-05.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = unify(flist,varargin)

ifig = 0;
nfig = length(flist);

if nargin == 2
	yl = varargin{1};
else
	cestfini = 0;
	yl   = [0 0];
	while cestfini==0
	  ifig = ifig+1;
	  if ifig <= nfig
		 gc = builtin('figure',flist(ifig));
		 h = findobj(gc,'Type','axes'); 
		 for ih = 1 : length(h)
			 if ~strcmp(get(h(ih),'Tag'),'legend') & ~strcmp(get(h(ih),'Tag'),'footnote')  & ~strcmp(get(h(ih),'Tag'),'suptitle') & ~strcmp(get(h(ih),'Tag'),'Colorbar')
			     limit1 = min(get(h(ih),'ylim'));
			     if limit1 <= yl(1), yl(1) = limit1; end
			     limit2 = max(get(h(ih),'ylim'));
			     if limit2 >= yl(2), yl(2) = limit2; end
			 end
		 end %for ih
	  else
	    cestfini = 1;
	  end %if
	end %while  
end %

for ifig = 1 : nfig
	gc = builtin('figure',flist(ifig));
	h = findobj(gc,'Type','axes'); 
	for ih = 1 : length(h)	
		if ~strcmp(get(h(ih),'Tag'),'legend') & ~strcmp(get(h(ih),'Tag'),'footnote')  & ~strcmp(get(h(ih),'Tag'),'suptitle') & ~strcmp(get(h(ih),'Tag'),'Colorbar')	
			set(h(ih),'ylim',yl);
		end
	end
end  


