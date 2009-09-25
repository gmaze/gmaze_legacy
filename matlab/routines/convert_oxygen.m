% convert_oxygen O2 unit conversion
%
% [valout] = convert_oxygen(valin,uin,uout,[aST0])
% 
% Cette fonction convertit les données d'oxygène d'une unité à l'autre 
%
% valout   = valeur d'oxygene converties dans l'unité uout 
% valin    = valeur d'oxygene en entrée dans l'unité uin 
% aST0     = anomalie de densité potentielle référencée à 0 de l'eau 
%			considérée, si aucun valeur n'est entrée, on considère qu'on 
%			a de l'eau douce et l'anomalie de densité est nulle 
%			(rho=1000) sinon rho = 1000 + aST0 
%
% uin et uout sont: 
% 	ml/l: milli litre par litre 
% 	mmol/m3: milli mole par mètre cube 
% 	mumol/l: micromole par litre 
% 	mg/l : milli gramme par litre 
% 	mumol/kg : micromole par kilo 
% 	ml/l * 44.66 = mmol/m3 = mumol/l 
% 	ml/l*1.42903 = mg/l 
% 	mg/l * 44.66/1.42903 = mumol/l =mmol/m3 
% 	mumol/l = (rho/1000)* mumol/kg
%
%
% Created: 2008-05 by C.LAGADEC
% Rev. by Guillaume Maze on 2009-07-31: Moved unit to lower string for flexibility
% Rev. by Guillaume Maze on 2009-09-02: Add micromol to millimol automatic conversion
% Copyright (c) 2009 LPO
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function valout = convert_oxygen(valin,uin,uout,varargin) 


valout = convert_unit(valin,'OXY',uin,uout,varargin{:});


return






coef1 = 44.66; % mmol/l
coef2 = 1.42903; % g/l
% Rev. by Guillaume Maze on 2009-09-17: I think these values are not consistent !

if nargin == 3 
    rho = 1000; 
elseif nargin == 4 
    rho = varargin{1}+1000; 
end 
coef3=1000./rho; 

valout=[]; 
uin  = lower(uin);
uout = lower(uout);
uin  = strrep(uin,'micromoles','mumol');
uin  = strrep(uin,'micromole','mumol');
uout = strrep(uout,'micromoles','mumol');
uout = strrep(uout,'micromole','mumol');

if strcmp(uin,'mmol/l'),valin=valin*1e3;uin='mumol/l';end
if strcmp(uin,'mmol/kg'),valin=valin*1e3;uin='mumol/kg';end

switch uin 
	%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ml/l'
        switch uout 
            case {'mmol/m3','mumol/l'} 
                valout=valin*coef1; 
            case 'mg/l'
                valout=valin*coef2; 
            case 'mumol/kg' 
                valout=valin*coef1.*coef3; 
        end 

	%%%%%%%%%%%%%%%%%%%%%%%%
    case {'mmol/m3','mumol/l'} 
        switch uout 
            case 'ml/l'
                valout=valin/coef1; 
            case 'mg/l' 
                valout=valin*coef2/coef1; 
            case 'mumol/kg' 
                valout=valin.*coef3; 
        end

	%%%%%%%%%%%%%%%%%%%%%%%%
    case 'mg/l' 
        switch uout 
            case 'ml/l'
                valout=valin/coef2; 
            case {'mmol/m3','mumol/l'} 
                valout=valin*coef1/coef2; 
            case 'mumol/kg' 
                valout=valin.*coef3*coef1/coef2; 
        end 

	%%%%%%%%%%%%%%%%%%%%%%%%
    case 'mumol/kg' 
        switch uout 
            case 'ml/l'
                valout=valin./(coef1*coef3);
            case {'mmol/m3','mumol/l'} 
                valout=valin./coef3; 
            case 'mg/l' 
                valout=valin*coef2./(coef3*coef1); 
        end 

	%%%%%%%%%%%%%%%%%%%%%%%%
	otherwise
		error(sprintf('Unknown 1st unit: %s',uin))
end 


% switch nargout
% 	case 1
% 		varargout(1) = {valout};
% end

end %function