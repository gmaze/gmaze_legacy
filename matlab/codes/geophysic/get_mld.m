% get_mld Compute a mixed layer depth
% 
% ------------------ Method 1:
% H = get_mld(S,T,Z) Compute a mixed layer depth (MLD) from vertical profiles 
% 	of salinity and temperature, given depth of samples.
% 	The MLD is the first depth for which:
%		SIG0(T,S) > SIG0(T(z=0)-0.8,S(z=0))
% Inputs:
%	S: salinity (PSS-78, psu)
%	T: temperature (ITS-90, degC)
%	Z: depth (m) from top to bottom
% Output:
%	H: mixed layer depth (m)
% Rq:
%	- temperature is converted to potential temperature using the CSIRO SeaWater 
%	library function 'sw_ptmp' 
%	(You can get the library at: http://www.cmar.csiro.au/datacentre/ext_docs/seawater.htm)
%	- Potential density is computed using the 'sw_pden' function
%
% ------------------ Method 2:
% H = get_mld(SIG0,Z) Compute MLD from the vertical profile of potential density
% 	referenced to surface SIG0, defined on the depth axis Z.
% 	The MLD is the interpolated depth for which:
% 		SIG0 = SIG0(z=10) + 0.03
% 	It is the MLD_DR003 variables from de Boyer Montégut et al., 2004
% 
% ------------------
% We assume the vertical axis to be sorted from top (surface) to bottom.
% 
% Created: 2009-11-19.
% Rev. by Guillaume Maze on 2011-05-25: Added help
% Revised: 2014-10-18 (G. Maze) Added MLD_DR003 method
% Revised: 2014-10-18 (G. Maze) Change densjmd95 to sw_pden
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function MLD = get_mld(varargin)

switch nargin
	case 3 %- Method 1:
		S = varargin{1};
		T = varargin{2};
		Z = varargin{3};

		S = S(:);
		T = T(:); 
		Z = Z(:);
		P = 0.09998*9.81*abs(Z);
		T = sw_ptmp(S,T,P,0);

		[zmin iz0] = min(abs(Z));
		if isnan(T(iz0))
			iz0 = iz0+1;
		end

		SST = T(iz0);
		SSS = S(iz0);

		SST08 = SST - 0.8;
		%SSS   = SSS + 35;
		%Surfadens08 = densjmd95(SSS,SST08,P(iz0))-1000;
		%ST = densjmd95(S,T,P)-1000;
		Surfadens08 = sw_pden(SSS,SST08,P(iz0))-1000;
		ST = sw_pden(S,T,P)-1000;

		mm =  find( ST > Surfadens08 );
		if ~isempty(mm)
			MLD = Z(min(mm));
		else
			MLD = NaN;
		end
		
	case 2 %- Method 2:
		SIG0 = varargin{1};
		Z    = varargin{2};
		iz   = find(~isnan(SIG0));
		if isempty(iz)
			warning('Profile full of NaNs !');
			MLD = NaN;
			return;
		end% if 
		if max(Z(iz)) < -10
			warning('The first profile level must be shallower or equal to -10m !');
			MLD = NaN;
			return;
		end% if 		
		Z    = Z(iz);
		SIG0 = SIG0(iz);
		
		[SIG0 iz] = unique(SIG0);
		Z = Z(iz);
		
		SIG0_10 = interp1(Z,SIG0,-10);
		MLD = interp1(SIG0,Z,SIG0_10 + 0.03);
				
end %functionget_mld





