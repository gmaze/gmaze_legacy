% date = dtecco2(X,FORM)
%
% If: 
% FORM = 0, translate the stepnum X into a date string (yyyymmddHHMM)
% FORM = 1, translate the date string X (yyyymmddHHMM) into a stepnum
%
% 06/08/29
% gmaze@mit.edu
%

function varargout = dtecco2(varargin)

% Test inputs:
if nargin ~= 2
  help dtecco2.m
  error('dtecco2.m : Wrong number of parameters');
  return
end %if

% Recup inputs:
X = varargin{1};
FORM = varargin{2};

% New tests:
if FORM~=0 & FORM~=1
   help dtecco2.m
   error('dtecco2.m : Second argument must be 0 or 1');
   return
elseif FORM == 0 & ~isnumeric(X)
   help dtecco2.m
   error('dtecco2.m : if 2nd arg is 0, 1st arg must be numeric');
   return
elseif FORM == 1 & isnumeric(X)
   help dtecco2.m
   error('dtecco2.m : if 2nd arg is 1, 1st arg must be a string');
   return
end


% Let's go:
switch FORM
  
 case 0
  ID = datestr(datenum(1992,1,1)+X*300/60/60/24,'yyyymmddHHMM');
  varargout(1) = {ID};
  
 case 1
  ID = 60*60*24/300*( datenum(X,'yyyymmddHHMM') - datenum(1992,1,1) );
  varargout(1) = {ID};
  
  
end %switch
