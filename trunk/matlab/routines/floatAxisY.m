function [hl1,ax2,ax3] = floatAxisY(varargin)
% floatAxisY  create floating x-axis for multi-parameter plot
% =========================================================================
% floatAxisY  Version 1.2 6-Mar-2000
%
% Usage: 
%   [h1,ax2,ax3] = floatAxisY(varargin)
%
% Description:
%   This Matlab function creates a floating y-axis for mutli-parameter
%   plots with different units on the same figure. For example, in oceanography,
%   it is common to plot temperature, salinity, and density versus depth.
%
%
% Input:
%   A minimum of two parameters is required. The first and second parameters are
%   the x,y pairs to plot. The third parameter (optional) specifies the linestyle
%   (defaults to 'k-' solid black). The fourth parameter (optional) specifies the
%   y-axis label for the floating axis. The fifth parameter (optional) specifies 
%   the x and y limits for the axis(this should be of the form 
%   [xlower xupper ylower yupper]).
%
% Output:
%   n/a
%
% Called by:
%   CTDplotY.m - script to demo floatAxis function
%
% Calls:
%   n/a
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   18-May-1999
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% History
% Version 1.0 18-May-1999
% Version 1.1 31-May-1999
%    Added the ability to pass an array containing the x and y limits for
%    the axis.
% Version 1.2 6-Mar-2000
%    Added code to handle data with different x-limits. Previous versions
%    assumed all data had the same x-limits. Oops! Thanks to Jan Even Nilsen
%    (even@gfi.uib.no) for pointing this out.


% strip the arguments passed in
if (nargin < 2)
   error('floatAxis requires a minimum of three parameters')
elseif (nargin == 2)
   x = varargin{1};
   y = varargin{2};
   % default lines style (solid black line) 
   lstyle = 'k-';   
elseif (nargin == 3)
   x = varargin{1};
   y = varargin{2};  
   lstyle = varargin{3};
elseif (nargin == 4)
   x = varargin{1};
   y = varargin{2};
   lstyle = varargin{3};
   ylbl = varargin{4};
elseif (nargin == 5)
   x = varargin{1};
   y = varargin{2};
   lstyle = varargin{3};
   ylbl = varargin{4};
   limits = varargin{5};
else
   error('Too many arguments')
end

% get position of axes
allAxes = get(gcf,'Children');
allAxes = setdiff(allAxes,findobj(gcf,'tag','footnote'));
allAxes = setdiff(allAxes,findobj(gcf,'tag','suptitle'));
ax1Pos  = get(allAxes(length(allAxes)),'position');

% rescale and reposition all axes to handle additional axes
for ii = 1:length(allAxes)-1
   if (rem(ii,2)==0) 
      % even ones in array of axes handles represent axes on which lines are plotted
      set(allAxes(ii),'Position',[ax1Pos(1)+0.1 ax1Pos(2) ax1Pos(3)-0.1 ax1Pos(4)])
   else
      % odd ones in array of axes handles represent axes on which floating x-axss exist
      axPos = get(allAxes(ii),'Position');
      set(allAxes(ii),'Position',[axPos(1)+0.1 axPos(2) axPos(3) axPos(4)])
   end
end
% first axis a special case (doesn't fall into even/odd scenario of figure children)
set(allAxes(length(allAxes)),'Position',[ax1Pos(1)+0.1 ax1Pos(2) ax1Pos(3)-0.1 ax1Pos(4)])
xlimit1 = get(allAxes(length(allAxes)),'Xlim');

% get new position for plotting area of figure
ax1Pos = get(allAxes(length(allAxes)),'position');

% axis to which the floating axes will be referenced
ref_axis = allAxes(1);
refPosition = get(ref_axis,'position');

% overlay new axes on the existing one
ax2 = axes('Position',ax1Pos);
% plot data and return handle for the line
hl1 = plot(x,y,lstyle);
% make the new axes invisible, leaving only the line visible
set(ax2,'visible','off','xlim',xlimit1)

if (nargin < 5)
   % get the y limits for the 
   ylimit = get(ax2,'YLim');
else
   set(ax2,'XLim',[limits(1) limits(2)],'YLim',[limits(3) limits(4)]);
end

% set the axis limit mode so that it does not change if the
% user resizes the figure window
set(ax2,'YLimMode','manual')

% set up another set of axes to act as floater
ax3 = axes('Position',[refPosition(1)-0.1 refPosition(2) 0.01 refPosition(4)]);
set(ax3,'box','off','ycolor','w','xticklabel',[],'xtick',[])
set(ax3,'YMinorTick','on','color','none','ycolor',get(hl1,'color'))
if (nargin < 5)
   set(ax3,'YLim',ylimit)
else
   set(ax3,'XLim',[limits(1) limits(2)],'YLim',[limits(3) limits(4)])
end

% label the axis
if (nargin > 3)
   ylabel(ylbl)
end

