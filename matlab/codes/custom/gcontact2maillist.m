% GCONTACT2MAILIST Removed < and > from a Google contacts list
%
% Created by Guillaume Maze on 2008-10-23.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function varargout = gcontact2mailist(varargin)



listfile = varargin{1};

fid = fopen(listfile);
tline = fgetl(fid);

i1 = strfind(tline,'<');
i2 = strfind(tline,'>');


listo = '';
for ii = 1 : length(i1)
	thisone = tline(i1(ii)+1:i2(ii)-1);
	listo = sprintf('%s\n%s',listo,thisone);
end
%listo = listo(2:end);

varargout(1) = {listo};







