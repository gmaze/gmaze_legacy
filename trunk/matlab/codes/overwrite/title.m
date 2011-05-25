% title Custom Graph title
%
%   TITLE('text') adds text at the top of the current axis.
%
%   TITLE('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%   sets the values of the specified properties of the title.
%
%   TITLE(AX,...) adds the title to the specified axes.
%
%   H = TITLE(...) returns the handle to the text object used as the title.
%
%   See also XLABEL, YLABEL, ZLABEL, TEXT.
%
%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 5.14.6.7 $  $Date: 2006/06/27 23:03:09 $%
% Rev. by Guillaume Maze on 2011-02-08: Now modify figure title too (only if not set) !

function hh = title(varargin)

error(nargchk(1,inf,nargin,'struct'));

[ax,args,nargs] = axescheck(varargin{:});
if isempty(ax)
  % call title recursively or call method of Axes subclass
  h = title(gca,varargin{:}); 
  if nargout > 0, hh = h; end
  return;
end

if nargs > 1 && (rem(nargs-1,2) ~= 0)
  error('MATLAB:title:InvalidNumberOfInputs','Incorrect number of input arguments')
end

string = args{1};
pvpairs = args(2:end);

%---Check for bypass option
if isappdata(ax,'MWBYPASS_title')       
   h = mwbypass(ax,'MWBYPASS_title',string,pvpairs{:});

%---Standard behavior      
else
   h = get(ax,'title');

   %Over-ride text objects default font attributes with
   %the Axes' default font attributes.
   set(h, 'FontAngle',  get(ax, 'FontAngle'), ...
          'FontName',   get(ax, 'FontName'), ...
          'FontUnits',  get(ax, 'FontUnits'), ...
          'FontSize',   get(ax, 'FontSize'), ...
          'FontWeight', get(ax, 'FontWeight'), ...
          'Rotation',   0, ...
          'string',     string, pvpairs{:});

	% Rev. by Guillaume Maze on 2011-02-08: Modify figure title
	pa = get(ax,'parent');
	if strcmp(get(pa,'type'),'figure')
		ch = allchild(pa);
		 % Exclude colorbar, footnote, etc:
		ch = setdiff(ch,[findall(ch,'tag','footnote') findall(ch,'tag','colorbar') findall(ch,'tag','suptitle')]);
		overw = true;
		if length(ch) ~= 1 
			% We have more than one plot on the figure, so we don't overwrite figure's name
			% User should use suptitle instead
			overw = false;
		end		
		% Check if this is the first of a subplot set:
		if ~isempty(getappdata(pa,'SubplotGrid'))
			overw = false;
		end
		
		% Update Figure's name
		if isempty(get(pa,'name')) & overw
			figname = string;
			set(pa,'name',figname)
		end
	end%if simple case, parent is a figure handle

end

if nargout > 0
  hh = h;
end

















