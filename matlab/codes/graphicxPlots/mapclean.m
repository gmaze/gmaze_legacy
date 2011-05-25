% MAPCLEAN Uniform plots and colorbars
%
% MAPCLEAN(CPLOT,CBAR)
% 
% This function makes uniformed subplots (handles CPLOT)
% and their vertical colorbars (handles CBAR)
%
% Copyright (c) 2007 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function mapclean(CPLOT,CBAR)

if ~strcmp(strtrim(eval('computer')),'MACI')
  
	np = length(CPLOT);
	proper1 = 'position';
	proper2 = 'position';

	% Get positions of subplots and colorbars:
	for ip = 1 : np
	  Pot(ip,:) = get(CPLOT(ip),proper1);
	  Bot(ip,:) = get(CBAR(ip),proper2);
	end


	% Set coord of subplots: [left bottom width height]
	W = max(Pot(:,3));
	H = max(Pot(:,4));
	Pot;
	for ip = 1 : np
	  set(CPLOT(ip),proper1,[Pot(ip,1:2) W H]);
	end


	% Get new positions of subplots:
	for ip = 1 : np
	  Pot(ip,:) = get(CPLOT(ip),proper1);
	end


	% Fixe colorbars coord: [left bottom width height]
	Wmin = 0.0435*min(Pot(:,3));
	Hmin = 0.6*min(Pot(:,4));

	% Set them:
	for ip = 1 : np
	  %set(CBAR(ip),proper2,[Bot(ip,1) Bot(ip,2) Wmin Hmin]);
	%  set(CBAR(ip),proper2,[Pot(ip,1)+Pot(ip,3)*1.1 Pot(ip,2)+Pot(ip,2)*0.1 Wmin Hmin]);
	  set(CBAR(ip),proper2,[Pot(ip,1)+Pot(ip,3)*1.05 Pot(ip,2)+Pot(ip,4)*0.2 ...
			        0.0435*Pot(ip,3) 0.6*Pot(ip,4)])
	end


end % only for linux
