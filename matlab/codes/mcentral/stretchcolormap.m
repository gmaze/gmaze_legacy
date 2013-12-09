function cm2=stretchcolormap(coef);
% STRETCHCOLOR stretch the colormap
%    cm2=stretchcolormap(coef) returns the colormap stretch with coef. 
%    coef is the exponent applied to a linear ramp. coef=1 returns the
%    colormap unchanged. coef>1 returns a colormap with more low values,
%    coef<1 returns a colormap with more high values. Typical choice is
%    coef=3 or coef=1/3.
%
%    This function is inspired from the 'linear', 'low', 'high' button of
%    ncview
if nargin==0
    coef=3;
end
cm=colormap;
nc=size(cm,1); % nb of colors

x=linspace(0,1,nc); % linear ramp
y=x.^coef; % stretching function

for k=1:3
  cm2(:,k)=interp1(x,cm(:,k),y,'pchip');
end

if nargout==0
    colormap(cm2);
end