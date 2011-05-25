% SETCOLORMAPS Sets the colormap as the union of two at certain level. 
%
%   SETCOLORMAPS(MAPINF,MAPSUP,Z0) sets the colormap of the current figure 
%   with the colormap MAPINF from the bottom to Z0 and MAPSUP from Z0 to 
%   the top of the surface, where the first two entries are the names of 
%   the colormaps (strings). To get a reverse colormap put '-1' at the end
%   of his name. 
%   
%   SETCOLORMAPS(MAPINF,MAPSUP,[Z0 DZ]) each band of DZ high from the Z0 
%   level are colored with different color.
%
%   SETCOLORMAPS(MAPINF,MAPSUP,Z0,N), where N is integer, sets a colormap
%   with N different colors. Default N=256. It's ignored when DZ is used.
%
%   Note: the caxis are changed in order to split the colormap exactly at
%   Z0.
%
%   Example:
%      figure(1)
%      surf(peaks) 
%      setcolormaps('copper','summer-1',2.5)
%       shading interp, colorbar, axis tight, zlabel('Metros')
%       title('Union at 2.5 m')
% 
%      figure(2)
%      surf(peaks) 
%      setcolormaps('copper','summer-1',[2.5 0.5])
%       shading interp, colorbar, axis tight, zlabel('Metros')
%       title('Union at 2.5 m and different color for each 0.5 m band')
% 
%      figure(3)
%      surf(peaks) 
%      setcolormaps('copper','summer',2.5,10)
%       shading interp, colorbar, axis tight, zlabel('Metros')
%       title('Union at 2.5 m with 10 colors')
%  
%   See also COLORMAPEDITOR, COLORMAP, CAXIS

%   Written by
%   M.S. Carlos Adrián Vargas Aguilera
%   Physical Oceanography PhD candidate
%   CICESE 
%   Mexico, november 2006
% 
%   nubeobscura@hotmail.com

function setcolormaps(mapinf,mapsup,z0,varargin)

% Get colors limits:
c_lim = get(gca,'CLim');

% Check entries:
N = 256; % Default
if numel(z0) == 2
 n = ceil(abs(c_lim-z0(1))/z0(2));
 c_lim = z0(1) + n(:)'*z0(2).*[-1 1];
else
 if nargin == 4, N = varargin{1}; end
 c_lim = colors_limits(c_lim,z0,N);
 n = colors_number(c_lim,z0,N);
end

% Joins colormaps, checking if reversed:
mapainf = creates_colormap(mapinf,n(1));
mapasup = creates_colormap(mapsup,n(2));
mapa = [mapainf; mapasup];

% Sets the colormat and the colors limits:
colormap(mapa)
set(gca,'CLim',c_lim)

function c_lim = colors_limits(c_lim,c_int,N)
% Changes colors limits.
dc = linspace(c_lim(1),c_lim(2),N+1) - c_int;
[temp,imin] = min(abs(dc)); clear temp
c_lim = c_lim - dc(imin);

function n = colors_number(c_lim,c_int,N)
% Number of colors on each map.
dp = linspace(c_lim(1),c_lim(2),N+1);
n = [sum(dp<c_int) sum(dp>c_int)];

function mapa = creates_colormap(name,n_colors)
% Creates the colompap with the spcified number of colors, checking if 
% reversed: '-1'.
invierte = 0;
if strcmp(name(end-1:end),'-1')
 name = name(1:end-2);
 invierte = 1;
end
mapa = eval([ name '(n_colors)']);
if invierte, mapa = flipud(mapa); end


% Carlos Adrián Vargas Aguilera. nubeobscura@hotmail.com