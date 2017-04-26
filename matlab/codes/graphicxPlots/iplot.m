function [p jSlider] = iplot(x,y,fct,v0,rg,varargin)
% iplot Create an interactive plot with a slider
%
% [p js] = iplot(x,fct,v0,rg)
%
% Inputs:
%
% Outputs:
%
% Eg:
% 	[NAO,t] = dwn_nao; % Get NAO monthly timeseries
% 	figure; hold on
% 	plot(t,NAO,'color',[1 1 1]/2);datetick('x');hline
%	iplot(t,NAO,@(y,c)nanstan(smoother1Ddiff(y',c)),12,[0:6:12*5],'color','k','linewidth',2);
%
% See Also: 
%
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2016-03-02 (G. Maze)

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
 
%- Create Initial plot:
fh = get(0,'currentfigure');
ax = get(fh,'CurrentAxes');
p = plot(x,fct(y,v0));
set(p,'tag','interactive');
if nargin-5>0
	set(p,varargin{1:end});
end% if 

%- Add slider
% fhs = figure('name',sprintf('Slide F%i',fh));footnote('del');
% pos = get(fhs,'position'); set(fhs,'position',[pos(1:2) 100 pos(4)]);
% try,delete(get(fhs,'CurrentAxes'));end
% mytxt = uicontrol('Style','text','String','Value');

slmin = min(rg);
slmax = max(rg);
jSlider = javax.swing.JSlider;
[jhSlider, hContainer] = javacomponent(jSlider,'East');
set(jSlider,'Orientation',jSlider.VERTICAL);
set(jSlider,'Minimum',slmin,'Maximum',slmax,'Value',v0);

set(jSlider,'paintTicks',true)
set(jSlider,'snapToTicks',1)
set(jSlider,'majorTickSpacing',5*diff(rg(1:2)));
set(jSlider,'minorTickSpacing',diff(rg(1:2)));
set(jSlider,'PaintLabels',true);

%- Set Callback:
cbk = @(obj,eve) set(findobj(ax,'tag','interactive'),'ydata',fct(y,get(obj,'value')));
hjSlider = handle(jSlider, 'CallbackProperties');
set(hjSlider, 'StateChangedCallback', cbk);  %alternative

end %functioniplot


function cbk2(obj,eve)
	val = get(obj,'value');
	set(findobj(ax,'tag','interactive'),'ydata',fct(x,val));	
	set(mytxt,'String',num2str(val));
end



