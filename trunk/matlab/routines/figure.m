% FIGURE


function varargout = figure(varargin)

%posi = [8 63 800 448];

% Get static screen size:
si = get(0,'ScreenSize' );

% New dimension:
dx = 620;
dy = 440;
posi = [si(3)/4-dx/2 si(4)/2-dy/2 dx dy];

if isempty(nargin)     
	f = builtin('figure');
%	posi = get(gcf,'position'); posi = [posi(1)-dx/2 posi(2)-dy/2 posi(3)+dx posi(4)+dy];
	set(gcf,'position',posi);
else
	f = builtin('figure',varargin{:});
%	posi = get(gcf,'position'); posi = [posi(1)-dx/2 posi(2)-dy posi(3)+dx posi(4)+dy];
	set(gcf,'position',posi)
end
set(gcf,'menubar','none');

footnote;

if nargout==1
       varargout(1) = {f};
end

