function y = gauss(x,sigma,x0,a)
% gauss Gaussian function
% =====
% Y = GAUSS(X,SIGMA,MU,A) return the following gaussian function:
%		            / -(X-MU)^2  \
%		  Y = A*EXP| -----------  |
%		            \ 2*SIGMA^2  /
% 
% - Coefficients A and SIGMA can be arrays.
% - With this formulation, we note that for X=MU+/-SQRT(2)*SIGMA
%	Y = A*EXP(-1) = A / EXP(1)
%   ie, SQRT(2)*SIGMA is the e-folding scale of the gaussian.
% - dY/dX is maximum at MU-SIGMA and minimum at MU+SIGMA:
%   ie, MU+/-SIGMA are the inflection points of the gaussian.
% 
% =====
% Y = GAUSS(X,SIGMA,MU,A/SQRT(2*PI)/SIGMA) return the gaussian function 
% corresponding to a normal distribution:
%		               1            /  -(X-MU)^2  \
%		   Y = ----------------*EXP|  -----------  |
%		       SQRT(2*PI)*SIGMA     \  2*SIGMA^2  / 
% 
% With this normal distribution the integral of Y from -inf to +inf is 1.
% 
% http://codes.guillaumemaze.org
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
% Created: 2009-11-23 by G. Maze
% Revised: 2011-06-15 (G. Maze) Added possibility to handle multiple sigma.
% Revised: 2011-10-25 (G. Maze) Now scale input sigma by sqrt(2) so that half curve 
% 	thickness at y(x0)/exp(1) is sigma or y(x0=0,sigma) = a*exp(-1) = a / exp(1)
% Revised: 2014-04-09 (C. Feucher) Added possibility to handle multiple amplitude
% Revised: 2014-11-04 (G. Maze) Removed rev. 2011-10-25: no more scaling is done on
%   sigma so that the gauss.m function behaves like expected in textbook !

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

[mx ms ma] = meshgrid(x,sigma,a);

y = ma.*exp(- (mx-x0).^2 ./ 2./ ms.^2 );

end %functiongauss