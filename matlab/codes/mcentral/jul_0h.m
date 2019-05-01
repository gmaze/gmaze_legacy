function [j]=jul_0h(y,m,d,h)
% JULIAN  Converts Gregorian calendar dates to corresponding
%      Julian day numbers.  Although the formal definition
%      holds that Julian days start and end at noon, here
%      Julian days start and end at midnight.
%
%    In this convention, Julian day 2440000 began at 0000 hours, May 23, 1968.
%
%
%     Usage: [j]=jul_0h(y,m,d,h)  or  [j]=jul_0h([y m d hour min sec])
%     ************************************************************
%
%        d.... day (1-31) component of Gregorian date
%        m.... month (1-12) component
%        y.... year (e.g., 1979) component
%        j.... decimal Julian day number
%        h.... decimal hours (assumed 0 if absent)
%
%     ************************************************************
%     recoded for MATLAB  by Rich Signell, 5-15-91
%

% Revised T.Terre 10/05/2001

      if nargin==3,
        h=0.;
      elseif nargin==1,
        h=y(:,4) + (y(:,5) + y(:,6)/60)/60;
        d=y(:,3);
        m=y(:,2);
        y=y(:,1);
      end
      mo=m+9;
      yr=y-1;
      i=(m>2);
      mo(i)=m(i)-3;
      yr(i)=y(i); 
      c = floor(yr/100);
      yr = yr - c*100;
      j = floor((146097*c)/4) + floor((1461*yr)/4) + ...
           floor((153*mo +2)/5) +d +1721119;

%     If you want julian days to start and end at noon, 
%     replace the following line with:
%     j=j+(h-12)/24;

%
% Ajout TT pour pb de conversion 07 00 00 == retourne en 06 59 60 ?
% Ca permet d'avoir la date juste a la dizaine de us pres.
% 10/05/2001
%
	fac = 10^9; 
	dh = round(fac*h/24+0.5)/fac;

% Fin ajout TT

      j=j+dh;
