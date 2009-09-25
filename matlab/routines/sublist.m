% sublist Subplot indices for portrait/landscape 2 ranks loops plot
%
% plist = sublist(n1,n2,orient)
% 
% Inputs:
%	n1,n2: two integers
% 	orient can be:
%		'portrait' or 1
%		'landscape' or 0
% Outputs:
% 	plist is n1*n2 table of subplot indices
%
% Note that Portrait/landscape reference is for nv > ns
%
% Exampe:
% ns=3; nv=4;
% plist1 = sublist(ns,nv,'landscape');iw1=ns;jw1=nv;
% plist2 = sublist(ns,nv,'portrait');iw2=nv;jw2=ns; 
% ipl = 0;
% for iset = 1 : ns
%	for ivar = 1 : nv
%		ipl = ipl + 1;
%		figure(1);subplot(iw1,jw1,plist1(ipl));title(sprintf('Set:%i, Var:%i',iset,ivar));
%		figure(2);subplot(iw2,jw2,plist2(ipl));title(sprintf('Set:%i, Var:%i',iset,ivar));
%	end %for ivar
% end %for iset
%
% Created: 2009-08-06.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function plist = sublist(iw,jw,orient)


switch orient 		
	case {'landscape',0}
		plist = [1:iw*jw];
	case {'portrait',1}
		ipl = 0;
		for iset = 1 : iw
			for ivar = 1 : jw
				ipl = ipl + 1;
				plist(ipl) = iset + iw*(ivar-1);
			end
		end
end





end %function