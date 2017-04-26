function varargout = decompose(t,y,varargin)
% decompose Additive timeseries decomposition
%
% [LT SC LF HF linreg seascyc] = decompose(t,y,[PAR,VAL]) Additive timeseries decomposition
% 
% Decompose the time series  y(t) as additive signals:
% 		y(t) = LT(t) + SC(t) + LF(t) + HF(t)
% where:
% 		- SC: the seasonal cycle (computed using seascyc)
%	 	- LT: a linear trend (computed using fitlin)
% 		- LF: a low frequency variability (computed using myrunmean with n=6 by default)
%	 	- N: the noise or high frequency
% 
% Inputs:
% 	t(1,N): the datenum time series axis
% 	y(1,N): the time series to decompose
% 	PAR,VAL:
%		n: the number of points to use in the running mean (default n = 6);
% 		ds: a boolean value to indicate if we should remove the seasonal cycle before the trend
% 			end frequency decomposition. By default: FALSE.
%
% Outputs:
% 	LT(1,N): Linear trend
% 	SC(1,N): Typical seasonal cycle
% 	LF(1,N): Low Frequency component
% 	HF(1,N): High Frequency component (the remainder of y-LT-SC-LF)
% 	linreg: a structure with the linear trend regression parameters:
% 		with LT = a + b * t
% 			linreg.a    : Origin of the linear trend
% 			linreg.a_er : Standard errors estimates on origin a 
% 			linreg.b    : Slope of the trend
% 			linreg.b_er : Standard errors estimates on slope b
% 			linreg.Rsq  : Correlation between trend and time series (ie fraction of variance explained by the trend)
% 			linreg.Qmin : the standard error value: sum( [trend - y(t)]^2 )
% 	scyc: a structure with the typical seasonal cycle components:
% 		scyc.template : a [1,12] array with typical monthly values
% 		scyc.spread   : a [1,12] array with the time series spread around the sc
%
% Comment:
% 	If you call the function with output arguments, it popup a new figure with plots of the decomposition.
%
% See Also: fitlin, seascyc, myrunmean
%
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-02-16 (G. Maze)

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

%- Default parameters:
n = 6;
ds = false;

%- Load user parameters:
if nargin-2 ~= 0
    if mod(nargin-2,2) ~= 0
        error('Parameters must come in pairs: PAR,VAL');
    end% if
    for in = 1 : 2 : nargin-2
        eval(sprintf('%s = varargin{in+1};',varargin{in}));
    end% for in
    clear in
end% if

%- Do we work without the seasonal cycle ?
if ds
	[~, SC] = decompose(t,y,'n',n);
	y = y - SC;
end% if 

%- Compute a linear trend:
y_cur = y;
[a,b,a_er,b_er,Rsq,Qmin] = fitlin(t,y_cur);
TR = a + b.*t;
linreg.a = a;
linreg.a_er = a_er;
linreg.b = b;
linreg.b_er = b_er;
linreg.Rsq = Rsq;
linreg.Qmin = Qmin;

%- Compute a typical seasonal cycle:
y_cur = y - TR;
[SC SC_ys SC_y1 SC_y1s] = seascyc(t,y_cur);
scyc.template = SC_y1;
scyc.spread   = SC_y1s;

%- Compute the low frequency signal:
y_cur = y - TR - SC;
if 1
	mvave = @(y,n) filter((1/n)*ones(1,n),1,y);
	LF = mvave(y_cur,n);
else
	LF = myrunmean(y_cur,n,0,2);
end% if 

%- Compute the remainder (noise component):
HF = y - TR - SC - LF;

%- Compute error:
rms  = @(y,yhat) sqrt( sum( ( (yhat-mean(yhat)) - (y-mean(y)) ).^2 ) / length(y) );
cerr = rms(TR+SC+LF+HF,y);

%- Output
switch nargout
	case 0
		m = nanmean(y);
		yl1 = [-1 1]*1.1*max(abs(y-m));
		yl2 = yl1 + m;
		
		fftall; iw=5;jw=1;ipl=0;		
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		plot(t,y,'r');hline(m)
		grid on, box on, datetick('x');ylim(yl2);
		title(sprintf('Signal'),'fontweight','bold','fontsize',14)
		
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		p=plot(t,y,t,TR);hline(m)
		set(p(1),'color',[1 1 1]/2);set(p(2),'color','r');
		grid on, box on, datetick('x');ylim(yl2);
		title(sprintf('TR: Linear trend'),'fontweight','bold','fontsize',14)
		
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		p=plot(t,y*0,t,SC);hline(0);ylim(yl1);
		set(p(1),'color',[1 1 1]/2);set(p(2),'color','r');
		grid on, box on, datetick('x');
		title(sprintf('SC: Seasonal Cycle'),'fontweight','bold','fontsize',14)
		
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		p=plot(t,y*0,t,LF);hline(0);ylim(yl1);
		set(p(1),'color',[1 1 1]/2);set(p(2),'color','r');
		grid on, box on, datetick('x');
		title(sprintf('LF: Low frequency (n=%i)',n),'fontweight','bold','fontsize',14)
		
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		p=plot(t,y*0,t,HF);hline(0);ylim(yl1);
		set(p(1),'color',[1 1 1]/2);set(p(2),'color','r');
		grid on, box on, datetick('x');
		title(sprintf('HF: High frequency'),'fontweight','bold','fontsize',14)
		
		unifx(gcf,t([1 end]));
		
	otherwise
		varargout(1) = {TR};
		varargout(2) = {SC};
		varargout(3) = {LF};
		varargout(4) = {HF};
		varargout(5) = {linreg};
		varargout(6) = {scyc};
end% switch 

end %functiondecompose




















