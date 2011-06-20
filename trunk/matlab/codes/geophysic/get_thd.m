% get_thd Determine the seasonal and main thermocline depths
%
% [THD THD_sc QC R D] = get_thd(ST,DPT,[PLOT],[DZMETHOD],[SMOOTHING])
% 
% Determine the seasonal and main thermocline depths from the vertical
% density gradient.
%
% We assume the seasonal and main thermoclines to induce two significant
% peaks in the vertical density gradient. 
% Instead of selecting the depth of the two maximums in the gradient 
% (often a useless method because of large differences in amplitude and 
% noise around the seasonal thermocline) we adopt the following method:
%
% Notation:
%	OBS: Observed profile of vertical density gradient
%	THDsc: Seasonal thermocline depth
%	THD: Main thermocline depth
%
% Method:
% 1	- THDsc is determined as the depth of the maximum in OBS (this is almost 
%		always the case).
% 2	- we create an analytical profile of reference (REF profile) for the 
%		density gradient with a gaussian of thickness 50m, centered at THDsc
%		and with the observed amplitude OBS(THDsc). We compute ER0 the
%		standard difference between REF and OBS.
% 3	- we assume the main thermocline to induce a second peak in the 
%		vertical density gradient. 
% 4	- we create another analytical profiles as the sum of REF with a second 
%		gaussian having an amplitude smaller than OBS(THDsc),
%		a larger thickness and centered at depth ZC (ANA(i) profile).
% 5	- we loop in step 4 for a range of ZC and we compute the standard difference 
%		ER(ZC) between the analytical REF+ANA(ZC) and the observed OBS 
%		vertical density gradients.
% 6	- the main thermocline depth is determined as the depth ZC for which
%		ER(ZC) is minimum.
% 7	- If ER(ZC) is found to be larger than ER0, the profile is thought to be 
%		unsignificant. Therefore we loop over steps 4, 5 and 6 with a new ANA(i) 
%		gaussian thickness until we reach a limit iteration number (QC is then 2) 
%		or found ER(ZC) smaller than the standard error ER0 (QC will be 1).
% 
%
% Inputs:
%	ST: density profile
%	DPT: vertical depth axis. Note that DPT(1) is at the surface
%		and DPT are negative defined.
% Optionals:
%	PLOT: 0 (default) or 1 
%		Plot a figure with relevant informations about the 
%		determination of depths.
%	DZMETHOD: method used to compute the vertical gradient
%		1: classic forward difference (2 points)
%		2 (default): classic centered difference (3 points)
%		3: classic centered difference (5 points)
%	SMOOTHING: 1 (default) or 0
%		This parameter determines if we should apply a little bit of
%		smoothing on the density profile before computing the vertical
%		gradient.
%	
% Outputs:
%	THD: Main thermocline depth.
%	THD_sc: Seasonal thermocline depth.
%	QC: quality flag of the estimate
%		1: reliable
%		2: why not, but weired, need a visual check
%
%	R: Standard error between all analytical and the real density profils
%	D: Depth range used to determine depth.
%
% Created: 2009-11-23.
% Rev. by Guillaume Maze on 2011-05-26: Added log method
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = get_thd(varargin)

st0 = varargin{1}; st0 = st0(:);
dpt = varargin{2}; dpt = dpt(:);

%ysc = 'lin'; % Yscale on plots
ysc = 'log'; % Yscale on plots

seasth_thickness = 50;
%seasth_thickness = 20;

howto = 1;

% remove nans:
ii = ~isnan(dpt) & ~isnan(st0);
dpt = dpt(ii);
st0 = st0(ii);
clear ii

if isempty(dpt)
	error('This profile is full of NaNs !');
end% if 

if nargin >= 3
	show_plot = varargin{3};
else
	show_plot = false; 
end

if nargin >= 4
	method = varargin{4};
else
	method = 2;
end

if nargin >= 5
	apriorismoothing = varargin{5};
else
	apriorismoothing = true;
end

if nargin >= 6
	grdlog = varargin{6};
else
	grdlog = true; % to we work on log(dst0/dz) or not	
end% if 

