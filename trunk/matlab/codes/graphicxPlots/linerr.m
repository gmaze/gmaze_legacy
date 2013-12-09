% LINERR Plot a line whose thickness represents error bars (using patch)
%
% P = LINERR(TIM,VAL,ERR,[C]) plot the timeserie VAL(TIM)+/-ERR(TIM) 
% as a patch centered on VAL(TIM)and whose thickness is the error bar 
% ERR(TIM). C is the color of the patch. By default it is set to gray.
% 
% [P PL] = LINERR(TIM,VAL,ERR,C,'core',[ARGS]) same as the default call but also 
% superimpose VAL(TIM) as a plot(VAL,TIM,[ARGS]) on the patch.
%
% Outputs:
% 	P: patch handle.
% 	PL: plot handle.
%
% Created: 2013-07-18.
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

function varargout = linerr(tim,val,err,varargin)

% Default:
c = [1 1 1]*.8; % Patch color
previous_holding_state = ishold;

% Load user color or set default color to gray
if nargin >= 4
	c = varargin{1};
end% if 

% Format data:
tim = tim(:);
val = val(:);
err = err(:);

%
it = ~isnan(tim) & ~isnan(val) & ~isnan(err);
tim = tim(it);
val = val(it);
err = err(it);

% Create patch
hold on
p = patch([tim ; flipud(tim)],[val-err ; flipud(val+err)],c);
set(p,'edgecolor','none');

% 
if nargin > 4 & strcmp(varargin{2},'core')
	if nargin > 5
		pl = plot(tim,val,varargin{3:end});
	else
		pl = plot(tim,val);
	end% if 
end% if

% Restore:
switch previous_holding_state
	case 1, hold on;
	case 0, hold off;
end% switch 


% Output
switch nargout
	case 1
		varargout(1) = {p};
	case 2
		varargout(1) = {p};
		varargout(2) = {pl};
end% switch 


end %functionLINERR