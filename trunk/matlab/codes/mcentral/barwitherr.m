%barwitherr Make a bar plot with errors
%
%	[bh eh] = barwitherr(err,val);
%
%   This is a simple extension of the bar plot to include error bars.  It
%   is called in exactly the same way as bar but with an extra input
%   parameter "errors" passed first.
%
%   Parameters:
%   errors - the errors to be plotted
%   varargin - parameters as passed to conventional bar plot
%   See bar and errorbar documentation for more details.
%
%   Example:
%   y = randn(3,4);         % random y values (3 groups of 4 parameters) 
%   errY = 0.1.*y;          % 10% error
%   barwitherr(errY, y);    % Plot with errorbars
%
%   set(gca,'XTickLabel',{'Group A','Group B','Group C'})
%   legend('Parameter 1','Parameter 2','Parameter 3','Parameter 4')
%   ylabel('Y Value')
%
%   Note: Ideally used for group plots with non-overlapping bars because it
%   will always plot in bar centre (so can look odd for over-lapping bars) 
%   and for stacked plots the errorbars will be at the original y value is 
%   not the stacked value so again odd appearance as is.
%
%   24/02/2011  Created     Martina F. Callaghan
% Rev. by Guillaume Maze on 2011-03-24: Added handle outputs
%
%**************************************************************************

function varargout = barwitherr(errors,varargin)

% Check how the function has been called based on requirements for "bar"
if nargin < 3
    % This is the same as calling bar(y)
    values = varargin{1};
else
    % This means extra parameters have been specified
    if isscalar(varargin{2}) || ischar(varargin{2})
        % It is a width / property so the y values are still varargin{1}
        values = varargin{1};
    else
        % x-values have been specified so the y values are varargin{2}
        values = varargin{2};
    end
end

% Check that the size of "errors" corresponsds to the size of the y-values:
if any(size(values) ~= size(errors))
    error('The values and errors have to be the same length')
end

[nRows nCols] = size(values);
bh = bar(varargin{:}); % standard implementation of bar fn
hold on

if nRows > 1
    for col = 1:nCols
        % Extract the x location data needed for the errorbar plots:
        x = get(get(bh(col),'children'),'xdata');
        % Use the mean x values to call the standard errorbar fn; the
        % errorbars will now be centred on each bar:
        eh(col) = errorbar(mean(x,1),values(:,col),errors(:,col), '.k');
    end
else
    x = get(get(bh,'children'),'xdata');
    eh = errorbar(mean(x,1),values,errors,'.k');
end

hold off

switch nargout
	case 1, 
		varargout(1) = {bh};
	case 2
		varargout(1) = {bh};
		varargout(2) = {eh};
end% switch 


end%function