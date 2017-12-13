% GETCROSSCOR Compute a lagged cross-correlation 
%
% [CR LAGS CONFIDENCE95 P] = GETCROSSCOR(X1,X2,T)
% 
% Compute the cross-correlation between X1 and X2
% with lags from -T to T. Note that T is in timestep.
%
% What is confident ? Use the p-value
% 	CRconf = CR;
%	CRconf(find(P>0.05)) = ones(1,length(find(P>0.05))).*NaN;
%	plot(LAGS,CR,LAGS,CRconf,LAGS,diff(CONFIDENCE95,[],2)/2,LAGS,-diff(CONFIDENCE95,[],2)/2);
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

function varargout=getcrosscor(X1,X2,T)

    N = length(X1);

    for ilag=1:2*T+1
        N = length(X1);
        lag = ilag - 1 - T;
        tps(ilag) = lag;
        pivot = fix(T)+1;
        if lag<0
           Xlag = X2(1+abs(lag):N);
           Xori = X1(1:N-abs(lag));
        else
           Xlag = X2(1:N-lag);
           Xori = X1(1+lag:N);
        end
        [COREL,PROB,RLO,RUP] = corrcoef(Xori,Xlag);
        Y(ilag) = COREL(2);
        CONF95INT(ilag,:) = [RLO(2) RUP(2)];
        P(ilag) = PROB(2);
    end


LAGS=tps;
CR=Y;

switch nargout
  case 1
     varargout(1)={CR};
  case 2
     varargout(1)={CR};
     varargout(2)={LAGS};
  case 3
     varargout(1)={CR};
     varargout(2)={LAGS};
     varargout(3)={CONF95INT};
  case 4
     varargout(1)={CR};
     varargout(2)={LAGS};
     varargout(3)={CONF95INT};
     varargout(4)={P};
end

