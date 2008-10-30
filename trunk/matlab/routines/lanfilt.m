% LANFILT High, low, band pass filters based on Lanczos filter
%
% Y = LANFILT(X,fc_dw,fc_up,NJ,Filter)
% X(1,:)
% Filter= 1 : Low-pass (cutoff fc_up)
%         2 : High-pass (cutoff fc_dw)
%         3 : Band-pass (fc_dw<->fc_up)
% Rq: X is detrended
%
% Copyright (c) 2004 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function [XF] = lanfilt(X,Fc1,Fc2,NJ,FILTER)


X = detrend(X);
switch FILTER

case 1 % LOW PASS
      XF = lanczos(X',Fc2,NJ);

case 2 % HIGH PASS
      XF = X - lanczos(X',Fc1,NJ);

case 3 % BAND PASS
      XF = lanczos(X',Fc2,NJ);
      XF = XF - lanczos(XF,Fc1,NJ);

end %switch
XF = detrend(XF)';

