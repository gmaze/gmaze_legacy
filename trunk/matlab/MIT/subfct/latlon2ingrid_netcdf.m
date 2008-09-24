% latlon2ingrid_netcdf: Read a bin snapshot from 1/8 simu and record it as netcdf
% latlon2ingrid_netcdf(pathname,pathout, ...
%                            stepnum,fpref,otab,           ...
%                            lon_c, lon_u,                    ...
%                            lat_c, lat_v,                    ...
%                            z_c, z_w,                        ...
%                            subname,                         ...
%                            lonmin,lonmax,latmin,latmax,depmin,depmax);

function latlon2ingrid_netcdf(pathname,pathout, ...
                            stepnum,fpref,otab,           ...
                            lon_c, lon_u,                    ...
                            lat_c, lat_v,                    ...
                            z_c, z_w,                        ...
                            subname,                         ...
                            lonmin,lonmax,latmin,latmax,depmin,depmax);

irow=strmatch({fpref},otab(:,1),'exact');
if length(irow) ~= 1
 fprintf('Bad irow value in latlon2ingrid_netcdf2\n');
 return
end
loc=otab{irow,3};
id=otab{irow,4};
units=otab{irow,5};
dimspec=otab{irow,2};
if strmatch(id,'unknown_id','exact')
 id = fpref;
end
fprintf('Field %s, loc=%s, id=%s, units=%s, dimspec=%s\n',fpref,loc,id,units,dimspec);
wordlen=otab{irow,6};
if wordlen == 4
 numfmt='float32';
end
if wordlen == 8
 numfmt='float64';
end
%numfmt='float64';
%wordlen =8;

%ilo_c=min(find(lon_c  >= lonmin & lon_c  <= lonmax));
%ilo_u=min(find(lon_u  >= lonmin & lon_u  <= lonmax));
%ihi_c=max(find(lon_c  >= lonmin & lon_c  <= lonmax));
%ihi_u=max(find(lon_u  >= lonmin & lon_u  <= lonmax));
ilo_c=min(find(lon_c-180 >= lonmin & lon_c-180 <= lonmax));
ilo_u=min(find(lon_u-180 >= lonmin & lon_u-180 <= lonmax));
ihi_c=max(find(lon_c-180 >= lonmin & lon_c-180 <= lonmax));
ihi_u=max(find(lon_u-180 >= lonmin & lon_u-180 <= lonmax));
jlo_c=min(find(lat_c >= latmin & lat_c <= latmax));
jlo_v=min(find(lat_v >= latmin & lat_v <= latmax));
jhi_c=max(find(lat_c >= latmin & lat_c <= latmax));
jhi_v=max(find(lat_v >= latmin & lat_v <= latmax));
klo_w=min(find(z_w   >= depmin & z_w   <= depmax));
khi_w=max(find(z_w   >= depmin & z_w   <= depmax));
klo_c=min(find(z_c   >= depmin & z_c   <= depmax));
khi_c=max(find(z_c   >= depmin & z_c   <= depmax));

fnam=sprintf('%s.%10.10d.data',fpref,stepnum);
if loc == 'c'
 ilo=ilo_c;
 ihi=ihi_c;
 jlo=jlo_c;
 jhi=jhi_c;
 klo=klo_c;
 khi=khi_c;
 lon=lon_c;
 lat=lat_c;
 dep=-z_c;
end
if loc == 'u'
 ilo=ilo_u;
 ihi=ihi_u;
 jlo=jlo_c;
 jhi=jhi_c;
 klo=klo_c;
 khi=khi_c;
 lon=lon_u;
 lat=lat_c;
 dep=-z_c;
end
if loc == 'v'
 ilo=ilo_c;
 ihi=ihi_c;
 jlo=jlo_v;
 jhi=jhi_v;
 klo=klo_c;
 khi=khi_c;
 lon=lon_c;
 lat=lat_v;
 dep=-z_c;
end
if loc == 'w'
 ilo=ilo_c;
 ihi=ihi_c;
 jlo=jlo_c;
 jhi=jhi_c;
 klo=klo_w;
 khi=khi_w;
 lon=lon_c;
 lat=lat_v;
 dep=-z_w;
end

nx=1;ny=1;nz=1;
if strmatch(dimspec,'xyz','exact');
 nx=length(lon);
 ny=length(lat);
 nz=length(dep);
end
if strmatch(dimspec,'xy','exact');
 nx=length(lon);
 ny=length(lat);
end

if klo > nz
 klo = nz;
end
if khi > nz
 khi = nz;
end

phiXYZ=zeros(ihi-ilo+1,jhi-jlo+1,khi-klo+1,'single');
disp(strcat('in:',pathname,fnam))
%[klo khi khi-klo+1]

% Read a single level (selected by k)
for k = klo : khi
 fid           = fopen(strcat(pathname,fnam),'r','ieee-be');
 fseek(fid,(k-1)*nx*ny*wordlen,'bof');
 phi           = fread(fid,nx*ny,numfmt); 
 %whos phi, [k nx ny]
 phiXY         = reshape(phi,[nx ny]);
 phiXY         = phiXY(ilo:ihi,jlo:jhi);
 phiXYZ(:,:,k) = phiXY;
 %phiXYZ(100,100,k)
 fclose(fid);
end

%%%clear phi;
%%%clear phiXY;
phiXYZ(find(phiXYZ==0))=NaN;

if subname == ' '
 %outname=sprintf('%s.nc',id);
 outname = sprintf('%s.nc',otab{irow,1});
else
 %outname=sprintf('%s_%s.nc',subname,id);
 outname = sprintf('%s.%s.nc',otab{irow,1},subname);
 %outname = sprintf('%s.%s.nc',strcat(otab{irow,1},'s'),subname);

end
nc = netcdf(strcat(pathout,outname),'clobber');
%disp(strcat(pathout,outname))

nc('X')=ihi-ilo+1;
nc('Y')=jhi-jlo+1;
nc('Z')=khi-klo+1;

nc{'X'}='X';
nc{'Y'}='Y';
nc{'Z'}='Z';

nc{'X'}.uniquename='X';
nc{'X'}.long_name='longitude';
nc{'X'}.gridtype=ncint(0);
nc{'X'}.units='degrees_east';
nc{'X'}(:) = lon(ilo:ihi);

nc{'Y'}.uniquename='Y';
nc{'Y'}.long_name='latitude';
nc{'Y'}.gridtype=ncint(0);
nc{'Y'}.units='degrees_north';
nc{'Y'}(:) = lat(jlo:jhi);

nc{'Z'}.uniquename='Z';
nc{'Z'}.long_name='depth';
nc{'Z'}.gridtype=ncint(0);
nc{'Z'}.units='m';
nc{'Z'}(:) = dep(klo:khi);

ncid=id;
nc{ncid}={'Z' 'Y' 'X'};
nc{ncid}.missing_value = ncdouble(NaN);
nc{ncid}.FillValue_ = ncdouble(0.0);
nc{ncid}(:,:,:) = permute(phiXYZ,[3 2 1]);
nc{ncid}.units=units;

close(nc);
