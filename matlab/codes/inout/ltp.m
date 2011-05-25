% ltp List directory as ls -rtl
%
% [] = ltp([dir])
% 
%   LTP displays the results of the 'ls -rtl' command on UNIX. On UNIX, 
%   LTP returns a character row vector of filenames separated 
%   by tab and space characters. On Windows, LTP returns an m-by-n 
%   character array of filenames, where m is the number of filenames 
%   and n is the number of characters in the longest filename found. 
%   Filenames shorter than n characters are padded with space characters.
%
%   You can pass any flags to LTP as well that your operating system supports.
%
%   See also DIR, MKDIR, RMDIR, FILEATTRIB, COPYFILE, MOVEFILE, DELETE.
%
%
% Created: 2009-07-20.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout=ltp(varargin)
	
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.17.4.5 $  $Date: 2005/12/01 03:10:41 $
%=============================================================================
% validate input parameters
if iscellstr(varargin)
    args = strcat({' '},varargin);
else
    error('Inputs must be strings.');
end

% check output arguments
if nargout > 1
    error('MATLAB:LS:TooManyOutputArguments','Too many output arguments.')
end

% perform platform specific directory listing
if isunix
    if nargin == 0
        [s,listing] = unix('ls -lrt');
    else
        [s,listing] = unix(['ls -lrt', args{:}]);
    end
    
    if s~=0
        error('MATLAB:ls:OSError',listing);
    end
else
    if nargin == 0
        %hack to display output of dir in wide format.  dir; prints out
        %info.  d=dir does not!
        if nargout == 0
            dir;
        else
            d = dir;
            listing = char(d.name);
        end
    elseif nargin == 1
        if nargout == 0
            dir(varargin{1});
        else
            d = dir(varargin{1});
            listing = char(d.name);
        end
    else
        error('Too many input arguments.')
    end
end

% determine output mode, depending on presence of output arguments
if nargout == 0 && isunix
    disp(listing)
elseif nargout > 0
    varargout{1} = listing;
end
%=============================================================================