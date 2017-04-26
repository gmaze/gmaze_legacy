function varargout = minmax(varargin)
% minmax H1LINE
%
% [] = minmax([PAR,VAL]) HELP_TEXT_1ST_FORM
%
% Inputs:
%	dpth
% 	data
% Outputs:
%	max_depth
% 	max_data_value
% Eg:
%
% See Also: 
%
% Copyright (c) 2014, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2014-06-11 (G. Maze)

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
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%- Default parameters:
dz = -5;
sscale = NaN; % No smoothing by defaut
debug  = false;

%- Load user parameters:
if nargin ~= 0
    if mod(nargin,2) ~= 0
        error('Parameters must come in pairs: PAR,VAL');
    end% if
    for in = 1 : 2 : nargin
        eval(sprintf('%s = varargin{in+1};',varargin{in}));
    end% for in
    clear in
else
    error('You must provide parameters');
end% if

%- Pre-process the profile:
% Remove NaNs:
iz = find(~isnan(data));
dclean = data(iz);
zclean = dpth(iz);

%-- Interpolation on a regular grid only if dz is not NaN
if ~isnan(dz)
	zr = 0:dz:-5000; 
	nz = length(zr);		
	n2a = interp1(zclean,dclean,zr);
	iz1 = find(~isnan(n2a),1,'first');
	n2a(1:iz1) = n2a(iz1);
	iz1 = find(~isnan(n2a),1,'last');
	n2a(iz1:nz) = n2a(iz1);
else
	zr  = zclean;
	n2a = dclean;
	nz  = length(zr);
end% if 

