% fitpow Power Law least-square curve fitting
%
% [A,B] = fitpow(x,y)
% 
% Estimate coefficients A and B so that:
%	y = A x^B
% is optimized in a least-square sense.
% 
% Inputs:
% 	x,y: two series of data points
% 
% Outputs:
%	A,B: Coefficients of the optimized power law relation between x and y.
%
% Reference:
% Weisstein, Eric W. "Least Squares Fitting--Power Law." 
% From MathWorld--A Wolfram Web Resource.
% http://mathworld.wolfram.com/LeastSquaresFittingPowerLaw.html
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

function [A,B] = fitpow(xi,yi)

%- Handle inputs:
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
slxly = sum(log(xi).*log(yi));
slxlx = sum(log(xi).*log(xi));
slx   = sum(log(xi));
sly   = sum(log(yi));

%- Compute optimized coefficients:
b = (n*slxly - slx*sly) / (n*slxlx - slx^2);
a = (sly - b*slx) / n;

B = b;
A = exp(a);

end %functionfitpow