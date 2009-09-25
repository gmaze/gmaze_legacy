% EXPORTJ Export a figure to A4 color PNG format
%
% EXPORTJ(GCF,[ORIENTATION,FILE])
%
%   Export a figure GCF to A4 color png format
%   Default output file is: fig.png in current directory
%   or specify it into FILE (extension .png is automatic).
%   ORIENTATION is an optionnal parameter:
%       ORIENTATION=0 : Portrait (default)
%       ORIENTATION=1 : Landscape
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

function []=exportj(f,varargin)

if (nargin<1)|(nargin>3)
     help exportj.m
     error('exportj.m : Wrong number or bad parameter(s)')
     return
end %if

% Default values
fich   = 'fig';
orient = 0 ;

% --------------------------------------------
% 1 seul para optionnel
% --------------------------------------------
if (nargin==2)

 arg = varargin{:};

 % ----------------------
 if ischar(arg) 
     fich   = arg;
     orient = 0;
 else
     fich = 'fig';
     if (arg(1)<0)|(arg(1)>2)
          help exportj.m
          error('exportj.m : Wrong number or bad parameter(s)')
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
          help exportj.m
          error('exportj.m : Wrong number or bad parameter(s)')
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
if (nargin==3)

 arg  = varargin(1); arg=arg{:};
 fich = varargin(2); fich=fich{:};
 if ischar(arg)
     help exportj.m
     error('exportj.m : ORIENTATION must be a numeric value')
     return
 elseif isnumeric(fich)
     help exportj.m
     error('exportj.m : FILE must be a char value')   
     return
 end %if

 % ----------------------
 if (arg(1)<0)|(arg(1)>2)
     help exportj.m
     error('exportj.m : Wrong number or bad parameter(s)')
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

%fich=strcat(fich,'.jpg');
%print(f,'-djpeg99',fich);
fich=strcat(fich,'.png');
print(f,'-dpng',fich);

set(f,'Position',posi)
