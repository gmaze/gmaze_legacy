% LANFILT High, low, band pass filters based on Lanczos filter
%
% Y = LANFILT(X,FILTER_TYPE,HFc,LFc,N)
% 
% Filter 1D signal X through a Lanczos filter.
%
% Inputs:
%	X: Input signal (1 dimension of length n)
%
%	FILTER_TYPE: Type of filtering you want:
%			1 : Low-pass  (cutoff frequency is LFc)
%			2 : High-pass (cutoff frequency is HFc)
%			3 : Band-pass (retain signal frequency within HFc<->LFc)
%
%	HFc: High frequency cut off (any k/n between 1/n and 1)
%	LFc: Low frequency cut off (any k/n between 1/n and 1)
%
%	N: Number of points in the filter. Note that the transition width 
%		of the transfer function is 2/(N-1)
%
% Outputs:
%	Y: Filtered signal
%
% Copyright (c) 2004-2010 Guillaume Maze. 
% Rev. by Guillaume Maze on 2010-02-18: Improved help, changed arguments order, add arguments check
% http://codes.guillaumemaze.org

% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.

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

function [XF] = lanfilt(X,FILTER,Fc1,Fc2,N)

if FILTER < 0 | FILTER > 3
	error('FILTER must be 1, 2 or 3 !');
end

X  = X(:);
n  = length(X);
NJ = fix((N-1)/2);


switch FILTER
	case 1 % LOW PASS
	      XF = lanczos(X,Fc2,NJ);

	case 2 % HIGH PASS
	      XF = X - lanczos(X,Fc1,NJ);

	case 3 % BAND PASS
	      XF = lanczos(X,Fc2,NJ);
	      XF = XF - lanczos(XF,Fc1,NJ);

end %switch


end%function