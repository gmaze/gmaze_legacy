% DLOWERRES Reduce the resolution of a field
%
% Clr = DLOWERRES(DS_Fact,Chr,[Mopt])
%
% Lower the resolution of a field by summing grid cells
% DS_fact is the downscaling factor
% Chr(z,y,x) or Chr(y,x)
% Mopt = 0 (default) to average cell values
% Mopt = 1 to sum cell values
% DS_fact is the downscaling factor
%
% Created by Guillaume Maze on 2008-10-09.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = dlowerres(varargin)

nbIn2Out = varargin{1};
Chr      = varargin{2};

if nargin > 2
	Mopt = varargin{3};
else
	Mopt = 0;
end

[jpk jpj jpi] = size(Chr); % z,y,x

if nbIn2Out ~= fix(nbIn2Out)
	error('lowerres:wrongarg','==> lowerres: Downscaling factor (%g) must be an integer\n',nbIn2Out);
	return
end

if mod(jpk,nbIn2Out) ~= 0 
	error('lowerres:wrongdim1','==> lowerres: First dimension (i=%i) must be multiple of %i\n',jpk,nbIn2Out);
	return
end	

if jpj>1 & mod(jpj,nbIn2Out) ~= 0 
	error('lowerres:wrongdim2','==> lowerres: Second dimension (i=%i) must be multiple of %i\n',jpj,nbIn2Out);
	return
end

if jpi>1 & mod(jpi,nbIn2Out) ~= 0 
	error('lowerres:wrongdim3','==> lowerres: Third dimension (i=%i) must be multiple of %i'\n,jpi,nbIn2Out);
	return
end


% Average back to medium grid:
jpi2 = jpi/nbIn2Out;
jpj2 = jpj/nbIn2Out;
jpk2 = jpk/nbIn2Out;

if jpk > 1 & jpj > 1 & jpi > 1 % We have a 3D field
	
	field_in  = permute(Chr,[3 2 1]); % x,y,z
	field_out = zeros(jpi2,jpj2,jpk2);  % x,y,z
	for icur = 1 : nbIn2Out; 
		for jcur = 1 : nbIn2Out; 
			for kcur = 1: nbIn2Out;
				field_out = field_out + field_in(icur:nbIn2Out:jpi,jcur:nbIn2Out:jpj,kcur:nbIn2Out:jpk);
			end;
		end;
	end; 	
	switch Mopt
		case 0,	field_out = permute(field_out./nbIn2Out^3,[3 2 1]);
		otherwise, field_out = permute(field_out,[3 2 1]);
	end


elseif jpk > 1 & jpj > 1 & jpi == 1 % We have a 2D field

	field_in  = squeeze(Chr(:,:,1))'; % y,x
	field_out = zeros(jpj2,jpk2);  % x,y
	for jcur = 1 : nbIn2Out; 
		for kcur = 1: nbIn2Out;
			field_out = field_out + field_in(jcur:nbIn2Out:jpj,kcur:nbIn2Out:jpk);
		end;
	end;
	switch Mopt
		case 0,	field_out = field_out'./nbIn2Out^2;
		otherwise, field_out = field_out';
	end

elseif jpk > 1 & jpj == 1 & jpi == 1 % We have a 2D field

	field_in  = Chr;
	field_out = zeros(jpk2,1); 
	for kcur = 1: nbIn2Out;
		field_out = field_out + field_in(kcur:nbIn2Out:jpk);
	end;
	switch Mopt
		case 0,	field_out = field_out'./nbIn2Out;
		otherwise, field_out = field_out;
	end




end



switch nargout
	case 1
		varargout(1) = {field_out};
end




















