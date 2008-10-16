%DEF
%REQ
%
% Created by Guillaume Maze on 2008-09-30.
% Copyright (c) 2008 Guillaume Maze. 
% http://www.guillaumemaze.org/codes

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


if nb_in > 1

	check_domain
	
	thisdomain = [ind_x ind_y ind_z];
	jpiD = nb_out*(thisdomain(2)-thisdomain(1)+1);
	jpjD = nb_out*(thisdomain(4)-thisdomain(3)+1);
	jpkD = nb_out*(thisdomain(6)-thisdomain(5)+1);
	lon2D_D = [lon2D_t(thisdomain(1),1)-0.5+1/nb_out/2:1/nb_out:lon2D_t(thisdomain(2),1)+0.5-1/nb_out/2];
	lat2D_D = [lat2D_t(1,thisdomain(3))-0.5+1/nb_out/2:1/nb_out:lat2D_t(1,thisdomain(4))+0.5-1/nb_out/2];
	lon2D_D = lon2D_D'*ones(1,jpjD); lat2D_D=ones(jpiD,1)*lat2D_D;

	gdept_D = interp1([thisdomain(5)-1:thisdomain(6)],gdepw([thisdomain(5):thisdomain(6)+1]),[1:nb_out*(thisdomain(6)-thisdomain(5)+1)]/nb_out);

	x = lon2D_D(:,1)';
	y = lat2D_D(1,:);
	z = gdept_D;

	clear *_D r0 rep_domaine rho0 *mask* Kh Kv Vh Vv deg2rad domaine_global_def  e1u e1v e2u e2v e3t e3w fid gravity
	
else

	x = lon2D_t(ind_x(1):ind_x(2),1)';
	y = lat2D_t(1,ind_y(1):ind_y(2));
	z = gdept(ind_z(1):ind_z(2))';


end


nx = length(x);
ny = length(y);
nz = length(z);