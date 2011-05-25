% convert_unit Convert unit of oceanic concentration substance
%
% NEW_SUBST_CONTENT = convert_unit(SUBST_CONTENT,SUBST_TYPE,UNIT_IN,UNIT_OUT,[SIG0,VERBOSE])
% 
% Convert concentration of substance SUBST_CONTENT of type SUBST_TYPE 
% from UNIT_IN to UNIT_OUT.
%
% Inputs:
%	SUBST_CONTENT: a double array of any dimensions
%	SUBST_TYPE:
%		'OXY'  for Oxygen (O2)
%		'PHOS' for Phosphate (PO4)
%		'NITR' for Nitrate (NIO3)
%		'NIO2' for Nitrite (NIO2)
%		'SIO3' for Silicate (SIO3)
%		'SIO4' for Silice (SIO4)
%	UNIT_IN is a string with format: NUMERATOR/DENOMINATOR with:
%		NUMERATOR   = 'mol';'mmol';'mumol';'kg';'g';'mg';'l';'ml'
%		DENOMINATOR = 'kg';'g';'m3';'l';'ml'
%		Any combination is allowed.
%	UNIT_OUT: idem as UNIT_IN
%	SIG0 is a singleton or a double array of SUBST_CONTENT dimensions.
%		It contains the anomalous potential density referred to the sea
%		surface in kg/m3.
%		Conversion is computed with RHO = 1000 + SIG0.
%		If SIG0 not specified, it is set to 0.
%	VERBOSE (0/1) prints information about the conversion on screen (0 by default).
%
% Example:
%	convert_unit(300,'OXY','mumol/kg','ml/l',0,1)
%	convert_unit(9,'OXY','ml/l','mmol/l',32,1)
%
% Rq:
%	Molar mass (g/mol):
%		O  = 15.9994;   % Oxygen
%		P  = 30.973762; % Phophorus
%		Si = 28.0855;   % Silicon
%		N  = 14.0067;   % Nitrogen
%		(Source: http://www.iupac.org/publications/pac/2006/pdf/7811x2051.pdf)
%	Molar volume (l/mol):
%		OXY = 22.3916; % at standard temperature and pressure (Garcia and Gordon, 1992).
% 		% Note that for an ideal gas it is: 22.413
%		...
%	The molar volume for other substances is not documented right now, so any conversion from
%	mole to liter is impossible and will return NaN. Only mole <-> kg
%	Well, OXY is a gaz while other substances are ions, so it's not so surprising. Beside, most
%	current conversions are from mumol or mmol per m3 to per l and thus do not involved molar
%	volumes.
%
% Other source: http://www.helcom.fi/groups/monas/CombineManual/AnnexesB/en_GB/annex9app3/
%
% Created: 2009-09-16.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = convert_unit(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input check
% Number or arguments:
error(nargchk(4,6,nargin)); 

% Retrieve arguments:
subst     = varargin{1};
subst_typ = varargin{2};
subst_typ = upper(subst_typ);

unit_in  = varargin{3};
a = strread(unit_in,'%s','delimiter','/');
numerator_in   = a{1};
denominator_in = a{2};

unit_out = varargin{4};
a = strread(unit_out,'%s','delimiter','/');
numerator_out   = a{1};
denominator_out = a{2};

% Move from dm3 to l:
numerator_in    = dm3tol(numerator_in);
denominator_in  = dm3tol(denominator_in);
numerator_out   = dm3tol(numerator_out);
denominator_out = dm3tol(denominator_out);

% Check values:
if ~check_subst(subst_typ),error(get_err(1));end
if ~check_numerator(numerator_in),error(get_err(2));end
if ~check_denominator(denominator_in),error(get_err(3));end
if ~check_numerator(numerator_out),error(get_err(2));end
if ~check_denominator(denominator_out),error(get_err(3));end

% Density:
if nargin >= 5
	rho = 1000 + varargin{5};
else
	rho = 1000;
end

% Verbose operations:
if nargin >= 6
	verb = varargin{6};
else
	verb = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Conversion:
if verb 
	verb_coef(subst_typ);
end
coef1 = get_numer_factor(unit_in,unit_out,subst_typ,verb);
coef2 = get_denom_factor(unit_in,unit_out,rho,verb);
subst = subst.*coef1./coef2;
if verb
	disp(sprintf('[output] = [input]*(1)/(2)'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
varargout(1) = {subst};

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MORE IMPORTANT SUBFUNCTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function coef_list = get_coef_list(subst_typ)
	
%	coef_list(1): molar mass in g/mol
%	coef_list(2): molar density in g/l
%	coef_list(3): molar volume (l/mol) is thus: coef_list(1)/coef_list(2)
%	coef_list(4) = 1e3/coef_list(3);

	% Source: http://www.iupac.org/publications/pac/2006/pdf/7811x2051.pdf
	% Molar mass:
	O  = 15.9994;   % Oxygen
	P  = 30.973762; % Phophorus
	Si = 28.0855;   % Silicon
	N  = 14.0067;   % Nitrogen
	
	coef_list(1:2) = NaN;
	switch subst_typ
		case 'OXY' 
			coef_list(1) = 2*O; % Molar mass g/mol
			coef_list(3) = 22.3916; % Molar volume l/mol (22.413 for a perfect gas)
			coef_list(2) = coef_list(1)/coef_list(3); % Molar density g/l
			coef_list(4) = 1e3/coef_list(3); % Never use here but from time to time in other routines of conversion

			% ACCORDING TO THE ARGO DATA MANAGEMENT USER'S MANUAL V2.2 OF AUG 26, 2009:
			% REMARK ON UNIT CONVERSION OF OXYGEN:
			% The unit of DOXY is micromole/kg in Argo data and the oxygen measurements are sent from 
			% Argo floats in another unit such as micromole/L for Optode and ml/L for SBE. Thus the unit 
			% conversion is carried out by DACs as follows: 
			% 	! O2 [micromole/kg] = O2 [micromole/L] / rho
			% 	! O2 [micromole/L] = 44.6596 × O2 [ml/L] 
			% Here, rho is the potential density of water [kg/L] at zero pressure and at the potential 
			% temperature (e.g., 1.0269 kg/L; e.g., UNESCO, 1983). The value of 44.6596 is derived from 
			% the molar volume of the oxygen gas, 22.3916 L/mole, at standard temperature and pressure 
			% (0°C, 1 atmosphere; e.g., García and Gordon, 1992).
			% UNESCO (1983): Algorithms for computation of fundamental properties of seawater. Unesco 
			% 	technical papers in marine science, 44, 53pp.			

		case 'PHOS'
			coef_list(1) = P + 4*O;
		case 'NITR' % NO3
			coef_list(1) = N + 3*O; 
		case 'NIO2'
			coef_list(1) = N + 2*O;
		case 'SIO3'
			coef_list(1) = Si + 3*O;
		case 'SIO4'
			coef_list(1) = Si + 4*O;
	end%switch
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function subst_list = get_list_subst(varargin)
	subst_list = {'OXY';'PHOS';'NITR';'NIO2';'SIO3';'SIO4'};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOWER LEVEL SUBFUNCTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function coef = get_numer_factor(unit_in,unit_out,subst_typ,verb)
	
	% Get coefficients appropriate for the substance
	coef_list = get_coef_list(subst_typ);
	
	a = strread(unit_in,'%s','delimiter','/');
	numerator_in   = a{1};
	a = strread(unit_out,'%s','delimiter','/');
	numerator_out   = a{1};
	if strcmp(numerator_out,'dm3'),numerator_out='l';end
	
	% Power of 10:
	c(1,:) = [     0  ;   3  ;   6  ;  -3  ;   0  ;   3  ;   0  ;  3  ]; % mol
	c(2,:) = [     0  ;   0  ;   3  ;  -6  ;  -3  ;   0  ;  -3  ;  0  ]; % mmol
	c(3,:) = [     0  ;   0  ;   0  ;  -9  ;  -6  ;  -3  ;  -6  ; -3  ]; % mumol
	c(4,:) = [     0  ;   0  ;   0  ;   0  ;   3  ;   6  ;   3  ;  6  ]; % kg
	c(5,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   3  ;   0  ;  3  ]; % g
	c(6,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -3  ;  0  ]; % mg
	c(7,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  3  ]; % l
	c(8,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  0  ]; % ml
	c = c - transpose(c); % Ensure symetry, we only filled the upper right
%	if ~isempty(find(tril(c)+triu(c)'~=0)),error(get_err(4));end % Check symetry
%	if ~isempty(find(c+transpose(c)~=0)),error(get_err(4));end % Check symetry
	
	% Power of molar mass (g/mol):
	d(1,:) = [     0  ;   0  ;   0  ;   1  ;   1  ;   1  ;   1  ;  1  ];
	d(2,:) = [     0  ;   0  ;   0  ;   1  ;   1  ;   1  ;   1  ;  1  ];
	d(3,:) = [     0  ;   0  ;   0  ;   1  ;   1  ;   1  ;   1  ;  1  ];
	d(4,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  0  ];
	d(5,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  0  ];
	d(6,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  0  ];
	d(7,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  0  ];
	d(8,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  0  ];
	d = d - transpose(d); % Ensure symetry, we only filled the upper right

	% Power of molar density:
	g(1,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -1  ;  -1  ];
	g(2,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -1  ;  -1  ];
	g(3,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -1  ;  -1  ];
	g(4,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -1  ;  -1  ];
	g(5,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -1  ;  -1  ];
	g(6,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;  -1  ;  -1  ];
	g(7,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ];
	g(8,:) = [     0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ;   0  ];
	g = g - transpose(g); % Ensure symetry, we only filled the upper right

	% 
	numer_list = get_list_numerator;
	for iin =1:length(numer_list),if strcmp(numer_list{iin},numerator_in),  break;end;end
	for iout=1:length(numer_list),if strcmp(numer_list{iout},numerator_out),break;end;end
	
	coef = 10.^c(iin,iout);
	opr_str = sprintf('10^%i',c(iin,iout));
	if d(iin,iout)~=0
		coef    = coef*coef_list(1).^d(iin,iout);
		opr_str = sprintf('%s * c1^%i',opr_str,d(iin,iout));
	end
	if g(iin,iout)~=0, 
		coef    = coef*coef_list(2).^g(iin,iout);
		opr_str = sprintf('%s * c2^%i',opr_str,g(iin,iout));
	end
	if verb,disp(sprintf('(1) [%s] = [%s] * %s',numerator_out,numerator_in,opr_str));end
	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function coef = get_denom_factor(unit_in,unit_out,rho,verb)
	
	a = strread(unit_in,'%s','delimiter','/');
	denominator_in = a{2};
	if strcmp(denominator_in,'dm3'),denominator_in='l';end
	a = strread(unit_out,'%s','delimiter','/');
	denominator_out = a{2};
	if strcmp(denominator_out,'dm3'),denominator_out='l';end
	
	% Power of 10:
	c(1,:) = [     0  ;   3  ;   0  ;   3  ;   6 ];
	c(2,:) = [    -3  ;   0  ;   3  ;   6  ;   9 ];
	c(3,:) = [     0  ;  -3  ;   0  ;   3  ;   6 ];
	c(4,:) = [    -3  ;  -6  ;  -3  ;   0  ;   3 ];
	c(5,:) = [    -6  ;  -9  ;  -6  ;  -3  ;   0 ];
	% Power of rho:
	d(1,:) = [     0  ;   0  ;  -1  ;  -1  ;  -1 ];
	d(2,:) = [     0  ;   0  ;  -1  ;  -1  ;  -1 ];
	d(3,:) = [     1  ;   1  ;   0  ;   0  ;   0 ];
	d(4,:) = [     1  ;   1  ;   0  ;   0  ;   0 ];
	d(5,:) = [     1  ;   1  ;   0  ;   0  ;   0 ];

	% 
	denom_list = get_list_denominator;
	for iin =1:length(denom_list),if strcmp(denom_list{iin},denominator_in), break;end;end
	for iout=1:length(denom_list),if strcmp(denom_list{iout},denominator_out),break;end;end
	
	coef    = 10.^c(iin,iout);
	opr_str = sprintf('10^%i',c(iin,iout));
	if d(iin,iout)~=0, 
		coef    = coef*rho.^d(iin,iout);
		opr_str = sprintf('%s * rho^%i',opr_str,d(iin,iout));
	end
	if verb,disp(sprintf('(2) [%s] = [%s] * %s',denominator_out,denominator_in,opr_str));end

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function N = avogadro(varargin)
	N = 6.02214179*1e23;
end%function
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function varargout = verb_coef(subst_typ)
	coef_list = get_coef_list(subst_typ);
	disp('For molar species, volume unit is liter');
	for ii = 1 : length(coef_list)
		if ~isnan(coef_list(ii))
			switch ii
				case 1, disp(sprintf('Molar Mass    : c1 = %2.6f g/mol',coef_list(ii)));
				case 2, disp(sprintf('Molar Density : c2 = %2.6f g/l',coef_list(ii)));
				case 3, disp(sprintf('Molar Volume  : c3 = %2.6f l/mol (Molar Mass/Density <=> c1/c2)' ,coef_list(ii)));
				case 4, disp(sprintf('Misc. coef.   : c4 = %2.6f mmol/l (10^3 / Molar volume <=> 1e3*c2/c1)' ,coef_list(ii)));
			end
		end
	end%for ii
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function res = check_subst(subst)
	subst_list = get_list_subst;
	if isempty(cell2mat(strfind(subst_list,subst)))
            res = false;
    else
            res = true;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function res = check_denominator(unit)
	unit_list = get_list_denominator;
	if isempty(cell2mat(strfind(unit_list,unit)))
            res = false;
    else
            res = true;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function unit_list = get_list_denominator(varargin)
	unit_list = {'kg';'g';'m3';'l';'ml'};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function res = check_numerator(unit)
	unit_list = get_list_numerator;
	if isempty(cell2mat(strfind(unit_list,unit)))
            res = false;
    else
            res = true;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function unit_list = get_list_numerator(varargin)
	unit_list = {'mol';'mmol';'mumol';'kg';'g';'mg';'l';'ml'};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function str = dm3tol(str);
	if strcmp(str,'dm3'), str = 'l'; end
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function msgstruct = get_err(id,varargin)
	switch id
		case 1
			msgstruct.identifier = 'convert_unit:substance_unknown';
			msgstruct.message    = 'Unknown substance !';
		case 2
			msgstruct.identifier = 'convert_unit:unit_numerator_unknown';
			msgstruct.message    = 'Unit at numerator not supported !';
		case 3
			msgstruct.identifier = 'convert_unit:unit_denominator_unknown';
			msgstruct.message    = 'Unit at denominator not supported !';
		case 4
			msgstruct.identifier = 'convert_unit:conversion_matrix';
			msgstruct.message    = 'Conversion matrix inconsistent';
	end
end

