% drawpoly Draw a polygon on a map (using m_map)
%
% [LON LAT HL] = drawmpoly;
% 
% Draw a polygon on a map by mouse clicks and return coordinates
% of the closed polygon.
%
% Outputs:
%	LON: Longitude of the polygon points
%	LAT: Latitude of the polygon points
%	HL: Handle of the polygon plotted on the map
%
% Use
% 	delete(findobj(gcf,'tag','drawmpoly'));
% to remove all polygons from the map.
% 
% Created: 2010-05-05.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = drawmpoly(varargin)

hold on
disp('<left click> to valide a point')
disp('<right click> to remove the last one ')
disp('<middle click> to close the polygon, clear it from the map and return coordinates')
disp('<return> to close the polygon, leave it on the map and return coordinates')

n = 1;
[x y but] = ginput(1);
[lon(n) lat(n)] = m_xy2ll(x,y);
delete(findobj(gcf,'tag','drawmpoly')); p = m_plot(lon,lat,'r-o');set(p,'tag','drawmpoly');drawnow;

done = 0;
while done ~= 1
	n = n + 1;
	[x y but] = ginput(1);
	if ~isempty(but)
		switch but
			case 1
				[lon(n) lat(n)] = m_xy2ll(x,y);
				delete(findobj(gcf,'tag','drawmpoly')); p = m_plot(lon,lat,'r-o'); set(p,'tag','drawmpoly');drawnow
			case 2
				[lon(n) lat(n)] = m_xy2ll(x,y);
				delete(findobj(gcf,'tag','drawmpoly')); p = m_plot(lon,lat,'r-o'); set(p,'tag','drawmpoly');drawnow
				done = 1; cle = 1;
			case 3
				n = n - 2; lon=lon(1:n);lat=lat(1:n);
				delete(findobj(gcf,'tag','drawmpoly'))
				delete(findobj(gcf,'tag','drawmpoly')); p = m_plot(lon,lat,'r-o'); set(p,'tag','drawmpoly');drawnow			
			otherwise
				done = 1; cle = 1;
		end%switch		
		
	else % We pressed <return>
		n = n - 1;
		done = 1; cle = 0;
	end
end

% close the polygon:
n = n + 1;
lon(n) = lon(1);
lat(n) = lat(1);
delete(findobj(gcf,'tag','drawmpoly')); p = m_plot(lon,lat,'r-o'); set(p,'tag','drawmpoly');drawnow

% And remove the plot:
if cle == 1
	delete(findobj(gcf,'tag','drawmpoly'))
end

% 
switch nargout
	case 1
		varargout(1) = {lon};
	case 2
		varargout(1) = {lon};
		varargout(2) = {lat};
	case 3
		varargout(1) = {lon};
		varargout(2) = {lat};
		varargout(3) = {p};
	case 4
		varargout(1) = {lon};
		varargout(2) = {lat};
		varargout(3) = {p};
		varargout(4) = {but};
end

end %functiondrawpoly








