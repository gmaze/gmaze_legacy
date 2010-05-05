% duplicate Find duplicate values among a 1D table
%
% [Vdup Idup] = duplicate(C,[PREC])
%
% Find duplicate values among a 1D table, ie identify values among
% C which are similar (to the approximate precisions PREC), give them back
% in Vdup and their occurences in C in Idup.
%
% Eg:
%	C = [1 3 2 2 3 7];
%	[Vdup Idup] = duplicate(C)
%
%	C = [1.9572    3.4854    2.8003    2.1419    3.4218    7.9157];
%	[Vdup Idup] = duplicate(C,0)
%	[Vdup Idup] = duplicate(C,1)
%	[Vdup Idup] = duplicate(C,2)
%
% Created: 2010-02-11.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function [Vdup Idup] = duplicate(C,varargin)

if nargin==2
	ord = varargin{1};
	C = fix(C*10^ord)/10^ord;
end

uni = unique(C);
idup = 0;
for iv = 1 : length(uni)
	ic = find(C==uni(iv));
	if length(ic)>1
		idup = idup + 1;
		Vdup(idup) = uni(iv);
		Idup(idup) = {ic};
	end
end

if ~exist('Vdup','var')
	Vdup = [];
	Idup = {};
end

end %functionduplicate