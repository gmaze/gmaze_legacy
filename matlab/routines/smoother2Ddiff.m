% SMOOTHER2DDIFF Apply a diffusive smoother on a 2D field
%
% [field_out,tmp3x,tmp3y] = smoother2Ddiff(field_in,dist_in1,dist_in2);
%
% Apply a diffusive smoother based on Weaver and Courtier, 2001.
%
% field_in:		field to be smoothed (masked with NaN)
% dist_in1/2:	scale in first/second direction
% field_out:	smoothed field
%
% The domain is assumed cyclic in both directions.
% If it is not, you want to mask edge points with NaNs.
%
% Created by Guillaume Maze on 2008-10-14.
% Developed with Gael Forget
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function [field_out,tmp3x,tmp3y] = smoother2Ddiff(field_in,dist_in1,dist_in2);

% domaine_global_def;
nlat = size(field_in,1);
nlon = size(field_in,2);

e1t = ones(nlat,nlon);
e1u=e1t; e1v=e1t; 
e2t=e1t; 
e2u=e1t; e2v=e1t;

% scale the diffusive operator:
smooth2D_dt  = 1;
smooth2D_nbt = max(max(max(dist_in1./e1t)),max(max(dist_in2./e2t)));
smooth2D_nbt = 2*ceil(2*smooth2D_nbt^2);
smooth2D_T   = smooth2D_nbt*smooth2D_dt;

smooth2D_kh1 = dist_in1.*dist_in1/smooth2D_T/2;
smooth2D_kh2 = dist_in2.*dist_in2/smooth2D_T/2;


% time-stepping loop:
field_out = field_in; 
for icur = 1 : smooth2D_nbt
%	disp(sprintf('Smoother Iteration: %3.0f/%3.0f',icur,smooth2D_nbt));
	tmp1 = (field_out-circshift(field_out,[1 0]))./e1t.*e2t.*(smooth2D_kh1/2+circshift(smooth2D_kh1,[1 0])/2);  
	tmp1(find(isnan(tmp1))) = 0;
	
	tmp2 = (circshift(field_out,[-1 0])-field_out)./e1t.*e2t.*(smooth2D_kh1/2+circshift(smooth2D_kh1,[-1 0])/2); 
	tmp2(find(isnan(tmp2))) = 0;
	
	tmp3x=(tmp1-tmp2);
	
	tmp1 = (field_out-circshift(field_out,[0 1]))./e2v.*e1v.*(smooth2D_kh2/2+circshift(smooth2D_kh2,[0 1])/2); 
	tmp1(find(isnan(tmp1))) = 0;
	
	tmp2 = (circshift(field_out,[0 -1])-field_out)./circshift(e2v,[0 -1]).*circshift(e1v,[0 -1]).*(smooth2D_kh2/2+circshift(smooth2D_kh2,[0 -1])/2); 
	tmp2(find(isnan(tmp2))) = 0;
	tmp3y = (tmp1-tmp2);
	
	d2_field_out = tmp3x+tmp3y;
	field_out = field_out-(smooth2D_dt*d2_field_out)./e1t./e2t;
end




