% cs2st Transform contour matrix into output from streamline
%
% st = cs2st(cs)
% 
% Transfrom the contour matrix is given by contourc into a
% matrix as given by streamline.
%
%
% Created: 2008-12-10.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function ax = cs2st(varargin)

cs = varargin{1};

cestfini = 0; ii = 1; ic = 0;

clear N Ni Nv lh
while cestfini ~= 1
	nc = cs(2,ii);
	ic = ic + 1;
	N(ic)  = nc;
	Ni(ic) = ii;
	Nv(ii) = cs(1,ii);
	ii = ii + nc+1;
	if ii>size(cs,2), cestfini=1;end	
end % while

clear ax
for ic = 1 : length(N)	
	ii = Ni(ic)+1:Ni(ic)+N(ic);
%	if Nv(ic) < 10
		ax(ic) = {cs(:,ii)'};
		%[c1 c2] = m_ll2xy(cs(1,ii),cs(2,ii));
		%m_ax(ic) = {[c1;c2]'};
		%m_axv(ic) = Nv(ic);
%	end
end

if 0
clear ax3 ax3D lh
for il = 1 : length(ax)
	c = ax{il};
	clear cz ax3
	for ip = 1 : size(c,1)
		cz(ip) = iso2(find(la>=c(ip,2),1),find(lo>=c(ip,1),1));
		ax3(ip,:) = [c(ip,1) c(ip,2) cz(ip)];
	end
	%lh(il)=line(c(:,1),c(:,2),cz);
	ax3D(il) = {ax3};
end
%set(lh,'color','k')
end


end %function

