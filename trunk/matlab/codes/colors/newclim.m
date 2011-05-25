% NEWCLIM Used to get more than 1 colormap in subplot windows
%
% CLim = newclim(BeginSlot,EndSlot,CDmin,CDmax,CmLength)
%                Convert slot number and range
%                to percent of colormap
% Used to get more than 1 colormap in subplot windows.
% 
% For example:
%
% z = peaks(25);
% map1=jet;
% map2=hot;
% ax1=subplot(1,2,1)
% imagesc(z);title('Colormap: jet');
% ax2=subplot(1,2,2)
% imagesc(z);title('Colormap: hot');
% colormap([map1;map2]);
%
% CmLength   = size(get(gcf,'Colormap'),1);% Colormap length
% BeginSlot1 = 1;          % Begining slot
% EndSlot1   = size(map1,1); % Ending slot
% BeginSlot2 = EndSlot1+1; 
% EndSlot2   = CmLength;
% CLim1      = get(ax1,'CLim');% CLim values for each axis
% CLim2      = get(ax2,'CLim');
% set(ax1,'CLim',newclim(BeginSlot1,EndSlot1,CLim1(1),CLim1(2),CmLength ))
% set(ax2,'CLim',newclim(BeginSlot2,EndSlot2,CLim2(1),CLim2(2),CmLength ))
%
%
% Copyright (c) 2005 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


function CLim = newclim(BeginSlot,EndSlot,CDmin,CDmax,CmLength)

PBeginSlot    = (BeginSlot - 1) / (CmLength - 1);
PEndSlot      = (EndSlot - 1) / (CmLength - 1);
PCmRange      = PEndSlot - PBeginSlot;
%                Determine range and min and max 
%                of new CLim values
DataRange     = CDmax - CDmin;
ClimRange     = DataRange / PCmRange;
NewCmin       = CDmin - (PBeginSlot * ClimRange);
NewCmax       = CDmax + (1 - PEndSlot) * ClimRange;
CLim          = [NewCmin,NewCmax];
