% LOAD_MASKOCCA Load any mask from OCCA
%
% [mask_C mask_U mask_V mask_W] = load_maskOCCA(path_to_the_hrid_files)
%
%
% Created by Guillaume Maze on 2008-10-14.
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

function varargout = load_maskOCCA(varargin);

path_grid = varargin{1};

iX = [1 360]; iY = [1 160]; iZ = [1 50];
nx = diff(iX)+1; ny = diff(iY)+1; nz = diff(iZ)+1;
iXg= [1:360 1]; iYg = [1:160 1]; iZg=[1:50+1];
%iXg= [1:360 ]; iYg = [1:160 ]; iZg=[1:50];

if nargout >= 1
	fid    = fopen(strcat(path_grid,'maskCtrlC.data'),'r','ieee-be');
	MASKCC = fread(fid,[nx*ny nz],'float32')'; fclose(fid);
	MASKCC = reshape(MASKCC,[nz nx ny]); MASKCC = permute(MASKCC,[1 3 2]);
	LSmask3D_1 = MASKCC(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2));	LSmask3D_1(LSmask3D_1==0) = NaN;
	varargout(1) = {LSmask3D_1};
end

if nargout >= 2
	fid    = fopen(strcat(path_grid,'maskCtrlW.data'),'r','ieee-be');
	MASKCW = fread(fid,[nx*ny nz],'float32')'; fclose(fid);
	MASKCW = reshape(MASKCW,[nz nx ny]); MASKCW = permute(MASKCW,[1 3 2]);
	LSmask3D_2 = MASKCW(iZ(1):iZ(2),iY(1):iY(2),iXg);	LSmask3D_2(LSmask3D_2==0) = NaN;
	varargout(2) = {LSmask3D_2};
end

if nargout >= 3
	fid    = fopen(strcat(path_grid,'maskCtrlS.data'),'r','ieee-be');
	MASKCS = fread(fid,[nx*ny nz],'float32')'; fclose(fid);
	MASKCS = reshape(MASKCS,[nz nx ny]); MASKCS = permute(MASKCS,[1 3 2]);
	LSmask3D_3 = MASKCS(iZ(1):iZ(2),iYg,iX(1):iX(2));	LSmask3D_3(LSmask3D_3==0) = NaN;
	varargout(3) = {LSmask3D_3};
end

if nargout >=4 
	c = MASKCC; c = cat(1,c,zeros(1,ny,nx));
	LSmask3D_4 = c(iZg,iY(1):iY(2),iX(1):iX(2)); LSmask3D_4(LSmask3D_4==0) = NaN;
	varargout(4) = {LSmask3D_4};	
end





