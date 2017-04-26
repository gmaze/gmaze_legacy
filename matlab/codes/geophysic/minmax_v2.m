function varargout = minmax_v2(varargin)
% minmax H1LINE
%
% [] = minmax_v2([PAR,VAL]) HELP_TEXT_1ST_FORM
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
dz = 5;
sscale = 50;
debug = false;

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
zr = 0:-abs(dz):-5000; 
nz = length(zr);

iz = find(~isnan(data));
dclean = data(iz);
zclean = dpth(iz);
n2a = interp1(zclean,dclean,zr);

izOKa = find(~isnan(n2a),1,'first');
n2a(1:izOKa) = n2a(izOKa);

izOKb = find(~isnan(n2a),1,'last');
n2a(izOKb:nz) = n2a(izOKb);

if 1
	% Smoothing (method 1)
	c  = n2a; c([1 end]) = NaN; c = smoother1Ddiff(c',abs(fix(sscale/dz))); n2 = c;
else
	% Smoothing (method 2)
	n2 = myrunmean(n2a,abs(fix(sscale/dz)),0,2);
	izOKa = find(~isnan(n2),1,'first');
	n2(1:izOKa) = 0;
	izOKb = find(~isnan(n2),1,'last');
	n2(izOKb:nz) = n2(izOKb);
end% if 

% Remove negative values
n2(n2<0) = 0;

%- Diagnostic

% init:
iz0 = 1;
f_cur_iz = iz0; f_cur = zr(f_cur_iz); 
g_cur_iz = iz0; g_cur = zr(g_cur_iz); 
floc_cur_iz = iz0; floc_cur = zr(floc_cur_iz);
gloc_cur_iz = iz0; gloc_cur = zr(gloc_cur_iz);

minlist = []; imin = 0;
maxlist = []; imax = 0;
f  = zeros(1,nz)*NaN;
g  = zeros(1,nz)*NaN;
fc = zeros(1,nz)*NaN;
gc = zeros(1,nz)*NaN;

if debug
	figure;hold on
	plot(n2,zr,'.-','color',[1 1 1]/2,'markersize',4);
	plot(n2(floc_cur_iz),floc_cur,'b*','markersize',12);
	plot(n2(gloc_cur_iz),gloc_cur,'k*','markersize',12)
	grid on,box on,ylabel('Depth (m)');xlabel('profile data');
	set(gca,'xlim',[0 max(get(gca,'xlim'))]);
	set(gca,'ylim',[min(get(gca,'ylim')) 0]);
	hline(zr(izOKa),'linestyle','--','color','k')
	hline(zr(izOKb),'linestyle','--','color','k')
%	set(gca,'xscale','log','yscale','log');
	%ylim([-2000 0]);
end% if 

for iz = iz0+1 : nz-1

	% Compute the depth of the N2 minimum from iz0 to iz : 
	[mi izmin] = nanmin(n2(iz0:iz));
	f_new = zr(izmin+iz0-1);
	
	% Compute the depth of the N2 maximum from iz0 to iz :
	[ma izmax] = nanmax(n2(iz0:iz));
	g_new = zr(izmax+iz0-1);
	
	if f_new == f_cur
%		plot(n2(f_cur_iz),f_cur,'bd','markersize',12)
	else
		f_cur = f_new;		
		f_cur_iz = find(zr==f_cur,1);
	end% if 
	
	if g_new == g_cur
%		plot(n2(g_cur_iz),g_cur,'kv','markersize',12)
	else
		g_cur = g_new;		
		g_cur_iz = find(zr==g_cur,1);
	end% if 

	% Compute the depth of the N2 minimum from current N2 maximum to iz :
	[mi izmin] = nanmin(n2(g_cur_iz:iz));
	floc_new = zr(izmin+g_cur_iz-1);	
	
	if floc_new == floc_cur
		imin = imin + 1;
		minlist(imin) = floc_cur;
		if debug
			plot(n2(floc_cur_iz),floc_cur,'b*','markersize',8)
		end% if 
	else
		floc_cur = floc_new;		
		floc_cur_iz = find(zr==floc_cur,1);
	end% if

	f(iz)  = f_new;
	fc(iz) = f_cur;

	% Compute the depth of the N2 maximum from current N2 minimum to iz :
	[ma izmax] = nanmax(n2(f_cur_iz:iz));
	gloc_new = zr(izmax+f_cur_iz-1);
	
	if gloc_new == gloc_cur
		imax = imax + 1;
		maxlist(imax) = gloc_cur;
		if debug
			plot(n2(gloc_cur_iz),gloc_cur,'k+','markersize',8)
		end% if 
	else
		gloc_cur = gloc_new;		
		gloc_cur_iz = find(zr==gloc_cur,1);
	end% if
		
	g(iz)  = g_new;
	gc(iz) = g_cur;
	
end% for iz
maxlistB = maxlist(maxlist <= zr(izOKa) & maxlist >= zr(izOKb) & maxlist >= -2000);
minlistB = minlist(minlist <= zr(izOKa) & minlist >= zr(izOKb) & minlist >= -2000);
minlistB = unique(minlistB);
maxlistB = unique(maxlistB);
maxlistB = sort(maxlistB);
minlistB = sort(minlistB);
stophere

%- Select pycnocline values:
if length(maxlistB) > 1
	%-- Select the 2nd value because they start from the surface:
	% the 1st peak is supposedly from the Mixed Layer Depth
	%maxlistB_pyc = maxlistB(2);
	%-- Select the 2nd value of the first decreasing pair from the surface:
	maxlistB_pyc = maxlistB(find(diff(maxlistB)>0,1,'last'));
elseif length(maxlistB) == 1
	%-- Select the only peak then:
	maxlistB_pyc = maxlistB(1);
else
	%-- Select the surface level:
	maxlistB_pyc = zr(1);
	maxlistB = zr(1);
end% if

%- Select mode water value:
% The minimum just above the pycnocline peak
minlistB_mwd = nanmin(find(minlistB>=maxlistB_pyc));

if debug
	if ~isnan(maxlistB_pyc)
		hline(minlistB_mwd,'color','b','linewidth',1)
		hline(maxlistB_pyc,'color','r','linewidth',1)
		title(sprintf('Thermocline depth: %0.2f',maxlistB_pyc))
	else
		title(sprintf('No thermocline'))
	end% if 
	if debug == 2
		stophere
	end% if 
end% if 

%- Outputs
varargout(1) = {maxlistB};
varargout(2) = {minlistB};
varargout(3) = {maxlistB_pyc};
varargout(4) = {minlistB_mwd};

end %functionminmax