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
disp('Load OCCA Grid...')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% masks:
fid=fopen([grid_path 'maskCtrlC.data'],'r','b');
tmask3D=fread(fid,[jpiO*jpjO jpkO],'float32'); fclose(fid);
tmask3D=reshape(tmask3D,[jpiO jpjO jpkO]);tmask3D(find(tmask3D==0))=NaN;

fid=fopen([grid_path 'maskCtrlW.data'],'r','b');
umask3D=fread(fid,[jpiO*jpjO jpkO],'float32'); fclose(fid);
umask3D=reshape(umask3D,[jpiO jpjO jpkO]);umask3D(find(umask3D==0))=NaN;

fid=fopen([grid_path 'maskCtrlS.data'],'r','b');
vmask3D=fread(fid,[jpiO*jpjO jpkO],'float32'); fclose(fid);
vmask3D=reshape(vmask3D,[jpiO jpjO jpkO]);vmask3D(find(vmask3D==0))=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% positions:
fid=fopen([grid_path 'XC.data'],'r','b');
lon2D_t=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

fid=fopen([grid_path 'YC.data'],'r','b');
lat2D_t=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

fid=fopen([grid_path 'XG.data'],'r','b');
lon2D_u=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

fid=fopen([grid_path 'YG.data'],'r','b');
lat2D_v=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% depths:
fid=fopen([grid_path 'RC.data'],'r','b');
gdept=-fread(fid,jpkO,'float32'); fclose(fid);

fid=fopen([grid_path 'RF.data'],'r','b');
gdepw=-fread(fid,jpkO+1,'float32'); fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% distances
fid=fopen([grid_path 'DXC.data'],'r','b');
e1t=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

fid=fopen([grid_path 'DYG.data'],'r','b');
e2t=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

fid=fopen([grid_path 'DXG.data'],'r','b');
e1v=fread(fid,[jpiO jpjO],'float32'); fclose(fid);

fid=fopen([grid_path 'DYC.data'],'r','b');
e2v=fread(fid,[jpiO jpjO],'float32'); fclose(fid);
e2u=e2t;
e1u=e1t;

fid=fopen([grid_path 'DRF.data'],'r','b');
e3t=fread(fid,jpkO,'float32'); fclose(fid);

fid=fopen([grid_path 'DRC.data'],'r','b');
e3w=fread(fid,jpkO+1,'float32'); fclose(fid);

disp('Done')


