% fitlog Logarithmic least-square curve fitting
%
% [a,b] = fitlog(x,y)
% 
% Estimate coefficients a and b so that:
%	y = a + b*log(x)
% is optimized in a least-square sense.
% 
% Inputs:
% 	x,y: two series of data points
% 
% Outputs:
%	a,b: Coefficients of the optimized logarithmic relation between x and y.
%
% Reference:
% Weisstein, Eric W. "Least Squares Fitting--Logarithmic." 
% From MathWorld--A Wolfram Web Resource. 
% http://mathworld.wolfram.com/LeastSquaresFittingLogarithmic.html
% 
% Created: 2013-07-25.
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

function [a,b] = fitlog(xi,yi)

%- inputs:
xi = xi(:);
yi = yi(:);

iok = ~isnan(xi) & ~isnan(yi);
xi = xi(iok);
yi = yi(iok);
clear iok

n  = length(xi);

if length(yi) ~= n
	error('x and y must be of similar length !')
end% if 

%- Compute useful variables:
sy    = sum(yi);
sylx  = sum(yi.*log(xi));
slx   = sum(log(xi));
slxlx = sum(log(xi).*log(xi));

%- Compute optimized coefficients:
b = (n*sylx - sy*slx) / (n*slxlx - slx^2);
a = (sy - b*slx) / n;



end %functionfitlog