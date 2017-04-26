% idvgrads_v2 Identify profile properties based on N2
%
% [] = idvgrads_v2([PARAMETER,VALUES])
% 
% Identify profile properties based on N2
%
% Inputs:
%
% Outputs:
%
%
% Created: 2013-03-12
% http://code.google.com/p/copoda
% Copyright 2013, COPODA

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

% Category for documentation:
%CAT 
% Method's type for documentation:
%TYP

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = idvgrads_v2(varargin)

%- DEFAULT PARAMETERS:

	%-- Debug mode (plot figures of what is going on):
	debug(1) = false;
	debug(2) = false;

	%-- Vertical grid resolution (m):
	dz = 5;

	%-- Diffusive smoother scale
	zscal = 30;
	n = fix(zscal/dz); 

	%-- MLD = depth where density increase compared to density at 10 m depth (zHref) equals 0.03 kg/m3 (dHst)
	dHst  = 0.03;
	zHref = -10;
	Hdz = 1; % Vertical grid thickness for interpolation

	%-- How deeper than the MLD do we work ?
	Hoffset = 10;

	%-- Minimum N2:
	N2min = 2e-5;

	%-- How deeper than the surface do we work ?
	below = -20;

	%-- Density by to determine the Thermocline tickness:
	dSTthd = .1;			

	%-- Maximum depth of the mode water
	core_top = -300;


%- LOAD PARAMETERS:
if nargin ~=0
	if mod(nargin,2) ~=0
		error('Parameters must come in pairs: PAR,VAL')
	end% if 
	istemp = false;
	for in = 1 : 2 : nargin
		eval(sprintf('%s = varargin{in+1};',varargin{in}));		
		if strcmp(varargin{in},'temp')
			istemp = true;
		end% if 
	end% for in	
	clear in
else
	error('Please provide something to work with !');
end% if

if dz ~= 50 | zscal ~= 100
	% Update Diffusive smoother scale
	n  = fix(zscal/dz); 
end% if 	

if length(debug) == 1
	debug(2) = false;
end

configstr = sprintf('dz=%0.0fm / zscal=%0.0fm / Hoffset=%0.0fm / below=%0.0fm / N2min=%0.2f / EDWbtm=%0.2f',dz,zscal,Hoffset,below,N2min,core_top);
%disp(configstr);

%- What are we working with ?
% Is this t,s or st0 for instance ?
% or do we have pressure and or depth axis ?

	%-- Vertical axis:
	switch exist('p','var')
		case 1
			switch exist('z','var')
				case 1
					% Need to verify p against z
				case 0
					% Need to compute z from p
					switch exist('lat','var')
						case 1
						case 0
							lat = 45;
					end% switch 
					z = sw_dpth(p,lat);				
			end% switch
		case 0
			switch exist('z','var')
				case 1
					% Need to compute p from z
					switch exist('lat','var')
						case 1
						case 0
							lat = 45;
					end% switch 
					p = sw_pres(abs(z),lat);
				case 0
					error('Please provide pressure (''p'') or depth (''z'') axis !')	
			end% switch
	end% switch

	%-- temp/psal/sig0:
	switch istemp
		case 1 % Start from temp/psal:
			% We need to compute potential density:
			if ~exist('psal','var') | ~exist('p','var')
				error('Please provide psal and p to work with temperature !')
			end% if 
			sig0 = sw_pden(psal,temp,p,0)-1000;
		case 0 % Start from st0
			if ~exist('sig0','var')
				error('Please provide something to work with !');
			end% if 
			% Create NaN temp and psal matrix for easy handling of the routine
			temp = zeros(size(sig0))*9999;
			psal = zeros(size(sig0))*9999;		
	end% switch 
	clear istemp

%- Clean levels (no NaNs and no duplicates on z):
ii = ~isnan(sig0) & ~isnan(p) & ~isnan(z) & diff([z z(end)])~=0;
sig0 = sig0(ii);
temp = temp(ii);
psal = psal(ii);
z    = z(ii);
p    = p(ii);

%- Check axis orientation
if z(1) < z(end)
	z = fliplr(z);
	p = fliplr(p);
	sig0 = fliplr(sig0);
	psal = fliplr(psal);
	temp = fliplr(temp);
end% if 

%- Determine the mixed layer depth with the raw profile:
H = diagthisH(z,sig0,Hdz,zHref,dHst);
if isempty(H)
	H = diagthisH(z,sig0,Hdz,z(1),dHst);	
end% if 
if isempty(H)
	H = 0;
end% if 
%core_top = H - 50;

%- Compute raw N2:
[bfrq,vort,p_ave] = sw_bfrq(psal,temp,p,lat);
bfrq = interp1(p_ave,bfrq,p,'linear'); clear vort p_ave

%stophere

%- Now move to a regular grid:
zr    = sort(-[0:dz:abs(z(end))],2,'descend');
sig0r = interp1(z,sig0,zr,'linear');
tempr = interp1(z,temp,zr,'linear');
psalr = interp1(z,psal,zr,'linear');
pr    = sw_pres(abs(zr),lat);
bfrqr = interp1(z,bfrq,zr,'linear');

% Fill in first levels with NaN with first non-NaN value
% itop = find(isnan(sig0r)==0,1,'first');
% if itop ~= 1
% 	sig0r(1:itop-1) = sig0r(itop);
% end% if 

%- FIGURE DEBUG:
if debug(1)
	figure; 
	if debug(2)
		figure_tall;
		iw=2;jw=2;ipl=0;
	else
		figure_land;
		iw=1;jw=2;ipl=0;
	end% if 
	ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on	
	axis square
	plot(sig0,z,'.-','color','b','linewidth',2);
	plot(sig0r,zr,'color','k','linewidth',1);	
	[tl tt] = ahline(H,'color','b','linewidth',2);set(tt,'string','MLD');
	[tl tt] = ahline(H-Hoffset,'color','r');set(tt,'string','MLD-Hoffset');	
	[tl tt] = ahline(below,'linewidth',2);set(tt,'string','below surface');
	%grid on,
	box on
	title(sprintf('Raw (blue) and interpolated (black) density profiles'));
