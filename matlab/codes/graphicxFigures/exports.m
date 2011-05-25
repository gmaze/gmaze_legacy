% exports Export a figure to A4 color PDF format
%
% exports(GCF,[ORIENTATION,FILE,KEEPFOOTNOTE])
%
%   Export a figure GCF to A4 color eps format
%   Default output file is: fig.eps in current directory
%   or specify it into FILE (extension .eps is automatic).
%   ORIENTATION is an optionnal parameter:
%       ORIENTATION=0 : Portrait (default)
%       ORIENTATION=1 : Landscape
%
%
% Created: 2009-04-22.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function []=exports(f,varargin)

if (nargin<1)|(nargin>4)
     help exports.m
     error('exports.m : Wrong number or bad parameter(s)')
end %if

% File name without extension:
fich   = 'fig'; % to produce: 'fig.eps'

% Figure orientation:
orient = 0; % Portrait

% Arguments to print command:
pcom = '-depsc2';

% File extension:
ext = 'eps'; 

% --------------------------------------------
% 1 optionnal input:
% --------------------------------------------
if (nargin>=2)

 arg = varargin{:};

 % ----------------------
 if ischar(arg) 
     fich   = arg;
     orient = 0;
 else
     fich = 'fig';
     if (arg(1)<0)|(arg(1)>2)
          help exports.m
          error('exports.m : Wrong number or bad parameter(s)')
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
 % if isnumeric(arg)
 %      fich = 'fig';
 %      if (arg(1)<0)|(arg(1)>2)
 %          help exports.m
 %          error('exports.m : Wrong number or bad parameter(s)')
 %          return
 %      end %if
 %      switch arg(1)
 %         case 0
 %          orient = 0;
 %         case 1
 %          orient = 1;
 %         case 2
 %          orient = 2;
 %      end %switch
 % end %if
 % ----------------------

end %if

% --------------------------------------------
% 2 para optionnels
% --------------------------------------------
if (nargin>=3)

 arg  = varargin(1); arg=arg{:};
 fich = varargin(2); fich=fich{:};
 if ischar(arg)
     help exports.m
     error('exports.m : ORIENTATION must be a numeric value')
     return
 elseif isnumeric(fich)
     help exports.m
     error('exports.m : FILE must be a char value')   
     return
 end %if

 % ----------------------
 if (arg(1)<0)|(arg(1)>2)
     help exports.m
     error('exports.m : Wrong number or bad parameter(s)')
     return
 end %if
 switch arg(1)
    case 0
     orient=0;
    case 1
     orient=1;	
    case 2
     orient=2;
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
% Output eps file name:
outfile = strcat(fich,'.',ext);

% --------------------------------------------
% Manage figure size and orientation:
posi = get(f,'Position');

switch orient
 case 0 % PORTRAIT
	set(f,'PaperUnits','centimeters','PaperType','A4');
	set(f,'PaperPositionMode','manual');
	set(f,'PaperPosition',[0.1 0.1 20.5 29]);
	set(f,'PaperOrientation','portrait');
 case 1 % LANDSCAPE
	set(f,'PaperUnits','centimeters','PaperType','A4');
	set(f,'PaperPositionMode','manual');
	set(f,'PaperOrientation','landscape');
 case 2
	set(f,'PaperOrientation','portrait');
end %case

% --------------------------------------------
% Read the footnote:
footnoteTXT = get(findobj(f,'tag','footnotetext'),'string');
if ischar(footnoteTXT)
	for il = 1 : size(footnoteTXT,1) 
		c(il) = {footnoteTXT(il,:)};
	end
	footnoteTXT = c;
end

% Add the eps file name to the footnote:
if  length(footnoteTXT) > 1
	txt = sprintf(' %s',outfile);
	for il = 1 : length(footnoteTXT)
		txt = sprintf('%s\n%s',txt,footnoteTXT{il});
	end
else
	txt = sprintf(' %s\n%s',outfile,footnoteTXT{1});
end

% Update footnote text:
if keepfootnote 
	set(findobj(f,'tag','footnotetext'),'string',txt)
	algnfootnote;
else
	delete(findobj(f,'tag','footnotetext'));
%	set(findobj(f,'tag','footnotetext'),'string','')
end

% --------------------------------------------
% Print out file:
print(f,pcom,outfile);
disp(sprintf('Figure %i saved in %s',f,outfile));

% We store in the figure datas informations about the export for later reuse:
setappdata(f,'eps_file',strcat(fich,'.',ext))
setappdata(f,'eps_file_orientation',orient);

% Restore figure position and footnote text:
set(f,'Position',posi)
footnote('');
set(findobj(f,'tag','footnotetext'),'string',footnoteTXT)




