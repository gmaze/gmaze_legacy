% select_1transect Extract only one transect from a campaign
%
% [] = select_1transect(x,y,x0,y0,[dd])
% 
% From a serie of profiles, we select only those
% forming a specific section within a multiple
% transects campaign.
%
%
% Created: 2009-06-15.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = select_1transect(varargin)

%%%%%%%%%%%%%%%%%%%%
x = varargin{1};
y = varargin{2};
x0 = varargin{3};
y0 = varargin{4};
if nargin >= 5
	dmin = varargin{5};
else
	dmin = 100;
end

if nargin == 6
	dphimin = varargin{6};
else
	dphimin = 45;
end

ipt = 0;

if nargout == 0
	doplot = 1;
else
	doplot = 0;
end

%%%%%%%%%%%%%%%%%%%%
if doplot
	figure;clf; hold on
	m_proj('equid','lon',[nanmin(x) nanmax(x)] + [-1 1],'lat',[nanmin(y) nanmax(y)] + [-1 1]);
	pp = m_plot(x,y,'+','markersize',10);
	m_coast('patch',[1 1 1]*.6);
	m_grid('xtick',[0:1:360],'ytick',[-90:1:90]);
	m_elev('contour',[-4:-1]*1e3,'edgecolor',[1 1 1]*.5);
	p = m_plot(x0,y0,'ro'); 
	set(p,'markersize',10);
end

%%%%%%%%%%%%%%%%%%%% Compute distances from the starting point and find the 1st point of the section:
dist = distance(x,y,x0,y0);
%[dist idist] = sort(dist);x=x(idist);y=y(idist);

[a i0] = min(dist); clear a; 
x0 = x(i0); y0 = y(i0);
ipt = ipt + 1; iplist(ipt,1) = x(i0); iplist(ipt,2) = y(i0);
dist = distance(x,y,x0,y0);
if doplot
	p = m_plot(x0,y0,'ko'); set(p,'markersize',10);
	m_range_ring(x0,y0,dmin,'color','k');
end

%%%%%%%%%%%%%%%%%%%% Now we go from dmin to this point
done = 0; X = x; Y = y;
a = X(find(X~=X(i0) & Y~=Y(i0)));
b = Y(find(X~=X(i0) & Y~=Y(i0)));
X = a; clear a
Y = b; clear b
whydone = 0;


while done ~= 1
	if length(X) ~= length(Y)
		if whydone==1;disp('X and Y must have same length');end
		done = 1;
	elseif isempty(X)	
		if whydone==1;disp('X empty');end
		done = 1;
	else
		dist = distance(X,Y,x0,y0); 
		[d id] = min(dist/1e3);
		if ~isempty(d)
			if ipt > 1
				phi0 = atan2([iplist(ipt,2)-iplist(ipt-1,2)],[iplist(ipt,1) - iplist(ipt-1,1)])*180/pi;
				phi1 = atan2((Y(id) - iplist(ipt,2)), (X(id) - iplist(ipt,1)))*180/pi;				
				dphi = phi1-phi0;
			else
				dphi = 0;
			end
			%disp([d abs(dphi)])
			% 
			
			if d<=dmin & abs(dphi)<=dphimin				
				ipt = ipt + 1; iplist(ipt,1) = X(id); iplist(ipt,2) = Y(id);
				x0 = X(id); y0 = Y(id);
				if doplot
					p = m_plot(x0,y0,'rp'); set(p,'markersize',8);drawnow
				end
				a = X(find(X~=X(id) & Y~=Y(id)));
				b = Y(find(X~=X(id) & Y~=Y(id)));
				X = a; clear a
				Y = b; clear b
			else
				if d>dmin
					%[d dmin]
					if whydone==1;disp('d>dmin');end
				elseif abs(dphi)>dphimin
					if whydone==1;disp('dphi>dphmin')	;end	
				else
					if whydone==1;disp('error');end
				end
				if doplot
					m_range_ring(x0,y0,dmin,'color','k');
				end
				done = 1;				
			end
		else
			if whydone==1;disp('d empty');end
			done = 1;
		end
	end
end

%%%%%%%%%%%%%%%%%%%% 
clear ii
for ip = 1 : size(iplist,1)
	ii(ip) = find(x==iplist(ip,1) & y==iplist(ip,2));
end%for ip


if nargout == 1
	varargout(1) = {ii};
end
	
end %function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function dd = distance(x,y,x0,y0);
	for ipt = 1 : length(x)
		dd(ipt) = m_lldist([x0 x(ipt)],[y0 y(ipt)]);
	end%for
end







