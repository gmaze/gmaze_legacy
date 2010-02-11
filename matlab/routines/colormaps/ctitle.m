% CTITLE Display Colorbar title.
%
% HTITLE = CTITLE(H,'text')  
%   
% Add a title to the colorbar
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

  function varargout = ctitle(h,txt)

if (ischar(txt)==0)
  help ctitle
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
   
