% DS = subfct_getdS(LAT,LON)
% This function computes the 2D dS surface elements centered
% on LON,LAT
%

function varargout = subfct_getdS(Y,X);

ny = length(Y);
nx = length(X);

if nx == size(X,1)
  X = X';
end
if ny == size(Y,1)
  Y = Y';
end

%%% Compute the DY:
% Assuming Y is independant of ix:
d  = m_lldist([1 1]*X(1),Y);
dy = [d(1)/2  (d(2:length(d))+d(1:length(d)-1))/2 d(length(d))/2];
dy = meshgrid(dy,X)';

%%% Compute the DX:
clear d
for iy = 1 : ny
   d(:,iy) = m_lldist(X,Y([iy iy]));
end
dx = [d(1,:)/2 ;  ( d(2:size(d,1),:) + d(1:size(d,1)-1,:) )./2 ; d(size(d,1),:)/2];
dx = dx';

%% Compute the horizontal DS surface element:
ds = dx.*dy;

switch nargout
 case 1
  varargout(1) = {ds};
 case 2
  varargout(1) = {ds};
  varargout(2) = {dx};
 case 3
  varargout(1) = {ds};
  varargout(2) = {dx};
  varargout(3) = {dy};
end   