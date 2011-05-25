% UNIF Uniformize colorscale on different figures
% 
% UNIF(FLIST,[CX])
%
% Change caxis in all figures (given by their handles in FLIST)
% so that they are of the same limits
%
% Copyright (c) 2004 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = unif(flist,varargin)
  

ifig = 0;
nfig = length(flist);

if nargin == 2
	cx = varargin{1};
else
	cestfini = 0;
	cx   = [0 0];
	while cestfini==0
	  ifig=ifig+1;
	  if ifig<=nfig
		 gc = builtin('figure',flist(ifig));
		 gch = get(gc,'children');
		 igch = findobj(gch,'type','axes');
		 for ii = 1 : length(igch)
		     limit1=min(caxis);
		     if limit1<=cx(1),cx(1)=limit1;end
		     limit2=max(caxis);
		     if limit2>=cx(2),cx(2)=limit2;end
		end %for ii
	  else
	    cestfini=1;
	  end %if
	end %while  
end %

for ifig=1:nfig
	gc   = builtin('figure',flist(ifig));
	gch  = get(gc,'children');
	igch = findobj(gcf,'Type','axes');
	for ii = 1 : length(igch)
		set(igch(ii),'clim',cx);
		if strcmp(lower(get(igch(ii),'tag')),'colorbar') % colorbar
			if isempty(get(igch(ii),'xtick')) % Vertical colorbar
				yl = get(igch(ii),'ylim');
				set(igch(ii),'ytick',linspace(yl(1),yl(2),5));
			elseif isempty(get(igch(ii),'ytick')) % Horizontal colorbar
			end
		end
	end
end  























