% BOLDNUL Make null contours line style dashed
%
% BOLDNUL(h,[STYLE])
% 
% Change linestyle of h for null values
% to bold (double the current linewdith)
%
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


function varargout = boldnul(varargin)
	
h  = varargin{1};
lw = 1.5;

% v = version('-release'); v = str2num(v(1:4));

% if v < 2007
% 	us = get(h,'userdata');
% 	for ii = 1 : length(us)
% 		val = get(h(ii),'userData');
% 		if us{ii} == 0
% 			if nargin > 1			
% 				set(h(ii),varargin{2:end})
% 			else			
% 				set(h(ii),'linewidth',lw);
% 			end
% 		end
% 	end
% else
	switch get(h(1),'type')
		case 'hggroup'
			hch = get(h,'children');
		otherwise
			hch = h;
	end
	for ich = 1 : length(hch)
		us = get(hch(ich),'userdata');
			if us == 0
				if nargin > 1
					set(hch(ich),varargin{2:end})
				else
					set(hch(ich),'linewidth',lw);
				end
				%set(hch(ich),'facecolor','none')
			end

	end%for ich
%end













