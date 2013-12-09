function popd
%POPD Pops you back up in the PUSHD stack
%
%   See also pushd, cd, pwd

% Author: Peter Bodin (PB)
% pbodin@kth.se
% Created: Jul 2005
% Updated 2005-08-09
% Changes:
% Added stack functionality


% <BEGIN LICENCE>
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
% <END LICENCE>

if isempty(getpref('pushd','pushed'))
    %warning('You have reached the end of the PUSHD stack, I have nowhere to pop!');
elseif ~isempty(getpref('pushd','pushed')) & strcmp(getpref('pushd','pushed'),'£*$*£')
    setpref('pushd','pushed',[]);
    popd
elseif  ispref('pushd','pushed')
    [wheretopop,remainingstack]=(strtok(fliplr(getpref('pushd','pushed')),'£*$*£'));
    wheretopop=fliplr(wheretopop);
    remainingstack=fliplr(remainingstack);
    setpref('pushd','pushed',remainingstack);
    try
    cd(wheretopop);
    catch
            warning(lasterr)
    end
else
    warning('You haven´t used PUSHD, I have nowhere to pop!');
end
