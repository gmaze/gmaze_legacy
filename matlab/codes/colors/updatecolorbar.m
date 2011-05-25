% updatecolorbar Update colorbars
%
% [] = updatecolorbar()
% 
% Update colorbars:
%	When the colormap of a figure is changed, colorbars
%	are not updated. This function fix this !
%
% Note: the function is automatically called by 'colormap'
%
% Example:
%	figure;
%	colormap(jet(128));colorbar
%	colormap(jet(12)); 
%	disp('The colorbar is not correct, press a key to fix it with updatecolorbar ...');pause
%	updatecolorbar
%	disp('Now colorbar is correct !')
%
% Created: 2010-11-04.
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

function varargout = updatecolorbar(varargin)

if nargin == 1
	g = varargin{1};
else
	g = gcf;
end

cmap = get(g,'Colormap');
nc   = size(cmap,1);

cblist = findall(g,'tag','Colorbar');

for ic = 1 : length(cblist)
	set(cblist(ic),'CLim',[1 nc]);
	ch = get(cblist(ic),'children');
	set(ch,'CData',[1:nc]');
end%for ic



end %functionupdatecolorbar

















