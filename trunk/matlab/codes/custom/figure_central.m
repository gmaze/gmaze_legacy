% figure_central Returns customized parameters to create a figure
%
% [position ] = figure_central()
% 
% Returns customized parameters to create figures
%
% Created: 2011-02-08.
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

function varargout = figure_central(varargin)

	% Get static screen size:
	si = get(0,'MonitorPositions');
	ii = find(si(:,3)==max(si(:,3)));
	si = si(ii,:);

	% Position/Dimension of the figure:
	dx = 620; dy = 440;
	dx = 570; dy = 440;
	posi = [si(3)/2-dx/2 si(4)/2-dy/2 dx dy];
	
	switch wherearewe
		case 'macbook-ifremer'
%			posi = [717   388   450   347];
%			posi = [717 2440 dx dy];
			posi = [605 2440 dx dy];			
			varargout(1) = {posi};
			return			
	end
	
	
	%- Laptop 17''
	if si(3) == 1680 & si(4) == 1028     
		posi = [20 50 dx dy];
	
	%- Cinema Display Ifremer	
	elseif si(3) == 1680 & si(4) == 1050 
%		posi = [1 1 dx dy];
%		posi = [1-206 1072+778+50 dx dy];
%		posi = [605 2440 dx dy];
		posi = [887 1387 dx dy];
	
	%- MacBook 13.1''
	elseif si(3) == 1280 & si(4) == 778  % 
		posi = [1 20 450 450/1.2955]; % Lower left corner
		posi = [717   388   450   347];
		
	%- MacBook 13.1'' with extra screen at MIT, logged in Beagle	
	elseif strcmp(wherearewe,'beagle') & si(4) == 1455
		posi = [0 990 570 440];		
		
	%- Laptop 17'' shared from MacBook 13.1''
	elseif si(3) == 1680 & si(4) == 1048
		posi = [1680/2 778+2*1048-dy dx dy];
	end

varargout(1) = {posi};

end %functionfigure_central
























