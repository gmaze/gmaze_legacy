% FOPENN Open a file whithout taking care of slash in file name
%
% This the same function as the built-in but before calling it,
% a test on the filename format is done: / on unix system are replaced
% by \ of windows if the 'computer' Matlab command return PCWIN.
%
%    See also FOPEN, FCLOSE, FREWIND, FREAD, FWRITE, FPRINTF.
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

function varargout = fopenn(ffile,varargin)

if ispc
   ffile(findstr(ffile,'/'))='\';
end
   
[FID, MESSAGE] = fopen(ffile,varargin{:});

switch nargout
  case 1
    varargout(1) = {FID};
  case 2
    varargout(1) = {FID};
    varargout(2) = {MESSAGE};
end

