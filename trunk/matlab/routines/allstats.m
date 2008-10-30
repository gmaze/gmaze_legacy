% STATM Compute statistics from 2 series
%
% STATM = allstats(Cr,Cf)
%
% Compute statistics from 2 series.
% Cr is considered as the reference 
% 
% STATM(1,:) => Mean
% STATM(2,:) => Standard Deviation (scale by N)
% STATM(3,:) => Root Mean Square Difference
% STATM(4,:) => Correlation
%
% Created by Guillaume Maze on 2008-10-28.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function STATM = allstats(varargin)
	
Cr = varargin{1};
Cf = varargin{2};

N = length(Cr);

%%% STD:
st(1) = sqrt(sum(  (Cr-mean(Cr) ).^2)  / N );
st(2) = sqrt(sum(  (Cf-mean(Cf) ).^2)  / N );

%%% MEAN:
me(1) = mean(Cr);
me(2) = mean(Cf);

%%% RMSD:
rms(1) = sqrt(sum(  ( ( Cr-mean(Cr) )-( Cr-mean(Cr) )).^2)  /N);
rms(2) = sqrt(sum(  ( ( Cf-mean(Cf) )-( Cr-mean(Cr) )).^2)  /N);

%%% CORRELATIONS:
co(1) = sum(  ( ( Cr-mean(Cr) ).*( Cr-mean(Cr) )))/N/st(1)/st(1);
co(2) = sum(  ( ( Cf-mean(Cf) ).*( Cr-mean(Cr) )))/N/st(2)/st(1);


%%% OUTPUT
STATM(1,:) = me;
STATM(2,:) = st;
STATM(3,:) = rms;
STATM(4,:) = co;
	
