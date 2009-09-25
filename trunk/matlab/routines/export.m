% EXPORT Export a figure to A4 color EPS format
%
% EXPORT(GCF,[ORIENTATION,FILE])
%
%   Export a figure GCF to A4 color eps format
%   Default output file is: fig.eps in current directory
%   or specify it into FILE (extension .eps is automatic).
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
function []=export(f,varargin)


if (nargin<1)|(nargin>3)
     help export.m
     error('export.m : Wrong number or bad parameter(s)')
     return
end %if

% Default values
fich = 'fig';
orientt = 0 ;

% --------------------------------------------
% 1 parameter input
% --------------------------------------------
if (nargin==2)

 arg = varargin{:};

 % ----------------------
 if ischar(arg) 
     fich = arg;
     orientt = 0;
 else
     fich = 'fig';
     if (arg(1)<0)|(arg(1)>1)
          help export.m
          error('export.m : Wrong number or bad parameter(s)')
          return
      end %if
      switch arg(1)
         case 0
          orientt = 0;
         case 1
          orientt = 1;
      end %switch
 end %if
 % ----------------------

 % ----------------------
 if isnumeric(arg)
      fich = 'fig';   
      if (arg(1)<0)|(arg(1)>1)
          help export.m
          error('export.m : Wrong number or bad parameter(s)')
          return
      end %if
      switch arg(1)
         case 0
          orientt = 0;
         case 1
          orientt = 1;
      end %switch
 end %if
 % ----------------------

end %if 1 parameter

% --------------------------------------------
% 2 parameters
% --------------------------------------------
if (nargin==3)

 arg  = varargin(1); arg=arg{:};
 fich = varargin(2); fich=fich{:};
 if ischar(arg)
     help export.m
     error('export.m : ORIENTATION must be a numeric value')
     return
 elseif isnumeric(fich)
     help export.m
     error('export.m : FILE must be a char value')   
     return
 end %if

 % ----------------------
 if (arg(1)<0)|(arg(1)>1)
     help export.m
     error('export.m : Wrong number or bad parameter(s)')
     return
 end %if
 switch arg(1)
    case 0
     orientt = 0;
    case 1
     orientt = 1;
 end %switch
 % ----------------------

end %if 2 parameters



% --------------------------------------------
% Record
% --------------------------------------------

switch orientt
 case 0
   orient(f,'tall');
   fich = strcat(fich,'.eps');
   print(f,'-depsc2',fich);

 case 1
   orient(f,'landscape');
   fich = strcat(fich,'.eps');
   print(f,'-depsc2',fich);  
   
end %case