%%% Move to a regular vertical grid:
if length(unique(diff(dpt)))>1
	az = [fix(dpt(1)):-25:fix(dpt(end))]';
	a  = interp1(dpt,st0,az,'linear');
	dpt = az; clear az
	st0 = a; clear a
end% if 

%%% Try to reduce the noise in the profil:
if apriorismoothing
	% Move to a regular grid:
	dptend = dpt(~isnan(dpt)); dptend = dptend(end);
	a = linspace(dpt(1),dptend,100);
	ddz = abs(diff(a(1:2)));
	% Interp profil:
	b = interp1(dpt(~isnan(st0)),st0(~isnan(st0)),a,'spline');
	% Smooth it:
	st0_smooth = lanfilt(b,1,Inf,1/(50/ddz),2*10/ddz+1); 
	st0_rough  = lanfilt(b,2,1/(100/ddz),Inf,2*20/ddz+1);
	st0 = st0_smooth(:);
	dpt = a; dpt = dpt(:);
end

% Density and depth on the gradient grid:
st0_dz = (st0(1:end-1)+st0(2:end))/2;
dpt_dz = dpt(1:end-1)+diff(dpt)/2;

% Compute the vertical density gradient:
dst0dz = compute_vgrad(st0,dpt,method);

% For noisy profiles, the results may be taken with caution
% So we smooth a little bit the density profil if its standard
% deviation is higher than a threshold:
% if nanstd(dst0dz) > 1 & 1
% 	c = dst0dz; c(1)=NaN; c(end) = NaN;
% 	dst0dz = smoother1Ddiff(c,2);
% 	dst0dz = dst0dz(:);
% end

% We will determine the seasonal thermocline as the minimum in dst0dz because it is 
% generally the sharpest gradient. But what if the seasonal thermocline is not 
% the sharpest gradient ? The classic technic won't affect the main thermocline 
% depth but miss the seasonal one ...
% How to fix this ?
% We add a artificial profile of dst0dz which enhance surface value (decay exponential)
% It may blur a little the deeper pic of the main thermocline but fix the problem
% of a seasonal TH less stratified than the main one.
%dst0dz_artif = -abs(xtrm(dst0dz))*exp(-dpt_dz.^2/2/1e5);
%dst0dz = dst0dz+0*dst0dz_artif;

%stophere
%
if grdlog
	dst0dz = compute_vgrad(st0,dpt,method);	
	dst0dz = log(abs(dst0dz));
%	dst0dz_ref = dst0dz(1);
%	dst0dz_ref = mean(dst0dz);
%	dst0dz = dst0dz - dst0dz_ref;
	dst0dz = myrunmean(dst0dz,fix(length(dst0dz)*.05),0,1);
%	dst0dz(1) = 0;
else
	% Ensure the gradient is zero at the surface:
%	dst0dz(1) = 0;
end% if 


% Eventually plot
if show_plot
	figure;figure_tall;
	iw=2;jw=2;ipl=0;

	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	plot(st0,dpt,st0_dz,dpt_dz);
	grid on,box on;title('Density')
	set(gca,'yscale',ysc);ylabel('depth')
	yl=get(gca,'ylim');

	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	if ~grdlog
		plot(dst0dz,dpt_dz,'b',diff(st0)./diff(dpt),dpt_dz,'b--');
		title('Density gradient');
	else
%		plot(dst0dz,dpt_dz,'b',log(abs(diff(st0)./diff(dpt)))-dst0dz_ref,dpt_dz,'b--');
		plot(dst0dz,dpt_dz,'b');
		title('abs(log10(Density gradient))');
	end% if 
	grid on,box on,
	set(gca,'ylim',yl);
	set(gca,'yscale',ysc);ylabel('depth')
end


% The seasonal thermocline is generally the sharpest gradient:
if ~grdlog
	[a iz] = min(dst0dz);
else
	[a iz] = max(dst0dz);
end% if 
seas_thd   = dpt_dz(iz);
seas_thval = dst0dz(iz);
if show_plot,plot(seas_thval,seas_thd,'r*');end

% Now we create a gaussian profil centered on the seasonal thermocline:
g_seasth = gauss(dpt_dz,seasth_thickness,seas_thd,seas_thval); 
if grdlog
	g_seasth = g_seasth - mean(g_seasth);
end% if 
g_seasth(1) = 0;

