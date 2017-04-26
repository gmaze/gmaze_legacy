function [field_out] = mydiffsmooth2D(field_in,dist_in1,dist_in2,dist_in3);
% SMOOTHER3DDIFF Apply a diffusive smoother on a 3D field
%
% [field_out] = smoother3Ddiff(field_in,dist_in1,dist_in2,dist_in3);
%
% Apply a diffusive smoother based on Weaver and Courtier, 2001.
%
% field_in:		field to be smoothed (masked with NaN)
% dist_in1/2/3:	scale in first/second/third direction
% field_out:	smoothed field
%
% The domain is assumed cyclic in all directions.
% If it is not, you want to mask edge points with NaNs.

% domaine_global_def;
nt   = size(field_in,1);
nlat = size(field_in,2);
nlon = size(field_in,3);

%%%%%%%%%%%%%%% Last 2 DIMS SMOOTHER: (LATITUDE/LONGITUDE)
e1t = ones(nlat,nlon);
e1u=e1t; e1v=e1t; 
e2t=e1t; 
e2u=e1t; e2v=e1t;

% scale the diffusive operator:
smooth2D_dt  = 1;
smooth2D_nbt = max(max(max(dist_in2./e1t)),max(max(dist_in3./e2t)));
smooth2D_nbt = 2*ceil(2*smooth2D_nbt^2);
smooth2D_T   = smooth2D_nbt*smooth2D_dt;

smooth2D_kh1 = dist_in2.*dist_in1/smooth2D_T/2;
smooth2D_kh2 = dist_in3.*dist_in2/smooth2D_T/2;

% time-stepping loop:
Fout = field_in;

for iter = 1 : nt
	field_out = squeeze(field_in(iter,:,:));
	
	for icur = 1 : smooth2D_nbt
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
	Fout(iter,:,:) = field_out;

end %for iter

%%%%%%%%%%%%%%% First dim SMOOTHER: (TIME)
e1t = ones(nt,nlat*nlon);
dist_in3b = dist_in3*ones(1,nlat*nlon);

% scale the diffusive operator:
smooth2D_dt  = 1;
smooth2D_nbt = max(max(max(dist_in3./e1t)));
smooth2D_nbt = 2*ceil(2*smooth2D_nbt^2);
smooth2D_T   = smooth2D_nbt*smooth2D_dt;

smooth2D_kh1 = dist_in1.*dist_in1/smooth2D_T/2;

% time-stepping loop:
field_out = reshape(Fout,[nt nlat*nlon]);

for icur = 1 : smooth2D_nbt
	if mod(icur,10) == 0
		disp(sprintf('Smoother Iteration: %3.0f/%3.0f',icur,smooth2D_nbt));
	end
	
	tmp1 = (field_out-circshift(field_out,[1 0]))./e1t.^2.*(smooth2D_kh1/2+circshift(smooth2D_kh1,[1 0])/2);  
	tmp1(find(isnan(tmp1))) = 0;
	
	tmp2 = (circshift(field_out,[-1 0])-field_out)./e1t.^2.*(smooth2D_kh1/2+circshift(smooth2D_kh1,[-1 0])/2); 
	tmp2(find(isnan(tmp2))) = 0;
	
	field_out = field_out-(smooth2D_dt*(tmp1-tmp2))./e1t.^2;
end

field_out = reshape(field_out,[nt nlat nlon]);




