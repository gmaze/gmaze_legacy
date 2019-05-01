function [gtime]=greg_0h(jourjul)
% GREGORIAN  Converts Julian day numbers to corresponding Gregorian calendar dates
%       Formally, Julian days start and end at noon.
%       In this convention, Julian day 2440000 begins at 
%       00 hours, May 23, 1968.
%
% ==========================================
%       greg_0h.m = contraire de jul_0h.m
% ==========================================
%
%     Usage: [gtime]=greg_0h(jourjul) 
%
%        jourjul... input decimal Julian day number
%
%        gtime is a six component Gregorian time vector
%          i.e.   gtime=[yyyy mo da hr mi sec]
%                 gtime=[1989 12  6  7 23 23.356]
% 
%        yr........ year (e.g., 1979)
%        mo........ month (1-12)
%        d........ corresponding Gregorian day (1-31)
%        h........ decimal hours
%

% Revised T.Terre

%
% Ajout TT pour pb de conversion 07 00 00 == retourne en 06 59 60 ?
% Ca permet d'avoir la date juste a la dizaine de us pres.
% 10/05/2001
%
	fac = 10^9;
	jourjul= round(fac*jourjul+0.5)/fac;

% Fin ajout TT
 
    secs=rem(jourjul,1)*24*3600;

%
% Ajout TT pour pb de conversion 07 00 00 == retourne en 06 59 60 ?
% Ca permet d'avoir la date juste a la dizaine de us pres.
% 10/05/2001
%
	secs = round(fac*secs + 0.5)/fac;

% Fin ajout TT

      j = floor(jourjul) - 1721119;
      in = 4*j -1;
      y = floor(in/146097);
      j = in - 146097*y;
      in = floor(j/4);
      in = 4*in +3;
      j = floor(in/1461);
      d = floor(((in - 1461*j) +4)/4);
      in = 5*d -3;
      m = floor(in/153);
      d = floor(((in - 153*m) +5)/5);
      y = y*100 +j;
      mo=m-9;
      yr=y+1;
      i=(m<10);
      mo(i)=m(i)+3;
      yr(i)=y(i);

      hour=floor(secs/3600);
      min=floor(rem(secs,3600)/60);
      sec=rem(secs,60);

      gtime=[yr(:) mo(:) d(:) hour(:) min(:) sec(:)];