%-- Smoothing only if sscale is not nan
if ~isnan(sscale) & ~isnan(dz)
	c  = n2a; 
	c([1 end]) = NaN; 
	c  = smoother1Ddiff(c',abs(fix(sscale/dz))); 
	n2 = c;
else
	n2 = n2a;
end% if 
n2(n2<0) = 0;

%- Diagnostic
done  = false;
guess = 1;
while done ~= true
	
	switch guess 
		case 1
			% Start from the largest N2 value, supposedly at MLD depth
			iz0  = find(n2==nanmax(n2),1,'first'); 
			guesslabel = 'Start from the largest N2 value (dashed blue)';
		case 2
			% Start from the surface		
			iz0 = 1; 
			guesslabel = 'Start from the first level of the profile (dashed blue)';	
		otherwise
			done = true;
	end% switch 
	
	f = zeros(1,nz)*NaN;
	g = zeros(1,nz)*NaN;

	for iz = iz0 : nz
		% Compute f(z), the depth of the N2 minimum from iz0 to iz : 
		[mi izmin] = nanmin(n2(iz0:iz));
		f(iz)  = zr(izmin+iz0-1);
		
		% Compute g(z), the depth of the N2 maximum from iz to nz :
		[ma izmax] = nanmax(n2(iz:nz));
		g(iz)  = zr(izmax+iz-1);
	end% for iz
	clear iz mi izmin ma izmax 

	% Levels where f(z) = z :
	izcteA = find(diff(f) == dz);
	
	% Levels where f(z) = cte : 
	izhomA = find(diff(f) == 0);

	% Levels where g(z) = z :	
	izcteB = find(diff(g) == dz);
	
	% Levels where g(z) = cte :	
	izhomB = find(diff(g) == 0);

	%- Post-process layers:
	try
		% levels delimiting layers where f(z) = cte	
		iz = find(diff(zr(izhomA))~=dz);
		if isempty(iz) % Only one layer
			iz = izhomA;
		end% if 		
		try
			iztoplayer = izhomA(1:iz(1));
		catch
			iztoplayer = izhomA(1:iz(1)-1);
		end
		zedges = zr(izhomA(iz));
		%
		[maxi izmaxi] = max(n2(iztoplayer));
		izmaxi = iztoplayer(izmaxi);
		zmaxi = zr(izmaxi);
		
	catch
		zmaxi = NaN;
		maxi = NaN;
	end%end try

	if ~isnan(zmaxi)
		% Ok, move on
		done = true;
	else
		guess = guess + 1;
	end% if 
	
end %while

%- Plot a figure if debug is true
if debug == 1
	ffland;iw=2;jw=2;ipl=0;
	suptitle(sprintf('Pycnocline depth : %0.2f m\n ',zmaxi));

	ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
	plot(n2,zr,'.-','color',[1 1 1]/2)
	plot(n2(iz0),zr(iz0),'s','markersize',12,'color',[1 1 1]/2)
	xlabel('data (N2)'); ylabel('dpth');
	
	p1 = plot(n2(izcteA),zr(izcteA),'r.');
	p2 = plot(n2(izhomA),zr(izhomA),'k.');
	
	set(gca,'xscale','log');
	set(gca,'yscale','log');
	hline(zr(iz0),'linestyle','--');
	hline(zmaxi,'color','r','linewidth',2);
	title(sprintf('Downward analysis of N2 minimum\n%s',guesslabel),'fontweight','bold');
	grid on, box on,set(gca,'LineWidth',0.1)
	legend([p1 p2],'min(N^2) = N^2(z)','min(N^2) = cte',4)

	ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
	plot(f,zr,'.-','color',[1 1 1]/2)
	plot(f(iz0),zr(iz0),'s','markersize',12,'color',[1 1 1]/2)
	xlabel('f(z), the depth of the N2 minimum from iz0 to iz'); ylabel('Depth');	
	p1 = plot(f(izcteA),zr(izcteA),'r.');
	p2 = plot(f(izhomA),zr(izhomA),'k.');
	set(gca,'xscale','log');
	set(gca,'yscale','log');
	hline(zr(iz0),'linestyle','--');
	hline(zmaxi,'color','r','linewidth',2);
	title(sprintf('Downward analysis of N2 minimum\n%s',guesslabel),'fontweight','bold');
	grid on, box on,set(gca,'LineWidth',0.1)
	legend([p1 p2],'min(N^2) = N^2(z)','min(N^2) = cte',4)


	ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
	plot(n2,zr,'.-','color',[1 1 1]/2)
	plot(n2(iz0),zr(iz0),'s','markersize',12,'color',[1 1 1]/2)
	xlabel('N2'); ylabel('Depth');

	p1=plot(n2(izcteB),zr(izcteB),'r.');
	p2=plot(n2(izhomB),zr(izhomB),'k.');
	
	set(gca,'xscale','log');
	set(gca,'yscale','log');
	hline(zr(iz0),'linestyle','--');
	hline(zmaxi,'color','r','linewidth',2);
	title(sprintf('Upward analysis of N2 maximum\n%s',guesslabel),'fontweight','bold');
	grid on, box on
	legend([p1 p2],'max(N^2) = N^2(z)','max(N^2) = cte',4)
	
	ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
	plot(g,zr,'.-','color',[1 1 1]/2)
	plot(g(iz0),zr(iz0),'s','markersize',12,'color',[1 1 1]/2)
	xlabel('g(z), the depth of the N2 maximum from iz to nz :'); ylabel('Depth');	
	p1 = plot(g(izcteB),zr(izcteB),'r.');
	p2 = plot(g(izhomB),zr(izhomB),'k.');
	set(gca,'xscale','log');
	set(gca,'yscale','log');
	hline(zr(iz0),'linestyle','--');
	hline(zmaxi,'color','r','linewidth',2);
	title(sprintf('Upward analysis of N2 maximum\n%s',guesslabel),'fontweight','bold');
	grid on, box on
	legend([p1 p2],'max(N^2) = N^2(z)','max(N^2) = cte',4)

	unify(gcf,[min(zr) 0]);
	
end% if 

%stophere

%- Outputs
varargout(1) = {zmaxi};
varargout(2) = {maxi};


end %functionminmax