end% if 

%- Apply some smoothing:
%stophere
%c = psalr; c([1 end]) = NaN; c = smoother1Ddiff(c',n)'; psalr=c; % psalr([2:end-1]) = c([2:end-1]);
%c = sig0r; c([1 end]) = NaN; c = smoother1Ddiff(c',n)'; sig0r=c; % sig0r([2:end-1]) = c([2:end-1]);
%c = tempr; c([1 end]) = NaN; c = smoother1Ddiff(c',n)'; tempr=c; % tempr([2:end-1]) = c([2:end-1]);
c = psalr; c([1 end]) = NaN; c = mysmoother1Ddiff(c',n)'; psalr=c; % psalr([2:end-1]) = c([2:end-1]);
%c = sig0r; c([1 end]) = NaN; c = mysmoother1Ddiff(c',n)'; sig0r=c; % sig0r([2:end-1]) = c([2:end-1]);
c = tempr; c([1 end]) = NaN; c = mysmoother1Ddiff(c',n)'; tempr=c; % tempr([2:end-1]) = c([2:end-1]);


%- Now we gonna work below the mixed layer and/or deeper than 'below' so we squeeze fields:
iHoffset = fix(abs(Hoffset/dz));
izmld    = find(zr<=H,1);
izmin    = find(zr<=below,1);
ii = max([izmld+iHoffset izmin]):length(tempr);

sig0r = sig0r(ii);
tempr = tempr(ii);
psalr = psalr(ii);
zr    = zr(ii);
pr    = pr(ii);

% For plots axis:
yl = [min(zr(~isnan(sig0r))) 0];
yl = [-1700 0];

% tempr([1 end]) = NaN;
% sig0r([1 end]) = NaN;
% psalr = smoother1Ddiff(psalr',n)';
% tempr = smoother1Ddiff(tempr',n)';
% sig0r = smoother1Ddiff(sig0r',n)';

%- Test for density inversion:
ii = find(sig0r(2:end) - (sig0r(1:end-1)+0.03) > 0 );
if ~isempty(ii) & ~isempty(find(zr(ii)<-1000))
	peak = null_answer(configstr);
	peak(1).qchistory = {'4: Found a density inversion below -1000m depth'};	
	varargout(1) = {peak};
	varargout(2) = {H};
	return;
end% if 

%- Compute N2:
if 1
	% Recompute with smooth interpolated profiles:
	[bfrqr,vortr,p_ave] = sw_bfrq(psalr,tempr,pr,lat);
	% move back to the regular grid:
	bfrqr = interp1(p_ave,bfrqr,pr,'linear');
	vortr = interp1(p_ave,vortr,pr,'linear');
	clear p_ave
	bfrqr(bfrqr<0) = NaN;
else
	% Or smooth interpolated profile:
	bfrqr = bfrqr(ii);
	c = bfrqr; c([1 end]) = NaN; c = smoother1Ddiff(c',n)'; bfrqr=c; 
end% if 

%- Apply a 2 points running mean for smoothing:
%bfrqr_smooth = myrunmean(bfrqr,NF,0,2);
bfrqr_smooth = bfrqr;

%- Now decompose the smoothed N2 profile into a sum of gaussian:
%stophere

% What do we want to work with:
C0  = bfrqr_smooth;
%C0  = bfrqr;
C0z = zr;

% Ensure no NaN are in this profile:
izok = find(~isnan(C0)==1);
C  = C0(izok);
Cz = C0z(izok);

if isempty(izok) | Cz(1) < -1000
	% Impossible to determine a thermocline peak !
	peak = null_answer(configstr);
	peak(1).qchistory = {'4: Not enough point for computation'};	
	varargout(1) = {peak};
	varargout(2) = {H};
	return;
else
	% Fit two gaussian:
	[g_fit g_val g_depth g_fit_thick qc cc g_top qchistory] = fitagaussto_asym_vect(Cz,C,core_top,-1500,debug,yl,H);
end% if 

if isnan(g_depth)
	core_pv = NaN;
else
	core_pv = vortr(find(zr==g_depth,1));
end

% Store results:
icz = find(zr==g_depth,1);
ipeak = 1;
peak(ipeak).fitscore = cc;
peak(ipeak).configstr = configstr;
peak(ipeak).qc = qc;
peak(ipeak).qchistory = qchistory;
peak(ipeak).depth = g_depth;		
peak(ipeak).thickness = g_fit_thick; % top - bto
peak(ipeak).amplitude = g_val;
% peak(ipeak).core_sig0 = min([Inf ; sig0r(find(zr==g_depth,1))]);
% peak(ipeak).core_temp = min([Inf ; tempr(find(zr==g_depth,1))]);
% peak(ipeak).core_psal = min([Inf ; psalr(find(zr==g_depth,1))]);
% peak(ipeak).core_bfrq = min([Inf ; bfrqr(find(zr==g_depth,1))]);
peak(ipeak).core_temp = min([Inf ; tempr(icz)]);
peak(ipeak).core_psal = min([Inf ; psalr(icz)]);
peak(ipeak).core_bfrq = min([Inf ; bfrqr(icz)]);
peak(ipeak).core_sig0 = min([Inf ; sw_pden(peak(ipeak).core_psal,peak(ipeak).core_temp,min([Inf pr(icz)]),0)-1000 ]); % Because we don't smooth sig0r anymore
peak(ipeak).core_pv   = core_pv;
peak(ipeak).top = g_depth+g_fit_thick(1);
peak(ipeak).bto = g_depth-g_fit_thick(2);
peak(ipeak).mw  = g_top;

bestfit = zeros(1,length(C0))*NaN; bestfit(izok) = g_fit;

peak(ipeak).N2_bestfit    = bestfit;
peak(ipeak).N2_bestfit_z  = C0z;

peak(ipeak).N2_work    = C;
peak(ipeak).N2_work_z  = Cz;

peak(ipeak).N2_raw    = bfrq;
peak(ipeak).N2_raw_z  = z;

peak(ipeak).configstr = configstr;

%- FIGURE DEBUG
if debug(1)
	axes(subp(1));	
	set(gca,'ylim',yl);
	set(gca,'xlim',[25 28]);
	for ip = 1 : length(peak)
		[tl tt] = ahline(peak(ip).depth);
		set(tt,'string',sprintf('#%i: %0.1f\\pm%0.1f',ip,peak(ip).depth,sum(peak(ip).thickness)));
%		hline(peak(ip).depth+[-1 0 1].*peak(ip).thickness,'linestyle','--','color','k');
		hline(peak(ip).depth,'color','k');
		hline(peak(ip).depth+peak(ip).thickness(1),'linestyle','--','color','k');
		hline(peak(ip).depth-peak(ip).thickness(2),'linestyle','-.','color','k');
	end% for ip
	set(gca,'yaxislocation','right');

	if debug(2)
		ipl = 3;
	else
		ipl = 1;
	end% if 

	ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
%	plot(bfrq,z,'b.-','linewidth',1);
%	plot(bfrqr,zr,'k.-','linewidth',.5);
	plot(peak(ipeak).N2_raw,peak(ipeak).N2_raw_z,'b.-','linewidth',1);
	plot(peak(ipeak).N2_work,peak(ipeak).N2_work_z,'k.-','linewidth',.5);
	plot(peak(ipeak).N2_bestfit,peak(ipeak).N2_bestfit_z,'r.-','linewidth',1.2);
	grid on;box on
	vline(N2min);
	ip = 1;
	hline(peak(ip).depth,'color','k');
	hline(peak(ip).depth+peak(ip).thickness(1),'linestyle','--','color','k');
	hline(peak(ip).depth-peak(ip).thickness(2),'linestyle','--','color','k');
	set(gca,'xlim',[0 5e-5]);
	title(sprintf('Blue: raw N2\nBlack: working N2\nRed: N2 fit for TH Diagnostic'));
	axis square	
	set(gca,'ylim',yl);

	% ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
	% p=plot(bfrqr_artif,zr,'linewidth',2);
	% le = legend(p,num2str([1:length(p)]'),4);
	% grid on;box on
	% vline(2e-5);
	% hline(H,'color','r')
	% hline([peak.depth]);
	% title('Decomposed N2 gaussian profiles');
	% axis square

end% if 


%- TITLE FIGURE DEBUG
if debug(1)
%	suptitle(sprintf('Determined THD=%0.1f\\pm%0.1f with QC Flag %i (c=%0.2f)\n%s',peak(1).depth,sum(peak(1).thickness),peak(1).qc,peak(1).fitscore,configstr))
	suptitle(sprintf('Determined THD=%0.1f\\pm%0.1f with QC Flag %i\n%s',peak(1).depth,sum(peak(1).thickness),peak(1).qc,configstr))
%	set(le,'location','southeast');
end% if 

%- Outputs
varargout(1) = {peak};
varargout(2) = {H};


end %functionidvgrads_v2

%%%%%%%%%%%%%%%%%%%%%%%%%
function peak = null_answer(configstr)

	ipeak = 1;
	peak(ipeak).fitscore = NaN;
	peak(ipeak).configstr = configstr;
	peak(ipeak).qc = 4;
	peak(ipeak).qchistory = {};
	peak(ipeak).depth = NaN;
	peak(ipeak).thickness = NaN;
	peak(ipeak).amplitude = NaN;
	peak(ipeak).core_temp = NaN;
	peak(ipeak).core_psal = NaN;
	peak(ipeak).core_bfrq = NaN;
	peak(ipeak).core_sig0 = NaN;
	peak(ipeak).core_pv   = NaN;
	peak(ipeak).top = NaN;
	peak(ipeak).bto = NaN;
	peak(ipeak).mw  = NaN;

	peak(ipeak).N2_bestfit    = NaN;
	peak(ipeak).N2_bestfit_z  = NaN;

	peak(ipeak).N2_work    = NaN;
	peak(ipeak).N2_work_z  = NaN;

	peak(ipeak).N2_raw    = NaN;
	peak(ipeak).N2_raw_z  = NaN;

	
end%end function

%%%%%%%%%%%%%%%%%%%%%%%%%
%- Determine the mixed layer depth:
function H = diagthisH(z,st0,Hdz,zHref,dHst)

	% Get rid of NaN:	
	z   = z(~isnan(st0));
	st0 = st0(~isnan(st0));

	% Reference density:	
	st0Href = interp1(z,st0,zHref,'linear');

	% Interpolate vertical profile:
	zr   = fliplr(z(end):Hdz:z(1));
	st0r = interp1(z,st0,zr,'linear');

	% Fill in first levels with NaN with first non-NaN value
	itop = find(isnan(st0r)==0,1,'first');
	if itop ~= 1
		st0r(1:itop-1) = st0r(itop);
	end% if

	% Get the MLD:
	H = zr(find(abs(st0r-st0Href)>=dHst,1,'first'));

end%function


%%%%%%%%%%%%%%%%%%%%%%%%
function [g_fit g_val g_depth g_fit_thick qc cc g_min qchistory] = fitagaussto_asym_vect(x,y,EDWbtm,bottom,debug,yl,MLD);

	%-- Identify the first inflexion point (mode water minimum)
	% as the y minimum above EDWbtm (core_top)
	ix = find(x>=EDWbtm);
	if ~isempty(ix)
		[ytop ixtop] = min(y(ix));
	else
		ixtop = 1;
		ytop  = y(ixtop);
	end% if 
	xtop  = x(ixtop);

	%-- Identify the deepest point of the profile:
%	bottom = -1500;
	ixdeep = min([find(x>=bottom,1,'last') ; find(~isnan(y)==1,1,'last')]);
	xdeep  = x(ixdeep);
	ydeep  = y(ixdeep);

	%-- Core layer of the analysis:
	ixcore = find(x>=xdeep & x<xtop);

	if isempty(ixcore)
		% Impossible to determine a thermocline peak !
		g_fit = ones(1,length(x))*NaN;
		g_val = NaN;
		g_depth = NaN;
		g_fit_thick = [NaN; NaN];
		cc = NaN;
		g_min = NaN;
		qc = 50; % See below for convention
		qcdef(qc) = {'No layer'};
		qchistory = get_qchistory(qcdef);
		return
	end% if 

	%-- Is there any peak in the core ?
	dy = diff(y(ixcore));
	if length(find(dy>0)) > 1 & length(find(dy<0)) > 1
		% Yes, we move on
	elseif 0
		% No !
		% Impossible to determine a thermocline peak !
		g_fit = ones(1,length(y))*NaN;
		g_val = NaN;
		g_depth = NaN;
		g_fit_thick = [NaN; NaN];
		qc = 4;
		cc = NaN;
		g_min = NaN;
		qc = 51; % See below for convention
		qcdef(qc) = {'Impossible to determine a thermocline peak: no peak in the core'};
		qchistory = get_qchistory(qcdef);		
		return
	end
%	stophere

	%-- Identify the second inflexion point (thermocline maximum)
	% as the y maximum between xtop and xdeep:
	%stophere
	if 0	
		[ymax ixmax] = max(y(ixcore));
		ixmax = ixmax + ixtop;
	else
		ixmax = find(y(ixcore)>=0.9*max(y(ixcore)));
		ymax  = mean(y(ixcore(ixmax)));
		xmax  = mean(x(ixcore(ixmax)));
		ixmax = find(x(ixcore)>=xmax,1,'last') + ixtop;
	end% if
	xmax  = x(ixmax);
	% if xtop - xmax < 30 & 0
	% 	% Impossible to determine a thermocline peak !
	% 	g_fit = ones(1,length(y))*NaN;
	% 	g_val = NaN;
	% 	g_depth = NaN;
	% 	g_fit_thick = [NaN; NaN];
	% 	qc = 4;
	% 	cc = NaN;
	% 	g_min = NaN;
	% 	qc = 52; % See below for convention
	% 	qcdef(qc) = {'Impossible to determine a thermocline peak: no peak in the core'};
	% 	qchistory = get_qchistory(qcdef);		
	% 	return
	% end% if 

	
	%-- Check if there is another N2 minimum between xtop and xmax
	% If this is the case re-adjust xtop
	ixcore_top = find(x>=xmax & x<=xtop);
	if (min(y(ixcore_top)) < ytop)		
		% Yes ! so we re-adjust appropriate variables:
		[ytop ai] = min(y(ixcore_top));
		ixtop = ixcore_top(ai);
		xtop = x(ixtop);
		ixcore = find(x>=xdeep & x<xtop);		
	end% if 
	
	% ysorted = fliplr(sort(y(ixcore)));
	% ymax    = mean(ysorted(1:10));
	% ixmax   = fix(mean(find(y>ymax))) + ixcore(1);
	% xmax    = x(ixmax);


	%-- Construct the linear fit:
	a = (ytop - ydeep)./(xtop - xdeep);
	b = ytop - a*xtop;
	carrier = a.*x + b;
	carrier(find(x>xtop | x<xdeep)) = NaN;

	%carrier_top  = carrier;
	carrier_top(1:length(x)) = ytop;
	carrier_top(find(x>xtop | x<xmax)) = NaN;
	
	carrier_deep(1:length(x)) = ydeep;
	carrier_deep(find(x>xmax | x<xdeep)) = NaN;


	%-- Create a list of gaussian curves with misc sigma thickness:
	sig = 0 : 2 : 700;
	nn  = 10; %fix(.2*length(sig));

	glist = gauss(x(ixcore),sig,x(ixmax),ymax-carrier(ixmax));
	gtbl = zeros(length(sig),length(x));
	gtbl(:,ixcore) = glist;
	% Add the carrier signal:
	carriertbl = meshgrid(carrier,1:length(sig));
	gtbl = gtbl + carriertbl;

	glist_top = gauss(x(ixcore),sig,x(ixmax),ymax-carrier_top(ixmax));
	gtbl_top = zeros(length(sig),length(x));
	gtbl_top(:,ixcore) = glist_top;
	% Add the carrier signal:
	carriertbl = meshgrid(carrier_top,1:length(sig));
	gtbl_top = gtbl_top + carriertbl;
	gtbl_top(:,find(x>xtop | x<xmax)) = NaN;

	glist_deep = gauss(x(ixcore),sig,x(ixmax),ymax-carrier_deep(ixmax));
	gtbl_deep = zeros(length(sig),length(x));
	gtbl_deep(:,ixcore) = glist_deep;
	% Add the carrier signal:
	carriertbl = meshgrid(carrier_deep,1:length(sig));
	gtbl_deep = gtbl_deep + carriertbl;
	gtbl_deep(:,find(x>xmax | x<xdeep)) = NaN;


	% signal table:
	ytbl = meshgrid(y,1:length(sig));
	ytbl_top  = meshgrid(y,1:length(sig)); ytbl_top(:,find(x>xtop | x<xmax)) = NaN;
	ytbl_deep = meshgrid(y,1:length(sig)); ytbl_deep(:,find(x>xmax | x<xdeep)) = NaN;

	%-- Identify top/deep signals gaussian best fit:
	ix = ixtop:ixmax;
	fitscoretop = nansum((gtbl_top(:,ix) - ytbl_top(:,ix)).^2,2)*1e9;	
	ix = ixmax:ixdeep;
	fitscoredeep = nansum((gtbl_deep(:,ix) - ytbl_deep(:,ix)).^2,2)*1e9;	

	dd_top  = gtbl(:,ixcore(1)) - ytbl(:,ixcore(1));
	dd_deep = gtbl(:,ixcore(end)) - ytbl(:,ixcore(end));

	[a isbest_top]  = min(fitscoretop);
	[a isbest_deep] = min(fitscoredeep);

	bestfit(1:ixtop-1) = NaN;
	bestfit(ixtop:ixmax)  = gtbl_top(isbest_top,ixtop:ixmax);
	bestfit(ixmax:ixdeep) = gtbl_deep(isbest_deep,ixmax:ixdeep);
	bestfit(ixdeep+1:length(x)) = NaN;

	fitscore = nansum((gtbl - ytbl).^2,2)*1e9;	
	[a isbest] = min(fitscore);
	bestfit_sym  = gtbl(isbest,:);

	%-- Try to QC flag results:
	% 1: OK (At least no weird stuff found)
	% 2*: To be verified
	% 3*: Probably wrong
	% 4*: Certainly wrong
	% 5*: Could not perform diagnostic
	% 
	% qcdef(1)  = {'Looks good'};
	% qcdef(20) = {'abs(EDWbtm-xtop) < 20'};
	% qcdef(21) = {'abs(xtop - xmax) < 50'};
	% qcdef(22) = {'ixtop == 1'};
	% qcdef(23) = {'Deep best fit reache range limits'};
	% qcdef(24) = {'Top best fit reache range limits'};
	% qcdef(30) = {'sig(isbest_top) < 25'};
	% qcdef(31) = {'Top gaussian not well resolved'};
	% qcdef(32) = {'Bottom gaussian not well resolved'};
	% qcdef(40) = {'~(length(find(dy>0)) > 1 & length(find(dy<0)) > 1)'};
	% qcdef(50) = {'No layer to analyse'};
	
	qc = 1; % Default value (all good right ?)
	qcdef(qc) = {'Looks good'};
	iqc = 0;
	
	%--- May be wrong, need to be verified:
	if abs(EDWbtm-xtop) < 20
		qc = 20;
		qcdef(qc) = {'abs(EDWbtm-xtop) < 20'};
		iqc = iqc + 1;
	end% if 

	if abs(xtop - xmax) < 50
		qc = 21;
		qcdef(qc) = {'abs(xtop - xmax) < 50'};
		iqc = iqc + 1;
	end% if 
	
	if ixtop == 1
		qc = 22;
		qcdef(qc) = {'ixtop == 1'};
		iqc = iqc + 1;
	end% if
	
	if isbest_deep == 1 | isbest_deep == length(fitscoredeep)
		qc = 23;
		qcdef(qc) = {'Deep best fit reaches range limits'};
		iqc = iqc + 1;
	end% if 
	
	if isbest_top == 1 | isbest_top == length(fitscoretop)
		qc = 24;
		qcdef(qc) = {'Top best fit reaches range limits'};
		iqc = iqc + 1;
	end% if 
	
	
	
	%--- Likely wrong:	
	if sig(isbest_top) < 25
		% Top gaussian too thin
		qc = 30;
		qcdef(qc) = {'sig(isbest_top) < 25'};
		iqc = iqc + 1;
	end% if
	
	if ~(length(find(diff(fitscoretop)>0)) > nn & length(find(diff(fitscoretop)<0)) > nn)
		% Top gaussian not well resolved
		qc = 31;
		qcdef(qc) = {'Top gaussian not well resolved'};
		iqc = iqc + 1;
	end% if 
	
	if ~(length(find(diff(fitscoredeep)>0)) > nn & length(find(diff(fitscoredeep)<0)) > nn)
		% Bottom gaussian not well resolved
		qc = 32;
		qcdef(qc) = {'Bottom gaussian not well resolved'};
		iqc = iqc + 1;
	end% if 
		
	%--- Certainly wrong:
	if ~(length(find(dy>0)) > 1 & length(find(dy<0)) > 1)
		qc = 40;
		qcdef(qc) = {'~(length(find(dy>0)) > 1 & length(find(dy<0)) > 1)'};
		iqc = iqc + 1;
	end% if 
	
	% if iqc > 2
	% 	qc = 41;
	% 	qcdef(qc) = {'Too much qc failed'};
	%	iqc = iqc + 1;
	% end% if 
	
	%-- RECAP QC HISTORY:
	qchistory = get_qchistory(qcdef);
	
	%-- FIGURE DEBUG
	if debug(2)	
		qchistory	
		if debug(1) == 0 
			figure;  ffband; iw=1;jw=3;ipl=0;		
		else
			iw=2;jw=2; ipl = 1;
		end% if
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl); hold on
%		p = plot(y,x,'k',ytop,xtop,'r+',ydeep,xdeep,'k+',bestfit,x,'r',bestfit_sym,x,'r--');		
		p = plot(y,x,'k',ytop,xtop,'r+',ydeep,xdeep,'k+',bestfit,x,'r',bestfit_sym,x,'r--');		
		p2 = plot(carrier(ixcore),x(ixcore),carrier_top(ixcore),x(ixcore),carrier_deep(ixcore),x(ixcore));
		set(gca,'xlim',[0 5e-5],'ylim',yl);

		hline(EDWbtm,'color','m');
		hline(xtop,'color','r');
		hline([xdeep xmax]);
		ith = 0;
		ith=ith+1; th(ith) = text(max(get(gca,'xlim')),EDWbtm,'EDWbtm (core_top)','color','m');
		ith=ith+1; th(ith) = text(max(get(gca,'xlim')),xtop,'xtop','color','r');
		ith=ith+1; th(ith) = text(max(get(gca,'xlim')),xdeep,'xdeep','color','k');
		ith=ith+1; th(ith) = text(max(get(gca,'xlim')),xmax,'xmax','color','k');
		set(th,'interpreter','none','VerticalAlignment','middle');

		set(p([2 3]),'linewidth',1);
		grid on;box on;
		ylabel('Depth (m)');xlabel('Profile unit');
		title(sprintf('Profile fitting (QC score = %i)',qc));
		l=legend('Input Signal to fit','Surface layer core','Bottom limit','Asymmetric fit','Symmetric fit',...
			'location','southeast');
		%set(l,'fontsize',8);
		axis square;

		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		[ax h1 h2]=plotyy(sig,fitscoredeep,sig,fitscoretop);grid on;box on
		set(ax,'xlim',[0 max(sig)]);
		set(h1,'marker','.','color','k'); set(ax(1),'ycolor','k');
		set(h2,'marker','.','color','r'); set(ax(2),'ycolor','r');
		vline(sig([isbest_top isbest_deep]));
		xlabel('\sigma (m)');ylabel('score');
%		hline(nansum((polyval(po,x)-y).^2)*1e9,'color',[.2 .6 .2]);
		set(ax,'PlotBoxAspectRatio',[1 1 1]);

		if (length(find(diff(fitscoretop)>0)) > nn & length(find(diff(fitscoretop)<0)) > nn) & qc ~= 32
			% There is a inflexion point:
			title(sprintf('Gaussian fit score: good !\n[%i>nmin=%i and %i>nmin=%i]',length(find(diff(fitscoretop)>0)),nn,length(find(diff(fitscoretop)<0)),nn));
		else
			title(sprintf('Gaussian fit score: suspicious ;-( \n[%i>nmin=%i and %i>nmin=%i] ',length(find(diff(fitscoretop)>0)),nn,length(find(diff(fitscoretop)<0)),nn));
		end

		if debug(1) == 0 
			ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
			plot(sig,dd_top,'r.',sig,dd_deep,'k.');grid on;box on
			axis([0 max(sig) -2e-6 10e-6]);
			vline(sig([isbest_top isbest_deep]));
			xlabel('\sigma (m)');ylabel('Profile unit');
			title('Gaussian fit top and bottom spread');
		end% if 

%		stophere
% 		figure(213);hold on
% 		[aa ab] = getcrosscor(y,y,length(y)/2);
% 		plot(ab,aa);
% 		hline;vline
% 		grid on; box on
% 		title('Input Signal lagged auto-correlation');

		% figure
		% po = polyfit(x,y,2);
		% plot(y,x,'k',polyval(po,x),x,y-polyval(po,x),x,'r');
		% vline;
		% hline(xtop,'color','r');
		% hline(xdeep,'color','k','linestyle','--');
		% hline(xmax);
		% title(sprintf('Curvature: %f',unique(sign(diff(diff(polyval(po,x)))))));


	end% if 

	%-- Output:	
	g_fit = bestfit;
	g_depth = xmax;
	g_val   = ymax;
%	g_fit_thick = sig(b);
	g_fit_thick = [sig(isbest_top) ; sig(isbest_deep)];
	g_min = xtop;
%	qc = 1;

	cc = max([fitscoretop(isbest_top) ; fitscoredeep(isbest_deep)]);

end%function

%%%%%%%%%%%%%%%%%%%%%%%%
function qchistory = get_qchistory(qcdef)
	qchistory = {};
	for ii = 1 : length(qcdef)
		if ~isempty(qcdef{ii})
			qchistory = cat(1,qchistory,sprintf('%i: %s',ii,qcdef{ii}));
		end% if 
	end% for ii
end%end function

%%%%%%%%%%%%%%%%%%%%%%%%
function [g_fit g_val g_depth g_fit_thick qc cc g_min] = fitagaussto_vect(x,y,top,bottom,debug,yl);

	%-- Identify the first inflexion point (mode water minimum)
	% as the y minimum in the top 500m
%	top = -500;
	ix = find(x>=top);
	if ~isempty(ix)
		[ytop ixtop] = min(y(ix));
	else
		ixtop = 1;
		ytop  = y(ixtop);
	end% if 
	xtop  = x(ixtop);

	%-- Identify the deepest point of the profile:
%	bottom = -1500;
	ixdeep = min([find(x>=bottom,1,'last') ;find(~isnan(y)==1,1,'last')]);
	xdeep  = x(ixdeep);
	ydeep  = y(ixdeep);

	%-- Construct the linear fit:
	a = (ytop - ydeep)./(xtop - xdeep);
	b = ytop - a*xtop;
	carrier = a.*x + b;
	carrier(find(x>xtop | x<xdeep)) = NaN;

	%-- Identify the second inflexion point (thermocline maximum)
	% as the y maximum between xtop and xdeep:
	ixcore = find(x>=xdeep & x<xtop);
	[ymax ixmax] = max(y(ixcore)); 
	ixmax = ixmax + ixtop;
	xmax  = x(ixmax);

	%-- Create a list of gaussian curves with misc sigma thickness:
	sig = 5 : 5 : 700;
	glist = gauss(x(ixcore),sig,x(ixmax),ymax-carrier(ixmax));
	gtbl = zeros(length(sig),length(x));
	gtbl(:,ixcore) = glist;
	% Add the carrier signal:
	carriertbl = meshgrid(carrier,1:length(sig));
	gtbl = gtbl + carriertbl;

	% signal table:
	ytbl = meshgrid(y,1:length(sig));

	fitscore = nansum((gtbl - ytbl).^2,2)*1e9;	
	dd_top  = gtbl(:,ixcore(1)) - ytbl(:,ixcore(1));
	dd_deep = gtbl(:,ixcore(end)) - ytbl(:,ixcore(end));

	[a b] = min(fitscore);
	bestfit  = gtbl(b,:);

	if debug(2)
		if debug(1) == 0 
			figure;  figure_band; iw=1;jw=3;ipl=0;		
		else
			iw=3;jw=2; ipl = 1;
		end% if
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl); hold on
		p = plot(y,x,'k',ytop,xtop,'r+',ydeep,xdeep,'k+',carrier(ixcore),x(ixcore),bestfit,x,'r');		
		set(gca,'xlim',[0 5e-5],'ylim',yl);
		hline(xtop,'color','r');
		hline([xdeep xmax]);
		set(p,'linewidth',2);
		grid on;box on;
		ylabel('Depth (m)');xlabel('Profile unit');
		title('Profile fitting');
		l=legend('Input Signal to fit','Surface layer core','Bottom limit','Carrier signal','Gaussian best fit',...
			'location','southeast');
		set(l,'fontsize',7);

		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		plot(sig,fitscore,'.');grid on;box on
		axis([0 max(sig) 0 5]);
		vline(sig(b));
		xlabel('\sigma (m)');ylabel('score');
%		hline(nansum((polyval(po,x)-y).^2)*1e9,'color',[.2 .6 .2]);

		nn = .2*length(sig);
		if length(find(diff(fitscore)>0)) > nn & length(find(diff(fitscore)<0)) > nn
			% There is a inflexion point:
			title(sprintf('Gaussian fit score: good ! [%i>%i and %i>%i]',length(find(diff(fitscore)>0)),nn,length(find(diff(fitscore)<0)),nn));
		else
			title(sprintf('Gaussian fit score: suspicious ;-( [%i>%i and %i>%i]',length(find(diff(fitscore)>0)),nn,length(find(diff(fitscore)<0)),nn));
		end

		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		plot(sig,dd_top,'r.',sig,dd_deep,'k.');grid on;box on
		axis([0 max(sig) -2e-6 10e-6]);		
		vline(sig(b));
		xlabel('\sigma (m)');ylabel('Profile unit');
		title('Gaussian fit top and bottom spread');

%		stophere
% 		figure(213);hold on
% 		[aa ab] = getcrosscor(y,y,length(y)/2);
% 		plot(ab,aa);
% 		hline;vline
% 		grid on; box on
% 		title('Input Signal lagged auto-correlation');

		% figure
		% po = polyfit(x,y,2);
		% plot(y,x,'k',polyval(po,x),x,y-polyval(po,x),x,'r');
		% vline;
		% hline(xtop,'color','r');
		% hline(xdeep,'color','k','linestyle','--');
		% hline(xmax);
		% title(sprintf('Curvature: %f',unique(sign(diff(diff(polyval(po,x)))))));


	end% if 

	% QC:
	po = polyfit(x,y,2);	
	switch unique(sign(diff(diff(polyval(po,x)))))
		case -1
			qc = 1;
		case 1
			% This is probably due to a peack too close from the upper limit
			qc = 2;
	end% switch 


%	stophere	

	%-- Output:	
	g_fit = bestfit;
	g_depth = xmax;
	g_val   = ymax;
	g_fit_thick = sig(b);
	g_min = xtop;
%	qc = 1;
	cc = fitscore(b);

end%function



%%%%%%%%%%%%%%%%%%%%%%%%
function [g_fit g_val g_depth g_fit_thick qc cc] = fitagaussto(x,y,top,bottom,debug);

	%-- Identify the first inflexion point (mode water minimum)
	% as the y minimum in the top 500m
%	top = -500;
	ix = find(x>=top);
	if ~isempty(ix)
		[ytop ixtop] = min(y(ix));
	else
		ixtop = 1;
		ytop  = y(ixtop);
	end% if 
	xtop  = x(ixtop);

	%-- Identify the deepest point of the profile:
%	bottom = -1500;
	ixdeep = min([find(x>=bottom,1,'last') ;find(~isnan(y)==1,1,'last')]);
	xdeep  = x(ixdeep);
	ydeep  = y(ixdeep);

	%-- Construct the linear fit:
	a = (ytop - ydeep)./(xtop - xdeep);
	b = ytop - a*xtop;
	carrier = a.*x + b;
	carrier(find(x>xtop | x<xdeep)) = NaN;

	%-- Identify the second inflexion point (thermocline maximum)
	% as the y maximum between xtop and xdeep:
	ixcore = find(x>=xdeep & x<=xtop);
	[ymax ixmax] = max(y(ixcore)); 
	ixmax = ixmax + ixtop;
	xmax  = x(ixmax);

	sig = 10 : 5 : 500;
	glist = gauss(x(ixcore),sig,x(ixmax),ymax-carrier(ixmax));

	for is = 1 : length(sig)
		xfit = x(ixcore);
		fit  = glist(is,:)+carrier(ixcore);		
		fitscore(is) = sum((fit-y(ixcore)).^2);
		dd(is) = sum([fit(1)-y(ixcore(1)) ; fit(end)-y(ixcore(end))]);
	end% for is	
	[a b] = min(fitscore);
	xfit = x(ixcore);
	bestfit  = glist(b,:)+carrier(ixcore);

	if debug
		figure;  figure_land; iw=1;jw=3;ipl=0;		
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);
		p = plot(y,x,ytop,xtop,'r+',ydeep,xdeep,'k+',carrier(ixcore),x(ixcore),bestfit,xfit);		
		hline([xdeep xmax xtop]);
		set(p(1:end-1),'linewidth',2);
		grid on;box on;
		ylabel('Depth (m)');xlabel('Profile unit');
		title('Profile fitting');
		legend('signal','Surface layer core','Bottom limit','Carrier signal','Gaussian best fit',4);

		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		plot(sig,fitscore,'.');grid on;box on
		vline(sig(b))
		xlabel('\sigma (m)');ylabel('score');
		title('Gaussian fit score');

		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		plot(sig,dd,'.');grid on;box on
		vline(sig(b))		
		xlabel('\sigma (m)');ylabel('Profile unit');
		title('Gaussian fit top and bottom spread');
	end% if 

	%-- Output:	
	g_fit = ones(1,length(x))*NaN;
	g_fit(ixcore) = bestfit;
	g_depth = xmax;
	g_val   = ymax;
	g_fit_thick = sig(b);
	qc = 1;
	cc = fitscore(b);

end%function



%%%%%%%%%%%%%%%%%%%%%%%%%
function [g_fit g_fit_thick qc cc] = fitagaussto_old(x,x0,y0,y);

	stophere

	sig = 10 : 5 : 500;	
	g_seasth = gauss(x,sig,x0,y0)';
	g_seasth_anom = detrend(g_seasth,'constant');

%	g_ref = meshgrid(y,1:length(sig))';
	g_ref = meshgrid(detrend(y),1:length(sig))';
	g_ref_anom = detrend(g_ref,'constant');

	cc = sum(g_seasth_anom.*g_ref_anom,1)./length(sig)./std(g_seasth)./std(g_ref);

	[a isig] = max(cc); clear a
	g_fit_thick = sig(isig);
	g_fit = gauss(x,sig(isig),x0,y0);
	cc = cc(isig);
	if g_fit_thick == max(sig) | g_fit_thick == min(sig)
		qc = 3;
	else
		qc = 1;
	end% if 

% 	found = false;
% 	cc(1) = NaN;
% 	for ii = 2 : length(sig)
% 		g_seasth = gauss(x,sig(ii),x0,y0);
% %		cc(ii) = sum((y-g_seasth).^2);
% %		cc(ii) = min(min(corrcoef(y,g_seasth)));
% 		cc(ii) = min(min(corrcoef(detrend(y),g_seasth)));
% 		if cc(ii) < cc(ii-1) & ~found
% 			isigreal = ii; found = true;
% 		end
% 	end% for ii
% 	if found
% 		isig = isigreal - 1;
% 	else
% 		[a isig] = max(cc); clear a
% 	end% if 
% 	g_fit_thick = sig(isig);
% 	g_fit = gauss(x,sig(isig),x0,y0);


end%function




%%%%%%%%%%%%%%%%%%%%%%%%%
function [field_out] = mysmoother1Ddiff(field_in,dist_in1)

% Same as 2D version but much faster if performed on a single dimension

% domaine_global_def;
nt = size(field_in,1);

e1t = ones(nt,size(field_in,2));
e1tsq = e1t.^2;

% scale the diffusive operator:
smooth2D_dt  = 1;
smooth2D_nbt = max(max(max(dist_in1./e1t)));
smooth2D_nbt = 2*ceil(2*smooth2D_nbt^2);
smooth2D_T   = smooth2D_nbt*smooth2D_dt;

smooth2D_kh1 = dist_in1.*dist_in1/smooth2D_T/2;
smooth2D_kh2 = smooth2D_kh1/2;

% time-stepping loop:
field_out = field_in; 

[p, sizeA, numDimsA] = ParseInputs(field_out,[1 0]); clear p
[p, sizeB, numDimsB] = ParseInputs(smooth2D_kh1,[1 0]); clear p

%stophere

% for icur = 1 : smooth2D_nbt
	
% 	circ1 = mycircshift(field_out,[1 0], sizeA, numDimsA);
% 	circ2 = mycircshift(smooth2D_kh1,[1 0], sizeB, numDimsB);
% 	tmp1 = (field_out-circ1)./e1tsq.*(smooth2D_kh2+circ2/2);
% 	tmp1(isnan(tmp1)) = 0;

% 	circ1 = mycircshift(field_out,[-1 0], sizeA, numDimsA);
% 	circ2 = mycircshift(smooth2D_kh1,[-1 0], sizeB, numDimsB);
% 	tmp2 = (circ1-field_out)./e1tsq.*(smooth2D_kh2+circ2/2); 
% 	tmp2(isnan(tmp2)) = 0;

% 	field_out = field_out-(smooth2D_dt*(tmp1-tmp2))./e1tsq;
% end

% Optimization parameters:
ii1 = [sizeA(1), 1 : sizeA(1)-1];
ii2 = [2 : sizeA(1), 1];
circ2 = smooth2D_kh1; 

circ1 = field_out(ii1); tmp1 = (field_out-circ1)./e1tsq.*(smooth2D_kh2+circ2/2); isnantmp1 = find(isnan(tmp1)==1);
circ1 = field_out(ii2); tmp2 = (circ1-field_out)./e1tsq.*(smooth2D_kh2+circ2/2); isnantmp2 = find(isnan(tmp2)==1);

for icur = 1 : smooth2D_nbt
	
	circ1 = field_out(ii1); 
	tmp1 = (field_out-circ1)./e1tsq.*(smooth2D_kh2+circ2/2);
	tmp1(isnantmp1) = 0;

	circ1 = field_out(ii2);
	tmp2 = (circ1-field_out)./e1tsq.*(smooth2D_kh2+circ2/2);
	tmp2(isnantmp2) = 0;

	field_out = field_out-(smooth2D_dt*(tmp1-tmp2))./e1tsq;
	
end


end %functionsmoother1Ddiff

%%%%%%%%%%%%%%%%%%%%%%%%%
function b = mycircshift(a, p, sizeA, numDimsA)
	
	stophere
	
	% Calculate the indices that will convert the input matrix to the desired output
	% Initialize the cell array of indices
	idx = cell(1, numDimsA);

	% Loop through each dimension of the input matrix to calculate shifted indices
	for k = 1 : numDimsA
	    m      = sizeA(k);
	    idx{k} = mod((0:m-1)-p(k), m)+1;
	end

	% Perform the actual conversion by indexing into the input matrix
	b = a(idx{:});

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%
function [p, sizeA, numDimsA] = ParseInputs(a,p)

% default values
sizeA    = size(a);
numDimsA = ndims(a);

% Make sure that SHIFTSIZE input is a finite, real integer vector
sh        = p(:);
isFinite  = all(isfinite(sh));
nonSparse = all(~issparse(sh));
isInteger = all(isa(sh,'double') & (imag(sh)==0) & (sh==round(sh)));
isVector  = isvector(p);

% Error out if ParseInputs discovers an improper SHIFTSIZE input
if ~(isFinite && isInteger && isVector && nonSparse)
    error(message('MATLAB:circshift:InvalidShiftType'));
end

% Make sure the shift vector has the same length as numDimsA.
% The missing shift values are assumed to be 0. The extra
% shift values are ignored when the shift vector is longer
% than numDimsA.
if (numel(p) < numDimsA)
    p(numDimsA) = 0;
end

end %function ParseInputs

