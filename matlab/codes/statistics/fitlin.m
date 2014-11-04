% fitlin Linear least-square curve fitting
%
% [a,b,a_er,b_er,Rsq,Qmin] = fitlin(x,y)
% 
% Estimate a and b from the linear equation:
% 	f(x) = a + b * x
% so that the error function 
%	Q = sum( [f(x) - y]^2 )
% is minimized and thus y ~ f(x).
% 
% Inputs:
% 	x,y: two series of data points
% 
% Outputs:
%	a,b: Coefficients of the optimized linear relation between x and y.
% 	a_er, b_er: Standard errors estimates on a and b.
% 	Rsq: Square of the correlation coefficient between x and y. It is 
% 		equal to the fraction of variance explained by a the linear 
% 		least-squares fit between two variables.
% 	Qmin: Value of the error function for the best fit.
% 
% Notes:
% - If x and y are standardized (ie with zero mean and std of 1),
% then a = 0, and b = R, the correlation coefficient between x and y.
% - The coefficient 'b' is just the covariance of x with y divided by 
% the variance of x.
% 
% References:
% Weisstein, Eric W. "Least Squares Fitting." 
% From MathWorld--A Wolfram Web Resource
% http://mathworld.wolfram.com/LeastSquaresFitting.html
% See Also:
% Dennis L. Hartmann, 2002: Objective analysis (Course Notes)
%
% Created: 2013-07-23.
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

function [a0 a1 a0_er a1_er rsq Qmin] = fitlin(xi,yi)

%- Handle inputs:
xi = xi(:);
yi = yi(:);

%- Work with real values, not nans
iok = ~isnan(xi) & ~isnan(yi);
xi = xi(iok);
yi = yi(iok);
clear iok

n  = length(xi);

if length(yi) ~= n
	error('x and y must be of similar length !')
end% if 

%- Compute useful variables:
% Sum of squares:
ssxx = sum( (xi - nanmean(xi)).^2 );
ssyy = sum( (yi - nanmean(yi)).^2 );
ssxy = sum( (xi - nanmean(xi)).*(yi-nanmean(yi)) );

% Then:
xpypbar = ssxy/n; % Co-variance of x with y: cov(x,y) = ssxy/n
xpsqbar = ssxx/n; % Total variance of x: std(x)^2 = ssxx/n
ypsqbar = ssyy/n; % Total variance of y: std(y)^2 = ssyy/n

%- Determine coefficients:

% a1 (or b) is just the covariance of x with y divided by the variance of x:
a1 = xpypbar/xpsqbar; % == ssxy/ssxx

% and a0 (or a):
a0 = nanmean(yi) - a1 * nanmean(xi);

%- Determine errors and coefficients:

% The overall quality of the fit is then parameterized in terms of the correlation coefficient:
rsq = xpypbar^2 / ( xpsqbar * ypsqbar ); % ie, the fraction of explained variance
% which is equivalent to: rsq = ssxy^2 / (ssxx * ssyy)

% Values obtained from the fit
yihat = a0 + a1*xi;

% Then the error between the actual vertical point yi and the fitted point is given by:
ei = yi - yihat;

% Now define s^2 as an estimator for the variance in ei:
ssq = sum( ei.^2 / (n-2) );

% Then s can be given by:
s = sqrt((ssyy - a1*ssxy)/(n-2));

% and the standard errors for a0 and a1 are:
a0_er = s * sqrt( 1/n + nanmean(xi)^2/ssxx );
a1_er = s/sqrt(ssxx);

% The minimum value of the error functional that is obtained when the linear regression
% is performed is given by:
Qmin = ypsqbar - a1^2*xpsqbar;

end %functionfitlin



















