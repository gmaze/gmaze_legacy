% lldist Compute distance in m between two points on Earth
%
% D = lldist(LAT,LON,[METHOD])
% 
% Compute distance in m between two points on Earth.
%
% Inputs:
%	LAT (double): Latitude (degree)
%	LON (double): Longitude (degree)
%	METHOD (optional, integer): Define the method to use:
%		1: Haversine formula
%		2: (default) Vincenty inverse formula with WGS-84 ellipsoid using mex file
%		3: Vincenty inverse formula with WGS-84 ellipsoid using Matlab routine
%
% Output:
%	D (double): distance in meters between points
%
% References:
%	T. Vincenty, Direct and inverse solutions of geodesics on the ellipsoid 
%		with applications of nested equations. 
%		Survey Review XXII, 176, April 1975
%		http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
%
%	Vincenty formulae:  http://en.wikipedia.org/wiki/Vincenty%27s_formulae
%	Haversine formulae: http://en.wikipedia.org/wiki/Haversine_formula
%
% Created: 2009-09-30.
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

function varargout = lldist(varargin)

lat = varargin{1};
lon = varargin{2};
method = 2; % Default
if nargin == 3
	method = varargin{3};
end


switch method
	case 1 %  Haversine formula, accurate to 0.3%
		if length(lat) == 1 & length(lon)>1
			lat = lat*ones(1,length(lon));
		elseif length(lon) == 1 & length(lat)>1
			lon = lon*ones(1,length(lat));
		end
		pi180=pi/180;
		earth_radius=6378.137e3;

		long1=lon(1:end-1)*pi180;
		long2=lon(2:end)*pi180;
		lat1=lat(1:end-1)*pi180;
		lat2=lat(2:end)*pi180;

		dlon = long2 - long1; 
		dlat = lat2 - lat1; 
		a = (sin(dlat/2)).^2 + cos(lat1) .* cos(lat2) .* (sin(dlon/2)).^2;
		c = 2 * atan2( sqrt(a), sqrt(1-a) );
		dist = earth_radius * c;
		
		dist = dist(:)';
		
	case 2 % Vincenty formula, accurate to 0.5mm ! using mex file

			if length(lat) == 1 & length(lon)>1
				lat = lat*ones(1,length(lon));
			elseif length(lon) == 1 & length(lat)>1
				lon = lon*ones(1,length(lat));
			end

			if sum(diff(lon))/(length(lon)-1) == diff(lon(1:2)) % Regular axis
				d = vincenty(lat(1),lat(2),lon(1),lon(2)); % This is the mex file, much faster !!!!
				dist = d*ones(1,length(lon)-1);
			else
				% Loop over each pair of points:
				for ip = 1 : length(lon)-1
					lo = lon(ip:ip+1);
					la = lat(ip:ip+1);
					if lo(1) == lo(2) && la(1) == la(2)
						dist(ip) = 0;
					else
						dist(ip) = vincenty(la(1),la(2),lo(1),lo(2)); % This is the mex file, much faster !!!!
					end%if
				end%for ip	
			end%if
	

	case 3 % Vincenty formula, accurate to 0.5mm !

		if length(lat) == 1 & length(lon)>1
			lat = lat*ones(1,length(lon));
		elseif length(lon) == 1 & length(lat)>1
			lon = lon*ones(1,length(lat));
		end

		% Loop over each pair of points:
		for ip = 1 : length(lon)-1
			lo = lon(ip:ip+1);
			la = lat(ip:ip+1);
			if lo(1) == lo(2) && la(1) == la(2)
				dist(ip) = 0;
			else
				% 		WGS-84  		a = 6 378 137 m (±2 m)  b = 6 356 752.3142 m  	f = 1 / 298.257223563
				%   	GRS-80 			a = 6 378 137 m 		b = 6 356 752.3141 m 	f = 1 / 298.257222101
				%   	Airy (1830) 	a = 6 377 563.396 m 	b = 6 356 256.909 m 	f = 1 / 299.3249646
				%   	Int’l 1924 		a = 6 378 388 m 		b = 6 356 911.946 m 	f = 1 / 297
				%   	Clarke (1880) 	a = 6 378 249.145 m 	b = 6 356 514.86955 m 	f = 1 / 293.465
				%   	GRS-67 			a = 6 378 160 m 		b = 6 356 774.719 m 	f = 1 / 298.25
				% %WGS-84 ellipsoid:
				a = 6378137;
				b = 6356752.3142;
				f = 1/298.257223563; % or: (a-b)/a
				L = (lo(2)-lo(1))*pi/180; % in radian
				la = la*pi/180;
				U1 =  atan( (1-f)*tan(la(1))); % Reduced latitude
				U2 =  atan( (1-f)*tan(la(2)));
				l  = 0; % 1st approximation
				lp = L; % 1st approximation
				niter = 0; 
				while niter < 1e5 | abs(lp-l) > 1e-13
					l = lp;
					if niter > 1e5
						lp = pi;
					end
					sinsigma = sqrt(   (cos(U2)*sin(l))^2 + ( cos(U1)*sin(U2) - sin(U1)*cos(U2)*cos(l) )^2 );
					cossigma = sin(U1)*sin(U2) + cos(U1)*cos(U2)*cos(l);
					sigma = atan2(sinsigma,cossigma);
					sinalpha = cos(U1)*cos(U2)*sin(l)/sinsigma;
					cosalphaSQ = 1 - sinalpha^2;
					if sin(U1)*sin(U2) == 0 && cosalphaSQ == 0
						cos2sigmaM = 0; % This for latitude = 0
					else
	%					cos2sigmaM = cos(sigma) - 2*sin(U1)*sin(U2)/cosalphaSQ;
						cos2sigmaM = cossigma - 2*sin(U1)*sin(U2)/cosalphaSQ;
					end
					C = f/16*cosalphaSQ*( 4+f*(4-3*cosalphaSQ) );
					lp = L + (1-C)*f*sinalpha*( sigma+C*sinsigma*( cos2sigmaM + C*cossigma*(-1+2*cos2sigmaM^2)  )  );
					if lp > pi
						lp = pi;
					end
					niter = niter + 1;
				end%while
				uSQ = cosalphaSQ*(a^2-b^2)/b^2;
				A = 1 + uSQ/16384*( 4096+uSQ*(-768+uSQ*(320-175*uSQ))  );
				B = uSQ./1024*(256+uSQ*(-128+uSQ*(74-47*uSQ)));
				dsigma = B*sinsigma*(cos2sigmaM+B/4*(cossigma*(-1+2*cos2sigmaM^2)-B/6*cos2sigmaM*(-3+4*sinsigma^2)*(-3+4*cos2sigmaM^2)));
				dist(ip) = b*A*(sigma-dsigma);
			end%if
		end%for ip	

		
end%switch

varargout(1) = {dist};

			
end %functionlldist











