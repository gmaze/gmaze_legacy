% wstd Compute a sample size bias corrected weighted standard deviation
%
% S = wstd(W,X)
% 
% Compute the standard deviation of values into array X with weights W.
% 	S^2  = sum(A) / (V1 - V2/V1) 
% with
% 	A  = W*(X-wmean(W,X)).^2
%	V1 = sum(W).^2;
%	V2 = sum(W^2);
%
% See also:	wmean
%
% Ref:
% Rimoldini R.: Weighted skewness and kurtosis unbiased by sample size and Gaussian uncertainties.
% Astronomy and Computing, 2014 (5) 1-8.
% http://dx.doi.org/10.1016/j.ascom.2014.02.001
%
% Created: 2011-02-14.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org
% Revised: 2015-10-19 (G. Maze) Now use the Rimoldini formulation
% Revised: 2015-10-19 (G. Maze) Fixed a bug ! We were computing the variance, not the std !

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

function S = wstd(W,X,varargin)

switch nargin
	case 2
		X = X(:);
		W = W(:);
		W = W(~isnan(X));
		X = X(~isnan(X));

		a  = W.*( (X - wmean(W,X)).^2 );
		v1 = sum(W);
		v2 = sum(W.^2);
		%S  = sqrt( sum(a)./v1 ); % From biased weighted variance
		S  = sqrt( sum(a)./(v1 - v2./v1) ); % From un-biased Weighted variance
		
	case 200
		X = X(:);
		W = W(:);
		W = W(~isnan(X));
		X = X(~isnan(X));

		V = @(w,p) sum(w.^p); % Sum of the pth power of weights		
		m = @(w,x,r) sum(w.*(x-mean(x)).^r)/V(w,1); % Sample weighted central moments

		% Eq 5 from Rimoldini, 2014
		M2 = V(W,1)^2/(V(W,1)^2 - V(W,2))*m(W,X,2);
		S = sqrt(M2);
	
	case 3
		error('Please update this part of the code with Rimoldini formulae !')
		dim = varargin{1};
		n = size(X,dim);
		s = size(X);
		s(setdiff(1:length(s),dim))=1;
		Xm = repmat(wmean(W,X,dim),s);
		a = W.*((X - Xm).^2);
		v1 = sum(W,dim).^2;
		v2 = sum(W.^2,dim);
		S  = sum(W,dim) ./ (v1-v2) .* sum(a,dim);
end% switch 

end %functionwstd










