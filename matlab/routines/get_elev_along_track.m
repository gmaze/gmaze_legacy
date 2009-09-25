% elev_along_track Determine topogrpahy along ship track
%
% h = elev_along_track(x,y)
% 
% Determine the bathymetry along the track given
% by vectors x,y.
%
%
% Created: 2009-06-16.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = get_elev_along_track(varargin)

x = varargin{1};
y = varargin{2};
if nargin == 3
	N = varargin{3};
else
	N = Inf;
end

if isinf(N)
	X = x;
	Y = y;
else
%	X = interp1(1:length(x),x,1:N);
%	Y = interp1(1:length(y),y,1:N);
	a = linspace(1,length(x),N);
	X = interp1(1:length(x),x,a,'spline');
	Y = interp1(1:length(y),y,a,'spline');
end


for ipt = 1 : length(X)
	[el b c] = m_elev([X(ipt)*[1 1] Y(ipt)*[1 1]]);
	BAT(ipt) = nanmean(nanmean(el));
end

switch nargout
	case 1
		varargout(1) = {BAT};
	case 2
		varargout(1) = {BAT};
		varargout(2) = {[X;Y]};
	otherwise
		figure
		iw=2;jw=1;
		subplot(iw,jw,1);plot(x,y,'+');
		subplot(iw,jw,2);plot(BAT);xlabel('Station numbers');ylabel('Depth (m)');
end



end %function