function h = refline(slope,intercept,varargin)
% REFLINE Add a reference line to a plot.
%   REFLINE(SLOPE,INTERCEPT,[LINE_OPTIONS]) adds a line with the given SLOPE and
%   INTERCEPT to the current figure.
%
%   REFLINE(SLOPE) where SLOPE is a two element vector adds the line
%        y = SLOPE(2) + SLOPE(1)*x 
%   to the figure. (See POLYFIT.)
%
%   H = REFLINE(SLOPE,INTERCEPT,[LINE_OPTIONS]) returns the handle to the line object
%   in H.
%
%   REFLINE with no input arguments superimposes the least squares line on 
%   the plot based on points recognized by LSLINE.
%
%   See also POLYFIT, POLYVAL, LSLINE. 
%
% Rev. by Guillaume Maze on 2011-02-10: Add tag 'refline' to the line
% Rev. by Guillaume Maze on 2011-02-10: Add line options
%	LINE_OPTIONS: Any options pair to a line object
  
%   Copyright 1993-2008 The MathWorks, Inc. 
%   $Revision: 2.8.2.2 $  $Date: 2008/02/29 13:12:23 $

if nargin == 0
   hh = lsline;
   set(hh,'tag','refline');
   if nargout > 0
       h = hh;
   end
   return;
end

if nargin == 1
   if max(size(slope)) == 2
      intercept=slope(2);
      slope = slope(1);
   else
      intercept = 0;
   end
end

xlimits = get(gca,'Xlim');
ylimits = get(gca,'Ylim');

np = get(gcf,'NextPlot');
set(gcf,'NextPlot','add');

xdat = xlimits;
ydat = intercept + slope.*xdat;
maxy = max(ydat);
miny = min(ydat);

if maxy > ylimits(2)
  if miny < ylimits(1)
     set(gca,'YLim',[miny maxy]);
  else
     set(gca,'YLim',[ylimits(1) maxy]);
  end
else
  if miny < ylimits(1)
     set(gca,'YLim',[miny ylimits(2)]);
  end
end

if nargout >= 1
   h = line(xdat,ydat,'tag','refline');
   set(h,'LineStyle','-');
   if nargin > 2, set(h,varargin{:});end
else
   hh = line(xdat,ydat,'tag','refline');
   set(hh,'LineStyle','-');
   if nargin > 2, set(hh,varargin{:});end
end

	
set(gcf,'NextPlot',np);
