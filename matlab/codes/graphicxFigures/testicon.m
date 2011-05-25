% testicon H1LINE
%
% [] = testicon()
% 
% HELPTEXT
%
% Created: 2010-05-30.
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

function varargout = testicon(varargin)

file = varargin{1};
ij   = varargin{2};
ik   = varargin{3};

icosize = 16;
[X map] = imread(file);
rgb     = ind2rgb(X,map);
[nx ny nc] = size(rgb);

% Determine size of intervals
C = sum(rgb,3);
Cx = sum(C,2);
Cxlim = 0.99*xtrm(Cx);
blkx  = Cx>=Cxlim;

Cy = sum(C,1);
Cylim = 0.99*xtrm(Cy);
blky  = Cy>=Cylim;

% Icos coordinates

clear icoX ico inic
if blkx(1) 
	inic = true;
	ico  = 1;
else
	inic = false;
	ico  = 0;
end

for ix = 1 : nx
	if blkx(ix) && inic
		icoX{ico} = cat(1,icoX,ix);
	else
		inic = false;
		ico = ico + 1;
	end
end%for ix


[a b c] = meshgrid(double(blkx),double(blky),1:3);
icomask = a+b; clear a b c
icomask(icomask~=0) = NaN;
icomask(~isnan(icomask)) = 1;
icomask = permute(icomask,[2 1 3]);

NicoX = length(find(blkx==0))/icosize
NicoY = length(find(blky==0))/icosize

keyboard


end %functiontesticon









