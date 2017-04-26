function [y ys y1 y1s] = seascyc(t,x)
% seascyc Compute a seasonal cycle
%
% [y ys yt yts] = seascyc(t,x) Compute the seasonal cycle from x(t)
%
% Inputs:
% 	t: the timeaxis as datenum (1,n)
% 	x: a single timeserie (1,n)
%
% Outputs:
% 	y:  typical seasonal cycle on the original timeaxis (1,n)
% 	ys: spread of the typical seasonal cycle on the original timeaxis (1,n)
% 	yt:  monthly typical seasonal cycle on the original timeaxis (1,12)
% 	yts: monthlyspread of the typical seasonal cycle on the original timeaxis (1,12)
% 
% Eg:
%
% See Also: 
%
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-02-02 (G. Maze)

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

n = length(x);
y = zeros(size(x));
ys = zeros(size(x));

years = str2num(datestr(t,'yyyy'));
mnths = str2num(datestr(t,'mm'));

%- Compute annual means
Ylist = sort(unique(years));
nY = length(Ylist);
for iY = 1 : nY
	it = find(years==Ylist(iY));
	Ymean(iY) = nanmean(x(it));
end% for iY

%- Compute month mean with removed annual means:
Mlist = 1 : 12;
nM = length(Mlist);
y0 = zeros(nM,nY);
for iM = 1 : nM
	for iY = 1 : nY		
		it = find(years==Ylist(iY) & mnths==Mlist(iM));
		y0(iM,iY) = nanmean(x(it)) - Ymean(iY);
	end% for iY
end% for it
y1  = nanmean(y0,2);   % Mean
y1s = nanstd(y0,[],2); % Spread

%- Recompose the timeserie:
for it = 1 : n
	isc = find(Mlist==mnths(it));
	y(it)  = y1(isc);
	ys(it) = y1s(isc);
end% for it



end %functionseascyc