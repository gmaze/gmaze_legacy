% h = footnote([TEXT])
%
% Add a footnote to a plot.
% By default, add the date with the path
% if TEXT='del', just remove the existing footnote
%
% Created by Guillaume Maze on 2008-09-16.
% Copyright (c) 2008 Guillaume Maze. 
% INSPIRED BY THE SUPTITLE FUNCTION OF: Drea Thomas 6/15/95 drea@mathworks.com
%

% Copyright (c) 2008 Guillaume Maze. 
% This file is part of "The-Matlab-Show"
% The-Matlab-Show is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.
% Foobar is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with The-Matlab-Show.  If not, see <http://www.gnu.org/licenses/>.
%
function varargout = footnote(varargin)
	
if nargin == 1	
	str = varargin(1);	
else
	we = wherearewe;
	str = datestr(now,'dd-mmm-yyyy HH:MM');
%	str = sprintf('%s\n%s',str,pwd);
	str = sprintf(' guillaume.maze@gmail.com (%s)\n %s:/%s',str,wherearewe,pwd);
end	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(str,'del')	
	h = findobj(gcf,'Type','axes'); 
	oldtitle = 0;
	for i = 1 : length(h),
		if (~strcmp(get(h(i),'Tag'),'footnote')),
		else
			oldtitle = h(i);
		end
	end	
	if oldtitle
		delete(oldtitle);
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
else

method = 1;		
switch method	
%%%%%%%%%%%%%%%%%%%%%%	%%%%%%%%%%%%%%%%%%%%%%	%%%%%%%%%%%%%%%%%%%%%%
	case 1
		
	% Fontsize of the footnote text
	fs = get(gcf,'defaultaxesfontsize')-2;	
	haold = gca;
	
	figunits = get(gcf,'units');
	% Fudge factor to adjust y spacing between subplots
	fudge = 1;
	if (~strcmp(figunits,'pixels')),
		set(gcf,'units','pixels');
		pos = get(gcf,'position');
		set(gcf,'units',figunits);
	else,
		pos = get(gcf,'position');
	end
	
	h = findobj(gcf,'Type','axes');  % Change suggested by Stacy J. Hills	
	oldtitle = 0;
	for i = 1 : length(h),
		if (~strcmp(get(h(i),'Tag'),'footnote')),
			pos = get(h(i),'pos');
		else,
			oldtitle = h(i);
		end
	end
	
	np = get(gcf,'nextplot');
	set(gcf,'nextplot','add');
	if oldtitle
		delete(oldtitle);
	end
	ha = axes('pos',[0 0 1 0.01],'visible','off','Tag','footnote');
%	ht = text(0,1,str);set(ht,'horizontalalignment','left','fontsize',fs);
	ht = text(0,1,str);
	set(ht,'horizontalalignment','left','fontsize',fs,'verticalalignment','bottom');
	set(ht,'interpreter','none');
	set(gcf,'nextplot',np);
	axes(haold);
	if nargout >= 1
		varargout(1) = {ht};
	end
	
%%%%%%%%%%%%%%%%%%%%%%	%%%%%%%%%%%%%%%%%%%%%%	%%%%%%%%%%%%%%%%%%%%%%	
	case 2
		
		% Parameters used to position the footnote.

		% Amount of the figure window devoted to subplots
		plotregion = .98;

		% Y position of title in normalized coordinates
		titleypos  = .01;

		% Fontsize of the footnote text
		fs = get(gcf,'defaultaxesfontsize')-2;

		% Fudge factor to adjust y spacing between subplots
		fudge = 1;

		haold    = gca;
		figunits = get(gcf,'units');

		% Get the (approximate) difference between full height (plot + title
		% + xlabel) and bounding rectangle.

		if (~strcmp(figunits,'pixels')),
			set(gcf,'units','pixels');
			pos = get(gcf,'position');
			set(gcf,'units',figunits);
		else,
			pos = get(gcf,'position');
		end
		ff = (fs-4)*1.27*5/pos(4)*fudge;

		% The 5 here reflects about 3 characters of height below
		% an axis and 2 above. 1.27 is pixels per point.

		% Determine the bounding rectange for all the plots

		% h = findobj('Type','axes');   

		% findobj is a 4.2 thing.. if you don't have 4.2 comment out
		% the next line and uncomment the following block.

		h = findobj(gcf,'Type','axes');  % Change suggested by Stacy J. Hills

		max_y=0;
		min_y=1;

		oldtitle = 0;
		for i=1:length(h),
			if (~strcmp(get(h(i),'Tag'),'footnote')),
				pos=get(h(i),'pos');
				if (pos(2) < min_y), min_y=pos(2)-ff/5*3;end;
				if (pos(4)+pos(2) > max_y), max_y=pos(4)+pos(2)+ff/5*2;end;
			else,
				oldtitle = h(i);
			end
		end

		if max_y > plotregion,
			scale = (plotregion-min_y)/(max_y-min_y);
			for i=1:length(h),
				pos = get(h(i),'position');
				pos(2) = (pos(2)-min_y)*scale+min_y;
				pos(4) = pos(4)*scale-(1-scale)*ff/5*3;
				set(h(i),'position',pos);
			end
		end

		np = get(gcf,'nextplot');
		set(gcf,'nextplot','add');
		if (oldtitle),
			delete(oldtitle);
		end
		ha=axes('pos',[0 1 1 1],'visible','off','Tag','footnote');
		ht=text(.5,titleypos-1,str);set(ht,'horizontalalignment','center','fontsize',fs);
		set(gcf,'nextplot',np);
		axes(haold);
		if nargout,
			hout=ht;
		end







end %switch method

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end %if