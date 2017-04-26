function M3 = wskewness(W,X)
% wskewness Compute a sample size bias corrected weighted skewness
%
% S = wskewness(W,X) 
% Compute the skewness of values into array X with weights W.
%
% See Also: wmean, wstd
%
% Ref:
% Rimoldini R.: Weighted skewness and kurtosis unbiased by sample size and Gaussian uncertainties.
% Astronomy and Computing, 2014 (5) 1-8.
% http://dx.doi.org/10.1016/j.ascom.2014.02.001
%
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-10-19 (G. Maze)

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

X = X(:);
W = W(:);
W = W(~isnan(X));
X = X(~isnan(X));

V = @(w,p) sum(w.^p); % Sum of the pth power of weights		
m = @(w,x,r) sum(w.*(x-mean(x)).^r)/V(w,1); % Sample weighted central moments

% Eq. 6 from Rimoldini, 2014:
M3 = V(W,1)^3/(V(W,1)^3-3*V(W,1)*V(W,2)+2*V(W,3))*m(W,X,3);

end %functionwskewness