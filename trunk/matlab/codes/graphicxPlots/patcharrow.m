% patcharrow Create a polygon with an arrow for annotation
%
% [h] = patcharrow(height,width,[OPTIONS])
%	Add an arrow to the current axis with tag 'annotationBIGarrow'.
%
% [px,py] = patcharrow(height,width,[OPTIONS])
% 	Create a polygon with an arrow for annotation.
%
% OPTIONS with default values:
% Arrow base position:
%	x0   = 0;
%	y0   = 0;
% Arrow axis angle with horizontal:
%	alpha = 0;
% Arrow colors:
%	facecolor = 'k';
%	edgecolor = facecolor;
%
% Created: 2010-08-26.
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

function varargout = patcharrow(varargin)

%- Default parameters:

% Body width:
bw = 1;
% Body height:
bh = 3;

% Head/Body width ratio:
fc1 = 2;

% Head/Body height ratio:
fc2 = 1.5;

% Head width:
hw = bw*fc1;
% Head height:
hh = bh*fc2;

% Arrow base position:
x0   = 0;
y0   = 0;

% Arrow axis angle with horizontal:
alpha = 0;

% Arrow colors:
facecolor = 'k';
edgecolor = facecolor;

%- Load arguments:
if nargin > 2
	for in = 3 : 2 : nargin
		par = varargin{in};
		val = varargin{in+1};
		eval(sprintf('%s = val;',par));
	end%for in
end

%- Eventually readjust head dimensions with arguments
% Head width:
hw = bw*fc1;
% Head height:
hh = bh*fc2;

%- Create arrow polygon:
px = [-bw/2 -bw/2 -hw/2 0 hw/2 bw/2 bw/2];
py = [0 bh bh bh+hh bh bh 0];

%- Normalize (total height = 1):
px = px./(bh+hh);
py = py./(bh+hh);

%- Scale to what was ask:
h = varargin{1};
w = varargin{2};

%- Adjust arrow polygon:
px = px/abs(xtrm(px)*2)*w;
py = py/abs(xtrm(py))*h;

%- Rotate:
[px py] = rotatepolygon(px,py,alpha);

%- Recenter:
px = px+x0;
py = py+y0;

%- Output/plot
switch nargout
	case {0,1}
		p = patch(px,py,'k');
		set(p,'facecolor',facecolor,'edgecolor',edgecolor);
		set(p,'tag','annotationBIGarrow');
		if nargout == 1
			varargout(1) = {p};
		end
	case 2
		varargout(1) = {px};
		varargout(2) = {py};
end


end %functionpatcharrow


















