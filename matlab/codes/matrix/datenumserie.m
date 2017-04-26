% datenumserie Create a time serie with datenum
%
% DTNUM = datenumserie(Y,MO,[D,M,S])
% 
% Create a timeseries of datenum: return the serial date
% numbers for corresponding elements of the Y, MO (year, month)
% and eventually D, M or S (day, minutes, seconds).
%
% This function is a fix for the fact that when calling:
%	datenum(2002:2003,1:12,1,0,0,0)
% the outcome is a 12 elements array similar to:
%	datenum(2002,1:12,1,0,0,0)
% which is not satisfactory.
% 
% When calling:
%	datenumserie(2002:2003,1:12,1,0,0,0)
% the outcome is the expected time serie of 24 elements 
% between 2002/01 and 2003/12.
%
% Created: 2011-06-17.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function [DTNUM DTNUM_b] = datenumserie(Y,MO,varargin)


%- Define default time segment edges:
D  = 1;
H  = 0;
MI = 0;
SE = 0;

%- Load user time segment edges:
switch nargin
	case 1
		MO = 1;
	case 3
		D = varargin{1};
	case 4
		D = varargin{1};
		H = varargin{2};
	case 5
		D  = varargin{1};
		H  = varargin{2};
		MI = varargin{3};
	case 6
		D  = varargin{1};
		H  = varargin{2};
		MI = varargin{3};
		SE = varargin{4};
end% switch 

%- Determine the time step of the timeseries:
if length(Y)>=1,  dt = 'y'; end% if 
if length(MO)>1, dt = 'mo';end% if 
if length(D)>1,  dt = 'd'; end% if 
if length(H)>1,  dt = 'h'; end% if 
if length(MI)>1, dt = 'mi';end% if 
if length(SE)>1, dt = 's'; end% if 

%- Loop through edges for all units:
it = 0;
for iy = 1 : length(Y)
	for im = 1 : length(MO)
		for id = 1 : length(D)
			for ih = 1 : length(H)
				for imi = 1 : length(MI)
					for is = 1 : length(SE)
						it = it + 1;
						DTNUM(it) = datenum(Y(iy),MO(im),D(id),H(ih),MI(imi),SE(is));
					end% for is
				end% for imi
			end% for ih
		end% for id
	end% for im
end% for iy

DTNUM_b = DTNUM;
[year month day hour mins secs] = decompdatenum(DTNUM_b(it));
switch dt
	case 'y'
		DTNUM_b(it+1) = datenum(year+1,month,day,hour,mins,secs);
	case 'mo'
		DTNUM_b(it+1) = datenum(year,month+1,day,hour,mins,secs);
	case 'd'
		DTNUM_b(it+1) = datenum(year,month,day+1,hour,mins,secs);
	case 'h'
		DTNUM_b(it+1) = datenum(year,month,day,hour+1,mins,secs);
	case 'mi'
		DTNUM_b(it+1) = datenum(year,month,day,hour,mins+1,secs);
	case 's'
		DTNUM_b(it+1) = datenum(year,month,day,hour,mins,secs+1);
end% switch 

end %functiondatenumserie
 


function [year month day hour mins secs] = decompdatenum(dtn)
	year  = str2num(datestr(dtn,'yyyy'));
	month = str2num(datestr(dtn,'mm'));
	day   = str2num(datestr(dtn,'dd'));
	hour  = str2num(datestr(dtn,'HH'));
	mins  = str2num(datestr(dtn,'MM'));
	secs  = str2num(datestr(dtn,'SS'));	
end% function









