% DINTERP3BIN Interpolate a 3D field
%
% C_HR = DINTERP3BIN(C_LR,Rfact)
%
% Interpolate a 3D field C_LR(Z,Y,X)
% LRfact is the factor by which the initial
% number of points is increased (must be even)
%
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
function varargout = dinterp3bin(varargin)
	
	
Cin   = varargin{1}; 
Cin   = permute(Cin,[3 2 1]); % Move to x,y,z
nb_in = varargin{2};

if ~iseven(nb_in)
	error('dinterp3bin:wrongfactor','==> dinterp3bin: the interp scaling must be even !');
	return
end

[jpi jpj jpk] = size(Cin);
Cin(isnan(Cin)) = -9999;

% Create parameter file:
here = pwd;
fid = fopen(strcat(here,'/ddinterp3bin.p'),'wt');
fprintf(fid,'%i\n',jpi);
fprintf(fid,'%i\n',jpj);
fprintf(fid,'%i\n',jpk);
fprintf(fid,'%i\n',nb_in);
fprintf(fid,'%s\n','ddinterp3bin.inp');
fprintf(fid,'%s\n','ddinterp3bin.out');
%fprintf(fid,'%s/%s\n',here,'interp3bin.inp');
%fprintf(fid,'%s/%s\n',here,'interp3bin.out');
fclose(fid);

% Create input field file:
fid = fopen('ddinterp3bin.inp','w','ieee-be');
Cin   = reshape(Cin,[jpi*jpj jpk]);
fwrite(fid,Cin,'float32');
fclose(fid);
clear Cin

% Interpolate field with fortran code:
%delete('ddinterp3bin.out');
comand = sprintf('%s < ddinterp3bin.p',abspath('~/matlab/routines/dinterp3_ifort'));
%disp(comand)
[sta,res] = system(comand);

if sta == 0
	
	% Read the output:
	fid = fopen('ddinterp3bin.out','r','b');
	Ci  = fread(fid,[jpi*nb_in*jpj*nb_in jpk*nb_in],'float32');
	fclose(fid);
	Ci = reshape(Ci,[jpi*nb_in jpj*nb_in jpk*nb_in]); 
	Ci(find(Ci==-9999))=NaN; 

	% Move back to z,y,x
	Ci = permute(Ci,[3 2 1]); 

	% Check
	if jpk==1
		Ci = squeeze(nanmean(Ci,1));
	end

	% Output:
	if nargout == 1
		varargout(1) = {Ci};
	end

else
	disp(res)
	error('dinterp3bin:wrongbin','==> dinterp3bin: Something went wrong with interp !');	
	return
	
end
	
% Clean files:
if 1
	delete('ddinterp3bin.p');
	delete('ddinterp3bin.inp');
	delete('ddinterp3bin.out');
end



	
