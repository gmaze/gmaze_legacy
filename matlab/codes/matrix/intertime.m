function varargout = intertime(X1,X2,TPART)
% intertime Intersect two time axis (datenum) according to time component
%
% I = intertime(A,B,TPART) for datenum arrays A and B returns an
% 	array of the same size as A containing true where the date elements
% 	of TPART are in A and B, and false otherwise.
%
% REQUIRED INPUTS:
% 	A, B: Two time axis with datenum format
% 	TPART: A part of the date or time. It can be:
% 		'y','yy','yyyy','year': to compare years
% 		'm','mm','month': to compare months
%
% OUTPUTS:
% 	I: A logical array the size of A
%
% EG:
% 	A = datenumserie(2012:2013,1:12);
% 	B = datenum(2013,2,1);
% 	I = intertime(A,B,'y');
% 	I = intertime(A,B,'m');
% 	I = intertime(A,B,'y') & intertime(A,B,'m');
%
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire d'Océanographie Physique et Spatiale).
% Created: 2016-09-28 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire d'Océanographie Physique et Spatiale nor the names of its contributors may be used 
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

switch TPART
	case {'y','yy','yyyy','year'}
		IA = ismember(str2num(datestr(X1,'yyyy')),str2num(datestr(X2,'yyyy')));
	case {'m','mm','month'}
		IA = ismember(str2num(datestr(X1,'mm')),str2num(datestr(X2,'mm')));
end% switch 

switch nargout
	case 1
		varargout(1) = {IA};
end% switch 



end %functionintertime