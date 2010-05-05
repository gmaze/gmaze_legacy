% REFRESH Refresh figure
%
%   REFRESH causes the current figure window to be redrawn. 
%   REFRESH(FIG) causes the figure FIG to be redrawn.

%   D. Thomas   5/26/93
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.11.4.4 $  $Date: 2005/12/15 20:54:35 $

function refresh(h)
	
if nargin==1,
    objtype = '';
    try 
        % don't need a catch, we just want to know if this is a figure
        objtype = get(h,'type');
    catch
        if ~isempty(findstr(lasterr,'Invalid handle'))
            rethrow(lasterror)
        end
    end
    
    if ~strcmp(objtype,'figure'),
        error('MATLAB:refresh:InvalidHandle', 'Handle does not refer to a figure object')
    end
else
    h = gcf;
end

% The following toggle of the figure color property is
% only to set the 'dirty' flag to trigger a redraw.
color = get(h,'color');
if ~ischar(color) && all(color == [0 0 0])
    tmpcolor = [1 1 1];
else
    tmpcolor = [0 0 0];
end
set(h,'color',tmpcolor,'color',color);

a = dbstack('-completenames');
fil_caller = a(end).file;
if strfind(fil_caller,getenv('HOME'))
	footnote;
end