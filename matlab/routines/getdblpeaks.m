% getdblpeaks Find indices corresponding to a common peak in two series
%
% ipeaks = getdblpeaks(C1,C2,N,Z,dZpeaks,dZseries)
% 
% We identify peaks of order N(1) in C1 and N(2) in C2 and then
% try to find common peaks.
%
% Inputs:
% 	C1 and C2 are two 1xn series.
%	N = [n1 n2] specify the order of each peaks. See: getpeaks
%	Z is the common axis of C1 and C2.
%	dZpeaks is the maximum distance between peaks of each series.
%		(ie, larger than dZpeaks they are merged)
%	dZseries is the minimum distance between peaks in both series.
%		(ie, larger than dZseries they are rejected)
%
% Output:
%	ipeaks is the list of indices among Z  of double peaks.
%
% Example:
%	todo !
%
% See also:
%	getpeaks
%
% Created: 2009-08-31.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = getdblpeaks(varargin)

c1 = varargin{1};
c2 = varargin{2};
N  = varargin{3};
z  = varargin{4};
l  = varargin{5}; if length(l)==1, l(2) = l(1); end
dz = varargin{6};
dbg = 0; % plot stuff
dblpeak = NaN; % Default output
ip1o = NaN;
ip2o = NaN;

% C1 peaks:
ip1o = getpeaks(c1,N(1));
if ~isnan(ip1o)
	% Not to close:		
	ip1 = filter_d(ip1o,z,l(1));

	% C2 peaks:
	ip2o = getpeaks(c2,N(2));
	if ~isnan(ip2o)
		% Not to close:		
		%ip2 = filter_d(ip2o,z,l(2));
		ip2 = ip2o;

		% Find common peaks:
		ilev = 0;
		if length(ip1)>=1 & ~isnan(ip1(1)) & length(ip2)>=1 & ~isnan(ip2(1))
			for ii1 = 1 : length(ip1)
				zp = abs(z(ip1(ii1)));
				z2 = abs(z(ip2));
				if ~isempty(find(z2>=zp-dz & z2<=zp+dz)) % is a peak from c2 corresponding to a peak from c1 ?
					ilev = ilev + 1;
%					dblpeak(ilev) = ip1(ii1);
					dblpeak(ilev) = fix(nanmedian([ip1(ii1) ip2(find(z2>=zp-dz & z2<=zp+dz))]));
				end
			end
		end		
		
		if dbg
			figure
			iw=1;jw=3;
			subplot(iw,jw,1);hold on
				plot(c1,c2,'k*','markersize',6);grid on,box on,axis tight
				if ~isnan(dblpeak),plot(c1(dblpeak),c2(dblpeak),'rs','markersize',20);end
				xlabel('c1');ylabel('c2');
			subplot(iw,jw,2);hold on
				plot(c1,z);grid on,box on
				xlabel('c1');ylabel('z');
				plot(c1(ip1o),z(ip1o),'k*');				
				if ~isnan(dblpeak),
					for ii=1:length(dblpeak)
						line(get(gca,'xlim'),[1 1]*z(dblpeak(ii)));
					end
					plot(c1(dblpeak),z(dblpeak),'rs');
				end
			subplot(iw,jw,3);hold on
				plot(c2,z);grid on,box on
				xlabel('c2');ylabel('z');
				plot(c2(ip2o),z(ip2o),'k*');
				if ~isnan(dblpeak),
					for ii=1:length(dblpeak)
						line(get(gca,'xlim'),[1 1]*z(dblpeak(ii)));
					end
					plot(c2(dblpeak),z(dblpeak),'rs');
				end
		end

	end%if
end%if

switch nargout
	case 1, 
		varargout(1) = {dblpeak};
	case 2
		varargout(1) = {dblpeak};
		varargout(2) = {ip1o};
	case 3
		varargout(1) = {dblpeak};
		varargout(2) = {ip1o};
		varargout(3) = {ip2o};
end

end %function


function ip1 = filter_d(ip1,z,l)
	
% Remove peaks indices to close from each others:
	dz  = abs(diff(z(ip1))); % Distance between peaks
	idz = find(dz<l);
	if ~isempty(idz)
		for ii = 1 : length(idz)
			m = fix(mean(ip1([idz(ii) idz(ii)+1])));
			ip1(idz(ii)) = m;
			ip1(idz(ii)+1) = NaN;
		end%for
	end
ip1 = ip1(~isnan(ip1));
		
end %function
