% WHEREAREWE Give a back a string function of your location
%
% LOCATION = wherearewe()
%
% This function (you need to customize) gives back
% a string based on the output of getcomputername.
% This is useful if you run your scripts on different
% system or network.
%
% LOCATION could be:
%	csail_mit
%	ocean
%	altix
%	csail_ao
%	beagle
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

function varargout = wherearewe(varargin)


thisnam = getcomputername;
thisnam = lower(thisnam);
 
weare = '';

if strfind(thisnam,'hugo') 
	weare = 'csail_mit';
end
if strfind(thisnam,'tolkien') 
	weare = 'csail_mit';
end
if strfind(thisnam,'eddy') 
	weare = 'csail_mit';
end
if strfind(thisnam,'chassiron')
	weare = 'csail_mit';
end

if strfind(thisnam,'ocean') 
	weare = 'ocean';
end
if strfind(thisnam,'ross') 
	weare = 'ocean';
end
if strfind(thisnam,'weddell')
	weare = 'ocean';
end
	
if strfind(thisnam,'altix')
	weare = 'altix';
end
		
if strfind(thisnam,'ao')		
	weare = 'csail_ao';
end
		
if strfind(thisnam,'beagle') 
	weare = 'beagle';
end
if strfind(thisnam,'darwin') 
	weare = 'beagle';
end
if strfind(thisnam,'compute') 
	if strfind(thisnam,'local') 
		weare = 'beagle';
	end
end





if isempty(weare)
	error('Can''t find where we are !');
else
	varargout(1) = {weare};
end

