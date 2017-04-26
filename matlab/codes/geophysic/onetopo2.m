function h = onetopo2(lon,lat)
% onetopo2 Load ETOPO2 value at one location
%
% h = onetopo2(lon,lat) 
% 
% Copyright (c) 2014, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2014-12-08 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
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

PATHNAME='~/data/NGDC/ETOPO2/';
efid = fopen([PATHNAME 'etopo2_2006apr.raw'],'r','b'); % in big-endian format

% Etopo2 grid on this file:
x_etopo2 = -180:1/30:180;     nx = length(x_etopo2);
y_etopo2 = 90-1/30:-1/30:-90; ny = length(y_etopo2);

% Work in -180:180:
if lon>180, lon = lon-360; end

% Localize the 4 grid points around the required location:
ix = [find(x_etopo2<lon,1,'last') find(x_etopo2>=lon,1,'first')];
iy = [find(y_etopo2>lat,1,'last') find(y_etopo2>=lat,1,'last')];

% 
wordlen = 2;
H = zeros(length(iy),length(ix)).*NaN;
for i = 1 : length(iy)
	for j = 1 : length(ix)
		fseek(efid,wordlen*( (iy(i)-1)*nx + ix(j) ),'bof');
		H(i,j) = fread(efid,1,'int16');
	end% for ix
end% for iy
h = nanmean(H(:));

%
fclose(efid);

end %functiononetopo2