% is_in_box Identify points inside a geographical domain or box
%
% I = is_in_box(BOX,x,y)
% 
% Determine indeces I in the list of points (x,y) which
% are inside the polygon defined by [BOX.lon,BOX.lat]
%
% Created: 2013-03-14.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
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
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
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

function iplist = is_in_box(BOX,x,y)

%
typ = get_box_typ(BOX);

% BOX.lon and BOX.lat define a polygon
polyX = BOX.lon;
polyY = BOX.lat;	

switch typ
	case 0 % This polygon is 'regular', simply ensure we use the same unit
		polyX = convX(polyX,1);
		x     = convX(x,1);
		
	case 1 % this polygon passes through the Greenwich meridian 
		polyX = convX(polyX,0);
		x     = convX(x,0);
		
	case 2 % this polygon passes through the ante meridian 
		polyX = convX(polyX,1);
		x     = convX(x,1);
		
end% switch 

iplist = find(inpolygon(x,y,polyX,polyY)==1);

end %functionis_in_box


function typ = get_box_typ(BOX)
	
	% BOX.lon and BOX.lat define a polygon
	polyX = BOX.lon;
	polyY = BOX.lat;
	
	% Regular type:
	typ = 0;
	
	% Irregular type 1: Does this polygon passes through the Greenwich meridian ?
	n = 100;
	if ~isempty(find(inpolygon(0*ones(1,n),linspace(-90,90,n),polyX,polyY)==1))
		typ = 1;
		return;
	end% if
	
	% Irregular type 2: Does this polygon passes through the ante meridian ?
	n = 100;
	if ~isempty(find(inpolygon(-180*ones(1,n),linspace(-90,90,n),polyX,polyY)==1))
		typ = 2;
		return;
	end% if 


end%end function
