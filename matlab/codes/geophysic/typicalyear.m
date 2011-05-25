% typicalyear Compute a typical year from a daily volume time serie
%
% [] = typicalyear(V,pivot,t0)
% 
% pivot = '1231'
% t0 = datenum('First date of the timeserie')
%
% Created: 2008-11-06.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = typicalyear(varargin)

V   = varargin{1}; V = V(:);
piv = varargin{2};
t0  = varargin{3};
t0  = datestr(t0,'yyyymmddHHMM');

nn = length(V);
ny = fix(nn/365);

%tY = datenum(0,12,1,0,0,0):datenum(0,12,1,0,0,0)+364;
tY    = datenum(0,str2num(t0(5:6)),str2num(t0(7:8)),0,0,0):datenum(0,str2num(t0(5:6)),str2num(t0(7:8)),0,0,0)+364;
pivot = -find(str2num(datestr(tY,'mmdd'))==str2num(piv))-1;

% Work in dV/dt
dV = diff(V,1,1);
 
% Find indices
for ii=0:ny-1
	t2(ii+1,:) = ii*365+1:(ii+1)*365;
end

for iy = 1 : ny
	a(iy,:) = dV(t2(iy,:));
end
dV = a; clear a


% Mean/std over ny of the dV/dt
dVm = squeeze(nanmean(dV,1))';
dVs = squeeze(nanstd(dV,1,1))';
 

% Mean of the cumsum:
Vm = cumsum(circshift(dVm,pivot));
Vs = cumsum(circshift(dVs,pivot));
tY = datenum(0,str2num(piv(1:2)),str2num(piv(3:4)),0,0,0):datenum(0,str2num(piv(1:2)),str2num(piv(3:4)),0,0,0)+364;


varargout(1) = {Vm};

switch nargout
	case 2
		varargout(2) = {tY};
	case 3
		varargout(2) = {tY};
		varargout(3) = {Vs};
end




