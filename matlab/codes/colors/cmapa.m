% cmapa change colormap for anomalies
%
% [] = cmapa([TYP])
% 
% TYP=1 Color (default)
% TYP=2 B&W
%
% Created: 2010-01-11.
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

function varargout = cmapa(varargin)

switch nargin
	case 0
		load mapanom2
		cmap = logcolormap(128,1,1,mapanom);
	case 1
		switch varargin{1}
			case 1
				load mapanom2
				cmap = logcolormap(128,1,1,mapanom);
			case 2
				cmap = [gray ; flipud(gray)];
			case 3
				load mapanom2
				cmap = mapanom;
			case 4
				load mapanom
				cmap = mapanom;
			case 5
				load mapanom2
				cmap = mapanom;
				cmap = mycolormap(cmap,128);
				cm   = rgb2hsv(cmap);
				cm(:,1) = linspace(1,.5,size(cm,1)); 
				cmap = hsv2rgb(cm);
				cmap = flipud(cmap);
			case 6
				load mapanom2
				cmap = mapanom;
				cmap = mycolormap(cmap,128);
				cm   = rgb2hsv(cmap);
				cm(:,1) = linspace(.5,1,size(cm,1)); 
				cmap = hsv2rgb(cm);
			case 7
				cmap1 = cmapa(5);
				cmap2 = cmapa(6);
				cmap(1:64,:)   = cmap1(1:64,:);
				cmap(65:128,:) = cmap2(65:128,:);
			case 8
				cmap1 = cmapa(5);
				cmap2 = cmapa(6);
				cmap(1:64,:)   = flipud(cmap1(65:128,:));
				cmap(65:128,:) = flipud(cmap2(1:64,:));	
				cmap = flipud(cmap);
		end
end

switch nargout
	case 0
		colormap(cmap)
	otherwise
		varargout(1) = {cmap};
end% switch 


end %functioncmapa







