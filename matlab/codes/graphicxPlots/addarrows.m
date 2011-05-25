% addarrows Add arrows along a contour handle
%
% [AR TX TY] = addarrows(H,[OPTIONS_PAIRS])
% 
% Add arrows along a contour handle H.
%
% Options:
%	arrowgap    = 10; % Nb of points between arrows
%	arrowangle  = 10; % Arrow angle
%	arrowlength = 1;  % Arrow length
%	arrowsharpness = 1; % How sharp is the arrow ? (1 for a triangle)
%
% Outputs:
%	AR: Patch handle for each arrows
%
% See also:
%	patcharrow
%
% Created: 2010-08-25.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function [AR TX TY] = addarrows(varargin)

%- Default parameters:
arrowgap    = 10; % Nb of points between arrows
arrowangle  = 10; % Arrow angle
arrowlength = 1;  % Arrow length
arrowsharpness = 1; % How sharp is the arrow ? (1 for a triangle)

%- Load arguments:
switch nargin
	case 0 %-- Load demo fields
		iY = [90 160]; iX = [270 360]; % Classic North Atlantic
		load('LSmask_MOA','LSmask','LONmask','LATmask');
		LSmask = LSmask(iY(1):iY(2),iX(1):iX(2));
		lon = LONmask(iX(1):iX(2)); clear LONmask
		lat = LATmask(iY(1):iY(2)); clear LATmask
		SSH = load_climOCCA('SSH');
		SSH = SSH(iY(1):iY(2),iX(1):iX(2));
		clear iX iY
		figure;hold on
		contourf(lon,lat,SSH,[-2:.1:2]);
		[cs,h] = contour(lon,lat,SSH,[1 1]*-0.2);

	otherwise
		h = varargin{1};
		for in = 2 : 2 : nargin
			par = varargin{in};
			val = varargin{in+1};
			eval(sprintf('%s = val;',par));
		end%for in
		
end%if


%- Load marker polygon in the initial position:
%[px py] = getatriangle(gam,d); % A simple triangle
%[px py] = getatrianglefliplr(gam,d); % A simple triangle
[px py] = getanarrow(arrowangle,arrowlength,arrowsharpness); % 

%- Loop over contours:
try
	contourtype = get(h(1),'type');
catch	
	contourtype = 'double';
end
switch contourtype
	case 'patch'
		for icont = 1 : length(h)		
			lx  = get(h(icont),'xdata');
			ly  = get(h(icont),'ydata');
			[tx ty] = addarrowsto1contour(lx,ly,px,py,arrowgap);
			if exist('TX','var')
				TX = [TX tx];
				TY = [TY ty];
				UD = [UD ones(1,size(tx,2))*get(h(icont),'userdata')];
			else
				TX = tx;
				TY = ty;
				UD = ones(1,size(tx,2))*get(h(icont),'userdata');
			end
		end%for icont
	
	case 'hggroup'
		ch = get(h,'children');
		for icont = 1 : length(ch)		
			lx  = get(ch(icont),'xdata');
			ly  = get(ch(icont),'ydata');
			[tx ty] = addarrowsto1contour(lx,ly,px,py,arrowgap);
			if exist('TX','var')
				TX = [TX tx];
				TY = [TY ty];
				UD = [UD ones(1,size(tx,2))*get(ch(icont),'userdata')];
			else
				TX = tx;
				TY = ty;
				UD = ones(1,size(tx,2))*get(ch(icont),'userdata');
			end
		end%for icont
		
	case 'double'
		lx = h(1,:);
		ly = h(2,:);
		[TX TY] = addarrowsto1contour(lx,ly,px,py,arrowgap);
		UD = ones(1,size(TX,2));
end%switch

%- Plot arrows as patchs:
AR = patch(TX,TY,'b');

%-- Color arrows like contours:
set(AR,'cdata',UD,'facecolor','flat','edgecolor','none');


	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tx ty] = addarrowsto1contour(lx,ly,px,py,dpt);
	
ii = 0;

len = length(px); % Nb of points in the marker (arrow)
L = length(lx);
if L < 3
	tx(1:len,1) = NaN;
	ty(1:len,1) = NaN;
	return;
end

for ipt = 2 : dpt : length(lx)-1
	try 
		% Slope between points:
		if (lx(ipt+1) - lx(ipt-1)) ~= 0
			slope = (ly(ipt+1) - ly(ipt-1)) / (lx(ipt+1) - lx(ipt-1));
		else
			slope = 1e10;
		end
	
		if lx(ipt+1) >= lx(ipt-1)
			[PX PY] = rotatepolygon(px,py,atand(-slope));
		else
			[PX PY] = rotatepolygon(px,py,180+atand(-slope));
		end		
		ii = ii + 1;
		
		if exist('tx','var')
%			a=NaN;%a = patch(PX+lx(ipt),PY+ly(ipt),'b');
%			AR = [AR a];
			tx(:,ii) = PX+lx(ipt);
			ty(:,ii) = PY+ly(ipt);
		else
%			AR = NaN;%patch(PX+lx(ipt),PY+ly(ipt),'b');
			tx(:,ii) = PX+lx(ipt);
			ty(:,ii) = PY+ly(ipt);
		end
		%set(AR(ii),'edgecolor','none','facecolor','k');
	catch
		if exist('tx','var')
			ii = ii + 1;			
%			AR = [AR NaN];
			tx(1:4,1) = NaN;
			ty(1:4,1) = NaN;
		end
	end
end%for ipt
if ~exist('tx','var')
%	AR = NaN;
	tx(1:4,1) = NaN;
	ty(1:4,1) = NaN;
end
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [px py] = getatriangle(gam,d);
	
gam = gam*pi/180;	
ii = 0;

% Start from the origin:	
ii = ii + 1;
px(ii) = 0;
py(ii) = 0;
	
% Upper left point:
ii = ii + 1;
px(ii) = -d;
py(ii) =  d*tan(gam);

% Lower left point:
ii = ii + 1;
px(ii) = -d;
py(ii) = -d*tan(gam);	

% Back to origin:
ii = ii + 1;
px(ii) = px(1);
py(ii) = py(1);

% Center the triangle:
px = px + d/2;
		
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [px py] = getatrianglefliplr(gam,d);
	
gam = gam*pi/180;	
ii = 0;

% Start from the origin:	
ii = ii + 1;
px(ii) = 0;
py(ii) = 0;
	
% Upper right point:
ii = ii + 1;
px(ii) =  d;
py(ii) =  d*tan(gam);

% Lower right point:
ii = ii + 1;
px(ii) =  d;
py(ii) = -d*tan(gam);	

% Back to origin:
ii = ii + 1;
px(ii) = px(1);
py(ii) = py(1);

% Center the triangle:
px = px - d/2;
		
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [px py] = getanarrow(gam,d,n);
	
gam = gam*pi/180;
ii = 0;
N = 20;

% Start from the origin:	
ii = ii + 1;
px(ii) = 0;
py(ii) = 0;
	
% Upper Branch of the arrow:
X = linspace(px(1),-d,N);
Y = linspace(py(1),d*tan(gam),N);
px = [px X];
py = [py Y.^n./xtrm(Y.^n)*d*tan(gam)];

% Lower Branch
px = [px fliplr(X)];
py = [py fliplr(-Y.^n./xtrm(Y.^n)*d*tan(gam))];

% Center the arrow:
px = px + d/2;

end%function






