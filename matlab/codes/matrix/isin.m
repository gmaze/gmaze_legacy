% isin Check if a table contains values of another table
%
% [C,IA,IB] = isin(A,B)
% 
% Check if table A contains any values from table B. This is similar
% to 'intersect' for cells but for doubles.
% 
% Outputs:
%	C: Values of B found in A
%	IA: C = A(IA)
%	IB: C = B(IB)
% 
% Rev. by Guillaume Maze on 2013-01-10: Updated help text
% Created: 2011-11-07.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function [C IA IB] = isin(A,B)

ia = findin(A,B);
IA = find(ia~=0);
if ~isempty(IA)
	C  = A(IA);	
	vlist = unique(A(IA));
	ib = findin(B,vlist);
	IB = find(ib~=0);	
else
	C = [];
	IB = [];
end

end %functionisin



function ii = findin(A,B)
	for iv = 1 : length(B)
		if iv == 1
			ii = A==B(iv);
		else
			ii = ii | A==B(iv);
		end% if 
	end% for ib
end% function








