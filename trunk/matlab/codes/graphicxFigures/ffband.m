% ffband White background thin landscape figure
%
% [] = ffband()
% 
% Change gcf figure to white background, thin, full screen wide and landscape.
%
% Created: 2011-06-24.
% Rev. by Guillaume Maze on 2012-12-21: Change name from figure_band to ffband
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

function varargout = ffband(num)
	
if nargin == 0;
	num = gcf;
else
%	builtin('figure',num); num = gcf;
%	num = figure;
end

sic = get(0,'MonitorPositions');

orient landscape
posi = get(num,'position');
%set(num,'Position',[0  posi(2)-(num-1)*20 sic(3) 330])
set(num,'Position',[70 posi(2)-(num-1)*20 sic(3)-70 330])

%set(gcf,'Position',[2+10*(num-1) 225-10*(num-1) 800 620])

if get(num,'color') == [.8 .8 .8]
	set(num,'Color', [ 1 1 1 ]);
end


end %functionfigure_band