% ahline Draw a horizontal line on a plot and print value on the y-axis
%
% [h,t] = ahline([Y,STYLE])
% 
% Draw a horizontal line on a plot and print value on the y-axis.
% Style apply to both the line and the text.
%
% Inputs:
%	Y: intersection of the line with the y-axis
%		By default it is set to: y=0
% 	STYLE: is any pair of properties for a line and/or text object.
%		Default is plain black. 
%
% Outputs:
%	h: line handle
%	t: text handle
% 
% Example:
%	ahline(3,'color','r')
%	ahline(3,'color','r','linewidth',12,'fontsize',20,'linestyle','--')
%
% See also:
%	hline, vline, refline
%
% Created: 2011-03-08.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = ahline(varargin)

% Default line style:
style = {'color';'k'};

% Default position on the y-axis:
y0 = 0;

switch nargin
	case 0
		% Nothing to do
	case 1
		y0    = varargin{1};
	otherwise
		if mod(nargin,2) ~= 0
			y0    = varargin{1};
			style = varargin(2:end);
		else
			style = varargin(:);
		end
end

for iy = 1 : length(y0)
	% Plot line:
	l(iy) = line(get(gca,'xlim'),[1 1]*y0(iy));
	set(l(iy),'tag','hline');
	for is = 1 : 2 : length(style)
		try
			set(l(iy),style{is},style{is+1});
		end%try
	end% for is
	
	% Add text:
	switch get(gca,'yaxislocation')
		case 'left'
			tt(iy) = text(min(get(gca,'xlim')),y0(iy),num2str(y0(iy)),'tag','hline');		
			set(tt(iy),'verticalAlignment','middle','horizontalAlignment','right');						
		case 'right'
			tt(iy) = text(max(get(gca,'xlim')),y0(iy),num2str(y0(iy)),'tag','hline');		
			set(tt(iy),'verticalAlignment','middle','horizontalAlignment','left');
	end% switch 
	for is = 1 : 2 : length(style)
		try
			set(tt(iy),style{is},style{is+1});
		end%try
	end% for is	
	
end

switch nargout
	case 1
		varargout(1) = {l};
	case 2
		varargout(1) = {l};
		varargout(2) = {tt};
end% switch 



end %functionahline