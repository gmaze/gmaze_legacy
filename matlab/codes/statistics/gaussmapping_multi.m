% gaussmapping_multi Map irregular data on the Earth sphere in 3D on a regular grid
%
% vc = gaussmapping_multi(x,y,z,v,xc,yc,zc,sigma_hor,sigma_vert)
%
% Adapted from gaussmapping.m to the use of multivariate gaussians (G. Maze)
%
% Created: 2015-01-29.
% Copyright (c) 2015, Charlene Feucher (Ifremer, Laboratoire de Physique des Oceans).
% All rights reserved.
% cfeucher@ifremer.fr
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list
% 	of conditions and the following disclaimer in the documentation and/or other materials
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used
%	to endorse or promote products derived from this software without specific prior
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Charlene Feucher ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Charlene Feucher BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = gaussmapping_multi(x,y,z,v,xc,yc,zc,sigma1,sigma2,varargin)

%- PARAMETERS:
% Display a waiting bar ?
showwaitbar = false;

% Troncate the weight vector to weights higher than 'tronclevel' ?
tronc      = true;
tronclevel = 1;
nmin = 10; % Minimum nb of profiles:
% Troncated filling values:
FillVall = NaN;

% Topo:
topo = false;
topoval = 2;

% Debug:
debug = false;

%- LOAD USER PARAMETERS:
if nargin - 9 ~= 0
    if mod(nargin - 9,2) ~= 0
        error('Arguments must come in pairs: ARG,VAL')
    end% if
    for in = 1 : 2 : nargin - 9
        eval(sprintf('%s = varargin{in+1};',varargin{in}));
    end% for in
end% if

%- Inputs
x = x(:);
y = y(:);
v = v;

if debug
    ffland; iw=1;jw=2;ipl=0;
    if topo,jw=3;end% if
end% if

%- Compute f/h
if topo
    fhr = zeros(length(x),1).*NaN;
    fc  = zeros(length(x),1).*NaN;
    zb  = zeros(length(x),1).*NaN;
    ii = 0;
    dx = 0.1; dy = 0.1;
    for ii = 1 : length(x)
        fc(ii) = sw_f(y(ii)); % Coriolis
        zb(ii) = min([eps onetopo2(x(ii),y(ii))]); % Topography
    end% for ix
    fhr = fc./zb;
end% if

%- Map irregular data:
F = zeros(length(xc),length(yc),length(zc)).*NaN;
ii = 0;
for ix = 1 : length(xc)
    for iy = 1 : length(yc)
        
        d1 = distsphere(xc(ix),yc(iy),x,y); % horizontal
        
        for iz = 1:length(zc)
            
            ii = ii + 1;
            
            if showwaitbar
                nojvmwaitbar(length(zc)*length(xc)*length(yc),ii);
            end% if
            
            d2 = abs(zc(iz) - z); % vertical
            
            [D1,D2] = meshgrid(d1,d2);
            
            if tronc
                
                inellipse = (D1.^2)./(tronclevel*sqrt(sigma1)).^2 + (D2.^2)./(tronclevel*sqrt(sigma2)).^2; % are the points within the ellipse
                
                [iwe1 iwe2] = find(inellipse <= 1);
                
                if ~isempty(iwe1)
                    
                    D1 = D1(iwe1,iwe2);
                    D2 = D2(iwe1,iwe2);
                    
                    w = multivariate_gauss([D1(:) D2(:)],[sigma1 0;0 sigma2],[0 0])'; % Weights are from a gaussian distribution of amplitude 1
                    w = reshape(w,size(D2,2),size(D2,1));
                    
                    vw = v(iwe2,iwe1)';
                    
                    if length(iwe1) >= nmin
                        F(ix,iy,iz) = wmean(w,vw); % weighted mean
                        % F(ix,iy,iz) = nansum(nansum(w(iwe1,iwe2).*v(iwe1,iwe2)))./nansum(nansum(w(iwe1,iwe2)));
                    else
                        F(ix,iy,iz) = FillVall;
                    end% if
                    
                end
                
            end% if tronc
            
            if ~tronc
                
                w = multivariate_gauss([D1(:) D2(:)],[sigma1 0;0 sigma2],[0 0])'; % Weights are from a gaussian distribution of amplitude 1
                w = reshape(w,length(d2),length(d1));
                
                F(ix,iy,iz) = wmean(w,v); % weighted mean
                
            end
            
            
            % Take care of the topography
            % Remove points that differ by more than topoval % in the f/h value of the cell
            
            if topo
                fhr0 = sw_f(yc(iy))./min([eps onetopo2(xc(ix),yc(iy))]);
                %			w(find(abs(fhr-fhr0)*100/fhr0>topoval)) = NaN;
                FH(ix,iy) = fhr0;
            end% if
            
            
            
            if debug
                clf; ipl=0; dd = 4; sid = 50;
                ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
                sc=scatter(x,y,sid,d,'.'); caxis([0 5]); set(sc,'markerfacecolor','flat');
                title('Distance'); colorbar
                vline(xc(ix));hline(yc(iy));
                axis([[-1 1]*dd*sigma+xc(ix), [-1 1]*dd*sigma+yc(iy)])
                
                if topo
                    ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
                    sc=scatter(x,y,sid,abs(fhr-fhr0)*100./abs(fhr0),'.'); caxis([0 10]);
                    set(sc,'markerfacecolor','flat');
                    title('f/h'); colorbar
                    vline(xc(ix));hline(yc(iy));
                    axis([[-1 1]*dd*sigma+xc(ix), [-1 1]*dd*sigma+yc(iy)])
                end% if
                
                ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
                sc=scatter(x,y,sid,w,'.');  set(sc,'markerfacecolor','flat');
                title('Weight'); colorbar
                vline(xc(ix));hline(yc(iy));
                axis([[-1 1]*dd*sigma+xc(ix), [-1 1]*dd*sigma+yc(iy)])
                
                pause
            end% if
            
        end% for iz
    end% for iy
end% for ix

%- Output
varargout(1) = {F};
if exist('FH','var')
    varargout(2) = {FH};
end% if

end %functiongaussmap


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function arc = distsphere(lon1,lat1,lon2,lat2)

% angles are in degrees

lon1 = lon1*pi/180;
lon2 = lon2*pi/180;
lat1 = lat1*pi/180;
lat2 = lat2*pi/180;

dlon = lon1-lon2;
dlat = lat1-lat2;

z = sin(dlat*.5).^2 + cos(lat1).*cos(lat2).*sin(dlon*.5).^2.;
arc = 2*asin( sqrt( z ) );
arc = arc*180/pi;

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = multivariate_gauss(x,sigma,x0,a)
% equation for multivariate gaussian

[n, d] = size(x);

[j, k] = size(sigma);

% Check that the covariance matrix is the correct dimension
if ((j ~= d) | (k ~=d))
    error('Dimension of the covariance matrix and data should match');
end

invcov = inv(sigma);
x0 = reshape(x0, 1, d);    % Ensure that mu is a row vector

x = x - ones(n, 1)*x0;
fact = sum(((x*invcov).*x), 2); 

y = exp(-0.5*fact);

y = y./sqrt((2*pi)^d*det(sigma));

end

