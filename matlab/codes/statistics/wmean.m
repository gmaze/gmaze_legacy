function M = wmean(W,X,varargin)
% wmean Compute a sample size bias corrected weighted mean
%
% M = wmean(W,X)
% 
% Compute a sample size bias corrected weighted mean of X with weights W
% 
% See also: wstd, wskewness
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
% Revised: 2015-10-19 (G. Maze) Updated to work with Rimoldini sample size bias corrected formulae

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

switch nargin
	case 2
		X = X(:);
		W = W(:);
		W = W(~isnan(X));
		X = X(~isnan(X));
		
		if 0 % Previous formulae:
			M = nansum(X.*W) / nansum(W) ;
		else % Unbiased estimator:
			V = @(w,p) sum(w.^p); % Sum of the pth power of weights			
			M  = sum(W.*X)/V(W,1);
		end% if 
		
	case 3
		dim = varargin{1};
		M = nansum(X.*W,dim)./nansum(W,dim);
end% switch 


end %functionwmean