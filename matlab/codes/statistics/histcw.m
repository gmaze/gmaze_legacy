function [histw histv] = histcw(v, w, edges) 
% histcw Weighted histogram count
%
% [Nw Nx] = histcw(X, W, EDGES) Weighted histogram count
%
% Inputs:
%	X: Values
% 	W: Weight of Values
% 	EDGES: Histogram axis
% 
% Outputs:
% 	Nw: Weighted histogram
% 	Nx: Histogram of Values
%
% Eg:
%
% See Also: 
%
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2016-03-31 (G. Maze)

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

if 0
	xmin = min(edges);
	xmax = max(edges);
	nx = length(edges);
	
	dx = (xmax-xmin)/(nx-1); 
	subs = round((v-xmin)/dx)+1; 

	subs = subs(:);
	w = w(:);

	histv = accumarray(subs,1,[nx,1]); 
	histw = accumarray(subs,w,[nx,1]); 
else

	nx  = length(edges);
	iin = find(v>=edges(1) & v<=edges(end)); % To avoid any subs == 0 that would create errors in accumarray
	X = v(iin);
	W = w(iin);
	[N, subs] = histc(X,edges); % N(i) = sum(subs==i); subs is zero for out of range values
	histv = accumarray(subs(:),ones(size(subs(:))),[nx,1]); % Classic histogram
	histw = accumarray(subs(:),W,[nx,1]); % Weighted histogram
	
end% if 


end %functionhistcw






