% And we will add to it another gaussian profile to mimic the second pic due to the
% main thermocline and make the depth of this 2nd profil to vary into the range:
%dep_range = min(dpt_dz):25:seas_thd;
%dep_range = min(dpt_dz):25:max(dpt_dz);
dep_range = fliplr(min(dpt_dz):25:seas_thd);

% For each profiles we'll compute the standard error with the observed profile
% If the minimum standard error is larger than the one obtained with a single peak
% we are not satisfied and try another thickness for the main thermocline peak.

Iamnotsatisfied = 1;
iter = 0;
while Iamnotsatisfied
	iter = iter + 1;
	if iter == 1, th_thickness = 200; end % Initial main thermocline thickness
	
	% Init standard errors:
	r  = zeros(1,length(dep_range)).*NaN; % 2 gaussians for seasonal and main thermocline
	r2 = zeros(1,length(dep_range)).*NaN; % 1 gaussian, the reference, for seasonal thermocline

	% Now we create a serie of anlytical profiles with a main thermocline at different depths
	% For each profil we compute the standard error
	for idep = 1 : length(dep_range)
		% Gaussian profile to mimic the second pic due to the main thermocline:
		g_thd    = gauss(dpt_dz,th_thickness,dep_range(idep),seas_thval/6); g_thd(1) = 0; 

		% Take the standard error between profiles as a function of depth of g_thd pic:
		r(idep)  = nansum((dst0dz-(g_seasth+g_thd)).^2);
		r2(idep) = nansum((dst0dz-g_seasth).^2); % Only the peak of the seasonal th. is reproduced here
	
		if show_plot,
			p(idep) =plot(g_seasth+g_thd,dpt_dz,'r');
			p2(idep)=plot(g_seasth,dpt_dz,'k');
			drawnow;
		end
	end
	% Rev. by Guillaume Maze on 2011-06-07: Introduced a new method:
	switch howto
		case 1
			% We will identify the main thermocline depth as the depth to which the standard error is minimum:
			[a id] = min(r);
		case 2
			% We identify the THD as the depth to which the standard error BELOW ITS MAXIMUM is minimum:
			[a ida] = max(r);
			[a id]  = min(r(ida:end)); id = id + ida - 1;
	end% switch 
	
	
	% This is the depth of the main thermocline:
	h = dep_range(id);
	
	% Try to fix a quality flag:
	qc = 1; % by default
	if id == 1 % we found the first vertical level, this is weird
		qc = 2;
	end
	% The standard error r is higher than the reference error r2, weird again
	if r(id) > r2(id)
		qc = 2;
	end

	switch qc
		case 1 % OK
			Iamnotsatisfied = 0; % now I'm satisfied !
		case 2 % Not a good QC:
		
			% I'm not satisfied, but I need to stop anyway:
			if iter == 5 | th_thickness == 0 
				Iamnotsatisfied = 0; 
				
			% Let's try with a thinner thermocline:	
			else 
				th_thickness = th_thickness - 50;
				if th_thickness == 0, th_thickness = eps; end
				if show_plot,
					set(p(1:idep),'visible','off');
					set(p2(1:idep),'visible','off');
				end
			end
	end%switch
	
end%whileIamnotsatisfied

% If the main thermocline depth is deeper than -2000m, this is weird and we modify the qc flag:
if h < -2e3
	qc = 2;
end		
		
% If the standard error is constant: it's weird
if length(find(diff(r)==0))==length(r)-1	
	qc = 2;
end% if 

% If the main thermocline depth is the deepest level, it's weird
if h == dep_range(end)
	qc = 2;
end% if 
		
