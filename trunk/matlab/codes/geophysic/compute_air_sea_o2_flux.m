% compute_air_sea_o2_flux Compute air-sea oxygen flux
%
% F = compute_air_sea_o2_flux(METHOD,PARAMETERS)
% 
% Compute air-sea oxygen flux in mol/m2/s
% F is positive upward, ie for outgasing (reduction of oceanic O2)
%
% Inputs:
%	METHOD can 1 or 2:
%	METHOD = 1 : Compute the thermal component of the flux
%		as: F = -dSOL/dT * Q/Cp
%		PARAMETERS are then:
%			SST: Sea Surface Temperature in degC
%			SSS: Sea Surface Salinity in psu
%		 	Q: Air-sea heat flux (negative cooling the ocean)
%	METHOD 2 : Compute the real flux as: F = k(O2-O2sat)
%		PARAMETERS are then:
%			SST: Sea Surface Temperature in degC
%			SSS: Sea Surface Salinity in psu
%			OXY: Sea Surface Oxygen concentration in mumol/kg
%			U10: Wind speed at 10m height in m/s
%			RHO: (optional) Sea Water Density in kg/m3
%			
% Output:
%	F: air-sea oxygen flux in mol/m2/s
%
% Example:
%	SST = 25; 
%	SSS = 35.5;
%	Q   = -120;
%	F = compute_air_sea_o2_flux(1,SST,SSS,Q)
%
%	SST = 25; 
%	SSS = 35.5;
%	OXY = 280;
%	U10 = 5;
%	F = compute_air_sea_o2_flux(2,SST,SSS,OXY,U10)
%
% Created: 2010-06-28.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = compute_air_sea_o2_flux(method,varargin)

switch method
	%- The thermal component of the flux:
	% F = -dSOL/dT * Q/Cp
	case 1 
		SST = varargin{1}; % degC
		SSS = varargin{2}; % PSU
		Q   = varargin{3}; % W/m2
		[n1 n2] = size(Q);
		if length(SST) == 1 % We assume SST and SSS of similar dimensions
			dSOLdT = 1e-6*oxyfluxtherm(SST,SSS,'mumol/kg');
			dSOLdT = ones(n1,n2)*dSOLdT;
			CP     = sw_cp(SSS,SST,0);
			CP     = ones(n1,n2)*CP;
		else
			dSOLdT = 1e-6*oxyfluxtherm(SST,SSS,'mumol/kg');
			CP     = sw_cp(SSS,SST,0);		
		end			
		% Compute air-sea O2 flux:		
		F = -dSOLdT.*Q./CP; % mol/m2/s
		% If Q<0 (cooling the ocean)  we increase the capacity of the ocean to 
		% get oxygen and because dSOLdT<0, F is then negative, downward (ingasing)
		
		varargout(1) = {F};
		switch nargout
			case 2
				varargout(1) = {F};
				varargout(2) = {dSOLdT};
			case 3
				varargout(1) = {F};
				varargout(2) = {dSOLdT};
				varargout(3) = {CP};
		end%switch
		
	%- Use Oxygen concentration, solubility and piston velocity
	% F = k*(O2-O2s)
	case 2
		SST = varargin{1};
		SSS = varargin{2};
		OXY = varargin{3};
		U10 = varargin{4};
		if nargin == 6
			RHO = varargin{5};
		else
			RHO = densjmd95(SSS,SST,0);
		end
		% Compute solubility in mumol/kg:
		SOL = oxysol(SST,SSS,'mumol/kg');

		% Compute piston velocity:
		Sc = schmidt_number('OXY',SST,SSS);
		kw = piston_velocity('OXY','Sc',Sc,'U',U10);
		
		% Move from mumol/kg to mol/m3
		OXY = 1e-6*OXY.*RHO;
		SOL = 1e-6*SOL.*RHO;
		
		% Compute air-sea O2 flux:
		F = kw.*(OXY-SOL);
		% If OXY > SOL, we have supersaturation and oxygen is release to the
		% atmosphere, we have outgasing and F is positive upward, reducing oxygen in the ocean
		
		varargout(1) = {F};
		switch nargout
			case 2
				varargout(1) = {F};
				varargout(2) = {SOL};
			case 3
				varargout(1) = {F};
				varargout(2) = {SOL};
				varargout(3) = {kw};
			case 4
				varargout(1) = {F};
				varargout(2) = {SOL};
				varargout(3) = {kw};
				varargout(4) = {Sc};
		end%switch
		
		
end %functioncompute_air_sea_o2_flux






















