% HTITLE = CTITLE(H,'text')
%
% Add text at the top of the colorbar with handle H
%
% Guillaume MAZE - LPO/LMD - March 2004
% Copyright (c) 2004,2008 Guillaume Maze. 

% This file is part of "The-Matlab-Show"
% The-Matlab-Show is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.
% Foobar is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with The-Matlab-Show.  If not, see <http://www.gnu.org/licenses/>.
%
  function varargout = ctitle(h,txt)

if (ischar(txt)==0)
  help colorbartitle
  error('Bad value for text property: String')
  return
end %if

% handle de 'Title' of colorbar
hTitle=get(h,'Title');

% Text already written
Tit_strg=get(hTitle,'String');

% Create new title
New_strg=strcat(txt,' ',Tit_strg);
%New_strg = txt;

% Write
set(hTitle,'String',New_strg);

% ---------------------------------
% OUTPUT VARIABLES
switch nargout
  case 1
   varargout(1) = {hTitle} ;
end
   
