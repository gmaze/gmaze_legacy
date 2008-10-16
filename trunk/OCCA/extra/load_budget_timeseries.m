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

pref = sprintf('%s/InterpALLonce_%4.4d_%4.4d_%2.0f.m%2.0f._timeseries_',dirtofil,iter0,iter1,THETAlow,THETAhig);
nt = iter1;
Vvol = ones(1,nt).*NaN;
Vtheta = ones(1,nt).*NaN;
Vadv = ones(1,nt).*NaN;
Vadvx = ones(1,nt).*NaN;
Vadvy = ones(1,nt).*NaN;
Vadvz = ones(1,nt).*NaN;
Vdiff = ones(1,nt).*NaN;
Vdifx = ones(1,nt).*NaN;
Vdify = ones(1,nt).*NaN;
Vdifz = ones(1,nt).*NaN;
Vdifiz = ones(1,nt).*NaN;
Vghat = ones(1,nt).*NaN;
VtendA = ones(1,nt).*NaN;
VtendN = ones(1,nt).*NaN;
Vall = ones(1,nt).*NaN;
Vq = ones(1,nt).*NaN;

t = datenum(2003,11,1,0,0,0); t = t(1):t(1)+nt-1;
	
% VOLUME INTEGRALS, TIME SERIES FOR FULL LAYER
fid = fopen(strcat(pref,'LRvol.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vvol = fread(fid,[1 nt],'float32'); fclose(fid); Vvol(Vvol==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRtendNATIVE.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	VtendN = fread(fid,[1 nt],'float32'); fclose(fid); VtendN(VtendN==-9999)=NaN;	
end

fid = fopen(strcat(pref,'LRtendARTIF.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	VtendA = fread(fid,[1 nt],'float32'); fclose(fid); VtendA(VtendA==-9999)=NaN;	
end

fid = fopen(strcat(pref,'LRadvTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vadv = fread(fid,[1 nt],'float32'); fclose(fid); Vadv(Vadv==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRdiffTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vdiff = fread(fid,[1 nt],'float32'); fclose(fid); Vdiff(Vdiff==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRallotherTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vall = fread(fid,[1 nt],'float32'); fclose(fid); Vall(Vall==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRairsea3D.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vq = fread(fid,[1 nt],'float32'); fclose(fid); Vq(Vq==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRadvX.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vadvx = fread(fid,[1 nt],'float32'); fclose(fid); Vadvx(Vadvx==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRadvY.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vadvy = fread(fid,[1 nt],'float32'); fclose(fid); Vadvy(Vadvy==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRadvZ.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vadvz = fread(fid,[1 nt],'float32'); fclose(fid); Vadvz(Vadvz==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRdifX.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vdifx = fread(fid,[1 nt],'float32'); fclose(fid); Vdifx(Vdifx==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRdifY.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vdify = fread(fid,[1 nt],'float32'); fclose(fid); Vdify(Vdify==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRdifZ.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vdifz = fread(fid,[1 nt],'float32'); fclose(fid); Vdifz(Vdifz==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRdifIZ.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vdifiz = fread(fid,[1 nt],'float32'); fclose(fid); Vdifiz(Vdifiz==-9999)=NaN;
end

fid = fopen(strcat(pref,'LRghat.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	Vghat = fread(fid,[1 nt],'float32'); fclose(fid); Vghat(Vghat==-9999)=NaN;
end

ntr = min(find(Vvol==0));
if ntr ~= nt & 0
	Vvol = Vvol(1:ntr);
	VtendN = VtendN(1:ntr);
	VtendA = VtendA(1:ntr);
	Vadv = Vadv(1:ntr);
	Vdiff = Vdiff(1:ntr);
	Vall = Vall(1:ntr);
	Vq   = Vq(1:ntr);
	t = t(1:ntr);
	nt = ntr;
end
clear ntr








