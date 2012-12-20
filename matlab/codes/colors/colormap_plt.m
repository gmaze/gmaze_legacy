% colormap_plt Load a colormap from the Matplotlib palette
%
% [CMAP] = colormap_plt([NAME])
% 
% Load a colormap from the Matplotlib palette.
% If no NAME is specified, we loop through all colormaps on the current figure.
%
% Created: 2012-02-16.
% Copyright (c) 2012, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = colormap_plt(varargin)

%- Where do I get all txt files, relative to this function ?
txtpath = 'matplotlib';

%- Load the list of available colormaps:
s = which(mfilename);
s = strrep(s,'colormap_plt.m',txtpath);
d = dir(s); ic = 0; avail_list = ': ';
for ii = 1 : length(d)
	if ~d(ii).isdir & ~isempty(strfind(d(ii).name,'.txt'))
		ic = ic + 1;
		avail_file(ic) = {d(ii).name};
		avail_name(ic) = {strrep(d(ii).name,'.txt','')};
		avail_list = sprintf('%s%s, ',avail_list,avail_name{ic});
	end% if 
end% for 
if ic == 0
	error(sprintf('I couldn''t find any colormap file in folder: %s\nPlease adjust variable <txtpath> in this function !',s))
end% if 

if nargin == 0
	%- No arguments, we want to check out all colormaps:
	
	for ii = 1 : length(avail_name)
		cmap = load(fullfile(s,avail_file{ii}));
		colormap(cmap);
		r = input(sprintf('This is colormap ''%s'', press <enter> to loop through the next colormap',avail_name{ii}),'s');
		if ~isempty(r)
			return
		end% if 
	end% for ii
	
	
else
	%- 1 argument, this must be the colormap name:
	if isempty(intersect(avail_name,varargin{1}))
		error(sprintf('This colormap is not available. Please, pick one in %s',avail_list));
	else
		cmap = load(fullfile(s,sprintf('%s.txt',varargin{1})));
		if nargout == 0
			colormap(cmap);
		else
			varargout(1) = {cmap};
		end% if 
	end% if 
end% if  



end %functioncolormap_plt