% It may happens that the standard error profile has more than 1 significant peak (ie with a value 
% smaller than the reference profil.
% We need to check if we have more than 1 significative minimum in the standard error function:
if 1
	r_significatif = r;
	r_significatif(r>=r2) = NaN;
	ipeaks = getpeaks(-r_significatif);		
	%stophere
	scndthd = [];	
	if ~isnan(ipeaks)
		ii = find(ipeaks~=id);
		if ~isempty(ii)			
			scndthd = dep_range(ipeaks(ii));
		end
	end
end

% plots
if show_plot
	set(p(1:idep),'visible','off');
	set(p(id),'visible','on');
	set(p2(1:idep),'visible','off');
	set(p2(id),'visible','on');
	
	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	plot(r,dep_range,'r.-');grid on,box on
	plot(r2,dep_range,'k.-');grid on,box on
	plot(r(id),dep_range(id),'r*','markersize',20);
	title('Standard error');ylabel('thermocline depth');set(gca,'yscale',ysc);set(gca,'ylim',yl);
	

	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	if ~grdlog
		plot(diff(st0)./diff(dpt),dpt_dz);
	else
		plot(log(abs(diff(st0)./diff(dpt)))-dst0dz_ref,dpt_dz);		
	end% if 
	grid on,box on,title('Density gradient');
	line(get(gca,'xlim'),[1 1]*seas_thd,'color','k'); text(max(get(gca,'xlim')),seas_thd,'Seas. THD','color','k');
	line(get(gca,'xlim'),[1 1]*dep_range(id),'color','r');text(max(get(gca,'xlim')),dep_range(id),'Main THD','color','r');
	set(gca,'yscale',ysc);ylabel('depth');set(gca,'ylim',yl);
	
	drawnow;
end


% Manage output:
switch nargout
	case 1
		varargout(1) = {h};
	case 2
		varargout(1) = {h};
		varargout(2) = {seas_thd};
	case 3
		varargout(1) = {h};
		varargout(2) = {seas_thd};
		varargout(3) = {qc};
	case 4
		varargout(1) = {h};
		varargout(2) = {seas_thd};
		varargout(3) = {qc};
		varargout(4) = {r};
	case 5
		varargout(1) = {h};
		varargout(2) = {seas_thd};
		varargout(3) = {qc};
		varargout(4) = {r};
		varargout(5) = {dep_range};
	case 6
		varargout(1) = {h};
		varargout(2) = {seas_thd};
		varargout(3) = {qc};
		varargout(4) = {r};
		varargout(5) = {dep_range};
		varargout(6) = {scndthd};
end
	
	
end %functionget_thd



function dst0dz = compute_vgrad(st0,dpt,method);
	
	dpt_dz = dpt(1:end-1)+diff(dpt)/2;
	
	switch method	
		case 1 % CLASSIC FORWARD DIFFERENCE (2 points):
			dst0dz  = diff(st0)./diff(dpt);

		case 2 % CLASSIC CENTERED DIFFERENCE (3 points):
			% Move to a regular grid:
			dptend = dpt(~isnan(dpt)); dptend = dptend(end);
			a = linspace(dpt(1),dptend,max([1000 length(dpt)]));
			ddz = diff(a(1:2));
			% Interp profil:
			b = interp1(dpt(~isnan(st0)),st0(~isnan(st0)),a,'spline');
			% then compute the 3 points method for the first derivative
			db3dz = NaN*ones(1,length(b));
			for ip = 2 : length(b)-1
				db3dz(ip) = ( b(ip+1) - b(ip-1))/(2*ddz);
			end
			% move back to the original grid:
			dst0dz = interp1(a(~isnan(db3dz)),db3dz(~isnan(db3dz)),dpt_dz);

		case 3 % CLASSIC CENTERED DIFFERENCE (5 points):	
			% Move to a regular grid:
			dptend = dpt(~isnan(dpt)); dptend = dptend(end);
			a = linspace(dpt(1),dptend,max([1000 length(dpt)]));
			ddz = diff(a(1:2));
			% Interp profil:
			b = interp1(dpt(~isnan(st0)),st0(~isnan(st0)),a,'spline');
			% then compute the 3 points method for the first derivative
			db3dz = NaN*ones(1,length(b));
			for ip = 2 : length(b)-1
				db3dz(ip) = ( b(ip+1) - b(ip-1))/(2*ddz);
			end
			% then compute the five points method for the first derivative
			db5dz = NaN*ones(1,length(b));
			for ip = 3 : length(b)-2
				db5dz(ip) = (-b(ip+2) + 8*b(ip+1) - 8*b(ip-1) + b(ip-2))/(12*ddz);
			end
			% move back to the original grid:
			dst0dz = interp1(a(~isnan(db5dz)),db5dz(~isnan(db5dz)),dpt_dz);

	end

end%function


