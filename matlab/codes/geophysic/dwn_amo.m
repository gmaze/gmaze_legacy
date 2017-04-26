function [AMO tim] = dwn_amo(varargin)
% dwn_amo Return the AMO Atlantic Multidecadal Oscillation index
%
% [AMO_index AMO_time] = dwn_amo() Return the AMO index.
%
%	The timeseries are calculated from the Kaplan SST dataset 
% which is updated monthly. The AMO is the detrended SST area weighted 
% average over the N Atlantic (0 to 70N) smoothed with a 121 month smoother.
% 
% Source:
% 	http://www.esrl.noaa.gov/psd/data/timeseries/AMO/
% 
% References:
% 	Enfield, D.B., A.M. Mestas-Nunez, and P.J. Trimble, 2001: The Atlantic 
% Multidecadal Oscillation and its relationship to rainfall and river flows 
% in the continental U.S., Geophys. Res. Lett., 28: 2077-2080.
%
% See Also: dwn_nao
%
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-09-11 (G. Maze)

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

%- Default parameters:

%- Load user parameters:
if nargin ~= 0
    if mod(nargin,2) ~= 0
        error('Parameters must come in pairs: PAR,VAL');
    end% if
    for in = 1 : 2 : nargin
        eval(sprintf('%s = varargin{in+1};',varargin{in}));
    end% for in
    clear in
end% if

%- Get the time series:
url = 'http://www.esrl.noaa.gov/psd/data/correlation/amon.us.long.data'; % AMO unsmooth, long
url = 'http://www.esrl.noaa.gov/psd/data/correlation/amon.sm.long.data'; % AMO smoothed, long.
url = 'http://www.esrl.noaa.gov/psd/data/correlation/amon.us.data'; % AMO unsmoothed, short (1948 to present).
url = 'http://www.esrl.noaa.gov/psd/data/correlation/amon.sm.data'; % AMO smoothed, short (1948 to present).
amo_path = '~/matlab/codes/data/';
amo_file = sprintf('AMO_%s.txt',datestr(now,'yyyymm')); % File name with month because it is updated monthly online
if ~exist(fullfile(amo_path,amo_file),'file')
	% Download file:
	system(sprintf('wget -q -O %s%s ''%s''',amo_path,amo_file,url));
	% Load last data:
	% File format doc: http://www.esrl.noaa.gov/psd/gcos_wgsp/Timeseries/standard/
	fid = fopen(fullfile(amo_path,amo_file));
	% Read year1 yearend
		a = textscan(fgetl(fid),'%f');
		year1   = a{1}(1);
		yearend = a{1}(2);
		clear a
	% Read data
	iy=0;tim=[];AMO=[];
	for year = year1 : yearend
		a = textscan(fgetl(fid),'%f');
		if a{1}(1)~=year
			error('I don''t know how to load this file !')
		end% if 
		iy=iy+1;
		tim = cat(1,tim,datenum(year,1:12,15)');
		AMO = cat(1,AMO,a{1}(2:end));
	end% for 
	% Read filling value
	a = textscan(fgetl(fid),'%f');
	fillval = a{1}(1);
	AMO(AMO==fillval) = NaN;
	fclose(fid);
	save(fullfile(amo_path,strrep(amo_file,'.txt','.mat')),'AMO','tim');
end
load(fullfile(amo_path,strrep(amo_file,'.txt','.mat')));

end %functiondwn_amo