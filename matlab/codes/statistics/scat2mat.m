% scat2mat Map scattered data onto a regular grid
%
% M = scat2mat(Xi,Yi,Zi,Xb,Yb) Map values Zi scattered along two irregular Xi,Yi 
% 	axis coordinates onto a regular grid defined by meshed axis Xb,Yb. See bin2mat 
% 	for more details.
%
% M = scat2mat(Xi,Yi,Zi,Xb,Yb,@fun) Map values Zi scattered along irregular Xi,Yi 
% 	coordinates onto a regular grid defined by meshed axis Xb,Yb. The function @fun 
% 	is used to agregate values. See bin2mat for more details.
% 
% [M IND] = scat2mat(Xi,Yi,Zi,Xb,Yb,@fun,@ope,val) Map values Zi scattered along 
% 	irregular Xi,Yi coordinates onto a regular grid defined by meshed axis Xb,Yb. 
% 	The function @fun is used to agregate values. IND is the list of indexes in Zi
% 	for which the operator @ope is satisfied with value val on the normalized map
% 	values.
% 
% Created: 2013-11-07.
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

function varargout = scat2mat(Xi,Yi,Zi,Xb,Yb,varargin)

%- Pre-proc
Xi = Xi(:);
Yi = Yi(:);
Zi = Zi(:);

%- 
switch nargin
	case 5
		H = bin2mat(Xi,Yi,Zi,Xb,Yb); 
		varargout(1) = {H};		
		return
	case 6
		H = bin2mat(Xi,Yi,Zi,Xb,Yb,varargin{1});
		varargout(1) = {H};		
		return
	otherwise
		mapfun = varargin{1};
		levfun = varargin{2};
		levval = varargin{3};
		% follow on below ...
end% switch 

%- Apply standard mapping:
H = bin2mat(Xi,Yi,Zi,Xb,Yb,mapfun);

%- Identify indexing for cells:
% ie for each cell of the output meshed grid, we list the corresponding indeces of input
[a Hindex] = bin2mat(Xi,Yi,1:length(Xi),Xb,Yb); clear a

%- Normalize H so that it goes from -1 to 1 only:
Hn = H./abs(xtrm(H));

%- Identify region:
[ix iy] = find( feval(levfun,Hn,levval) );
if ~isempty(ix)
	Ilist = [];
	for ic = 1 : length(ix)
		Ilist = cat(1,Ilist,Hindex{ix(ic),iy(ic)});
	end% for ic
end% if 

varargout(1) = {H};
varargout(2) = {Ilist};


end %functionbinning2d