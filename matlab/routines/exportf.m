% exportf Export a figure to A4 color PDF format
%
% exportf(GCF,[ORIENTATION,FILE,FOOTNOTE])
%
%   Export a figure GCF to A4 color pdf,png anf eps formats.
%
%   Default output files are: fig.pdf, fig.png and fig.eps in current directory
%   or specify it into FILE (extensions are automatic).
%
%   ORIENTATION is an optionnal parameter:
%       ORIENTATION=0 : Portrait (default)
%       ORIENTATION=1 : Landscape
%
%	FOOTNOTE = 1(default)/0 indicates if we keep the footnote or not
%
% Created: 2009-07-21.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function []=exportf(f,varargin)

if (nargin<1)|(nargin>4)
     help exportf.m
     error('exportf.m : Wrong number or bad parameter(s)')
     return
end %if

% Default values
fich = 'fig';
orient = 0 ;

% --------------------------------------------
% 1 seul para optionnel
% --------------------------------------------
if (nargin>=2)

 arg = varargin{:};

 % ----------------------
 if ischar(arg) 
     fich = arg;
     orient = 0;
 else
     fich = 'fig';
     if (arg(1)<0)|(arg(1)>2)
          help exportf.m
          error('exportf.m : Wrong number or bad parameter(s)')
          return
      end %if
      switch arg(1)
         case 0
          orient = 0;
         case 1
          orient = 1;
         case 2
          orient = 2;
      end %switch
 end %if
 % ----------------------

 % ----------------------
 if isnumeric(arg)
      fich = 'fig';
      if (arg(1)<0)|(arg(1)>2)
          help exportf.m
          error('exportf.m : Wrong number or bad parameter(s)')
          return
      end %if
      switch arg(1)
         case 0
          orient = 0;
         case 1
          orient = 1;
         case 2
          orient = 2;
      end %switch
 end %if
 % ----------------------

end %if

% --------------------------------------------
% 2 para optionnels
% --------------------------------------------
if (nargin>=3)

 arg  = varargin(1); arg=arg{:};
 fich = varargin(2); fich=fich{:};
 if ischar(arg)
     help exportf.m
     error('exportf.m : ORIENTATION must be a numeric value')
     return
 elseif isnumeric(fich)
     help exportf.m
     error('exportf.m : FILE must be a char value')   
     return
 end %if

 % ----------------------
 if (arg(1)<0)|(arg(1)>2)
     help exportf.m
     error('exportf.m : Wrong number or bad parameter(s)')
     return
 end %if
 switch arg(1)
    case 0
     orient=0;
    case 1
     orient=1;	
    case 2
     orient = 2;
 end %switch
 % ----------------------

end %if

% --------------------------------------------
if nargin >= 4
	keepfootnote = varargin{3};
else
	keepfootnote = 1;
end

% --------------------------------------------
% Record
% --------------------------------------------
posi=get(f,'Position');

switch orient
 case 0
	set(f,'PaperUnits','centimeters','PaperType','A4');
	set(f,'PaperPositionMode','manual');
	set(f,'PaperPosition',[0.1 0.1 20.5 29]);
	set(f,'PaperOrientation','portrait');
 case 1
	set(f,'PaperUnits','centimeters','PaperType','A4');
	set(f,'PaperPositionMode','manual');
	set(f,'PaperOrientation','landscape');
 case 2
	set(f,'PaperOrientation','portrait');
end %case

footnoteTXT = get(findobj(gcf,'tag','footnotetext'),'string');
if ischar(footnoteTXT)
	for il = 1 : size(footnoteTXT,1) 
		c(il) = {footnoteTXT(il,:)};
	end
	footnoteTXT = c;
end

for iformat = 1 : 3
	switch iformat
		case 1, ext = 'png'; pcom = '-dpng';
		case 2, ext = 'pdf'; pcom = '-dpdf';
		case 3, ext = 'eps'; pcom = '-depsc2';
	end
	if length(footnoteTXT) > 1
		txt = sprintf(' %s.%s',fich,ext);
		for il = 1 : length(footnoteTXT)
			txt = sprintf('%s\n%s',txt,footnoteTXT{il});
		end
	else
		txt = sprintf(' %s\n%s',strcat(fich,'.',ext),footnoteTXT{1});
	end
	if keepfootnote 
		set(findobj(gcf,'tag','footnotetext'),'string',txt)
	else
		set(findobj(gcf,'tag','footnotetext'),'string','')
	end
	print(f,pcom,strcat(fich,'.',ext));
end%for iformat


set(findobj(gcf,'tag','footnotetext'),'string',footnoteTXT)
set(f,'Position',posi)
disp(sprintf('Figure %i saved in %s.<png><pdf><eps>',f,fich));
disp(sprintf('! open %s.pdf',fich));






