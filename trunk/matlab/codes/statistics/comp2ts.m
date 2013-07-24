% comp2ts Plot a serie of graphes to compare two time series (scatter, crosscor)
%
% comp2ts(y1,y2)
% comp2ts(y1,y2,x1)
% comp2ts(y1,y2,x1,x2)
% comp2ts(y1,y2,x1,x2,ARG,VAL,...)
% 	ARG: col1, col2, leg, T
% 
% Created: 2013-07-24.
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

function varargout = comp2ts(y1,y2,varargin)

%- Default parameters
col1 = 'k';
col2 = 'r';

y1 = y1(:);
y2 = y2(:);

leg = {'Serie 1','Serie 2'};

% Max time lagged for crosscor:
T = fix(length(y1)/2);

switch nargin
	case {1,2}
		x1 = 1:length(y1);
		x2 = x1;
	case 3
		x1 = varargin{1};
		x2 = x1;
	case 4
		x1 = varargin{1};
		x2 = varargin{2};
	otherwise	
		x1 = varargin{1};
		x2 = varargin{2};
		if mod(nargin-4,2) ~= 0
			error('Arguments must come in pairs: ARG,VAL')
		end% if 
		for in = 3 : 2 : nargin-3
			eval(sprintf('%s = varargin{in+1};',varargin{in}));		
		end% for in
end% switch 



%- Compute correlations:
[CR LAGS CONFIDENCE95 PROB] = getcrosscor(y1,y2,T);
%itSIGNIF = find(PROB<0.05);
itNOTSIGNIF = find(PROB>0.05);
%CR(find(PROB>0.05)) = ones(1,length(find(PROB>0.05))).*NaN;

%- Figure
ffland;
subp=ptable([2 2],[1 2 ; 3 3 ; 4 4]); ipl = 0;

ipl=ipl+1;axes(subp(ipl));hold on
p(1)=plot(x1,y1,'color',col1);
p(2)=plot(x2,y2,'color',col2);
grid on, box on
datetick('x');
legend(p,leg,'location','EastOutside');
title(sprintf('%s','Time series'),'fontweight','bold','fontsize',14)

ipl=ipl+1;axes(subp(ipl));hold on
sc = scatter(y1,y2,10,x1);
set(sc,'marker','o','MarkerFaceColor','flat','sizedata',30)
xanom,yanom,hline,vline,grid on,box on,axis square
xlabel(leg{1});
ylabel(leg{2});
title(sprintf('%s','Scatter plot'),'fontweight','bold','fontsize',14)
cl = colorbar;
axes(cl);datetick('y');
%set(cl,'yticklabel',datestr(get(cl,'YTick')))

ipl=ipl+1;axes(subp(ipl));hold on
plot(LAGS,CR,'color',[1 1 1]*.5);
a=LAGS;a(itNOTSIGNIF) = NaN;
b=CR;b(itNOTSIGNIF) = NaN;
plot(a,b,'b','linewidth',2);
xanom,yanom,
ylim([-1 1]);
hline,vline,
grid on,box on,axis square
title(sprintf('%s\n%s','Time lagged cross-correlation','(blue is significant at 95%)'),'fontweight','bold','fontsize',14)


%- Outputs
switch nargout
	case 1
		varargout(1) = {subp};
end% switch 


end %functioncomp2ts
















