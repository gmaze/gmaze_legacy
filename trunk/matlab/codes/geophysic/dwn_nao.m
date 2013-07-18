% dwn_nao Download the monthly NAO index
%
% [NAO_index, NAO_time] = dwn_nao([DT])
% 
% Download the monthly NAO index at:
% http://www.cpc.noaa.gov/products/precip/CWlink/pna/norm.nao.monthly.b5001.current.ascii
%
% Inputs:
%	DT is the time step of the time serie
%		By default it is set to 'm' for monthly values
%		It can be:
%			'y' for yearly means
%			'w' for yearly winter values (DJFM average)
%
% Outputs:
%	NAO_index: well, the NAO index !
%	NAO_time: the time axis as returned by datenum
%
% Rq: The downloaded file is stored in ~/matlab/routines/data subdirectory
%
% Created: 2009-05-29.
% Rev. by Guillaume Maze on 2009-09-01: Add winter value option
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = dwn_nao(varargin)

if nargin == 0
	DT = 'm';
else
	DT = varargin{1};
end

% Get the original time serie:
url = 'http://www.cpc.noaa.gov/products/precip/CWlink/pna/norm.nao.monthly.b5001.current.ascii';
nao_path = '~/matlab/codes/data/';
nao_file = sprintf('NAO_%s.txt',datestr(now,'yyyymm'));
if ~exist(sprintf('%s%s',nao_path,nao_file),'file')
	system(sprintf('wget -q -O %s%s ''%s''',nao_path,nao_file,url));
	load(sprintf('%s%s',nao_path,nao_file));
	eval(sprintf('NAO = %s;',strrep(nao_file,'.txt','')));
	save(sprintf('%s%s',nao_path,strrep(nao_file,'.txt','.mat')),'NAO');
end
load(sprintf('%s%s',nao_path,strrep(nao_file,'.txt','.mat')));

NAO_t = datenum(NAO(:,1),NAO(:,2),15,0,0,0);
NAO_T = datestr(datenum(NAO(:,1),NAO(:,2),15,0,0,0),'yyyymm');
NAO   = NAO(:,3);

% Adjust to what is asked:
switch DT
	case 'm'
		% Original t resolution
		NAO_i 	 = NAO';
		NAO_tfin = NAO_t';
	case 'y'
		% Move to yearly means
		y0 = str2num(datestr(NAO_t(1),'yyyy'));
		ye = str2num(datestr(NAO_t(end),'yyyy'));
		ii = 0;
		for y = y0 : ye
			ii = ii + 1;
			iy = find(str2num(NAO_T(:,1:4))==y);
			if ~isempty(iy)
				NAO_i(ii) = mean(NAO(iy));
			else
				NAO_i(ii) = NaN;
			end %if 
			NAO_tfin(ii) = datenum(y,1,1,0,0,0);
		end%for y
	case 'w'
		% 
		t  = str2num(datestr(NAO_t,'yyyy'));
		tm = str2num(datestr(NAO_t,'mm'));
		for ye = min(t) : max(t)
			ii = find(  (t==ye & (tm==12)) | (t==ye+1 & (tm==1 | tm==2 | tm==3)) );
			if ~isempty(ii)
				nao_index(ye) = nanmean(NAO(ii));
			else
				nao_index(ye) = NaN;
			end
		end
		NAO_i    = nao_index(min(t) : max(t));
		NAO_tfin = datenum(min(t) : max(t),1,1,0,0,0);
end


switch nargout
	case 1
		varargout(1) = {NAO_i};
	case 2
		varargout(1) = {NAO_i};
		varargout(2) = {NAO_tfin};
end


end %function