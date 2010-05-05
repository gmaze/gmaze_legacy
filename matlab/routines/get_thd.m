% get_thd Determine the seasonal and main thermocline depths
%
% [THD THD_sc QC R D] = get_thd(ST,DPT,[VERB])
% 
% Determine the seasonal and main thermocline depths from the vertical
% density gradient.
%
% Inputs:
%	ST: density profile
%	DPT: vertical depth axis. Note that DPT(1) is at the surface
%		and DPT are negative defined.
%	VERB = 0(default)/1 : optional, plot a figure with relevant informations
%		about the determination of the depth.
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
show_plot = 0; ysc = 'lin';
if nargin >= 3
	show_plot = varargin{3};
end

%%% Try to reduce the eventual noise in the profil:
if 1
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

% Vertical density gradient:
if nargin >= 4
	method = varargin{4};
else
	method = 2;
end
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
dst0dz_artif = -abs(xtrm(dst0dz))*exp(-dpt_dz.^2/2/1e5);
dst0dz = dst0dz+0*dst0dz_artif;

% Ensure the gradient is zero at the surface:
dst0dz(1) = 0;

% Eventually plot
if show_plot
	figure;figure_tall;
	iw=2;jw=2;ipl=0;

	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	plot(st0,dpt,st0_dz,dpt_dz);
	grid on,box on;title('Density')
	set(gca,'yscale',ysc);ylabel('depth')

	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	plot(dst0dz,dpt_dz,'b',diff(st0)./diff(dpt),dpt_dz,'b--');
	grid on,box on,title('Density gradient');
	set(gca,'yscale',ysc);ylabel('depth')
end


% The seasonal thermocline is generally the sharpest gradient:
[a iz] = min(dst0dz);
seas_thd = dpt_dz(iz);
seas_thval = dst0dz(iz);
if show_plot,plot(seas_thval,seas_thd,'r*');end

% Now we create a gaussian profil centered on the seasonal thermocline:
g_seasth = gauss(dpt_dz,50,seas_thd,seas_thval); g_seasth(1) = 0;

% And we add to it another gaussian profil to mimic the second pic due to the
% main thermocline and make the depth of this 2nd profil to vary into the range:
%dep_range = min(dpt_dz):25:seas_thd;
%dep_range = min(dpt_dz):25:max(dpt_dz);
dep_range = fliplr(min(dpt_dz):25:seas_thd);

Iamnotsatisfied = 1;
iter = 0;
while Iamnotsatisfied
	iter = iter + 1;
	if iter == 1, th_thickness = 200; end % Initial thermocline thickness
	
	% Init standard errors:
	r  = zeros(1,length(dep_range)).*NaN; % 2 gaussians
	r2 = zeros(1,length(dep_range)).*NaN; % 1 gaussian, the reference

	for idep = 1 : length(dep_range)
		% Gaussian profil to mimic the second pic due to the main thermocline:
		g_thd    = gauss(dpt_dz,th_thickness,dep_range(idep),seas_thval/6); g_thd(1) = 0; 
	
		% Take the standard error between profils as a function of depth of g_thd pic:
		r(idep)  = nansum((dst0dz-(g_seasth+g_thd)).^2);
		r2(idep) = nansum((dst0dz-g_seasth).^2);
	
		if show_plot,
			p(idep) =plot(g_seasth+g_thd,dpt_dz,'r');
			p2(idep)=plot(g_seasth,dpt_dz,'k');
			drawnow;
		end
	end
	% We will identify the main thermocline depth as the depth to which the standard error is minimum:
	[a id] = min(r);
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
				if show_plot,
					set(p(1:idep),'visible','off');
					set(p2(1:idep),'visible','off');
				end
			end
	end%switch
	
end%whileIamnotsatisfied
		

if show_plot
	set(p(1:idep),'visible','off');
	set(p(id),'visible','on');
	set(p2(1:idep),'visible','off');
	set(p2(id),'visible','on');
	
	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	plot(r,dep_range,'r.-');grid on,box on
	plot(r2,dep_range,'k.-');grid on,box on
	plot(r(id),dep_range(id),'r*','markersize',20);
	title('Standard error');ylabel('thermocline depth')

	ipl=ipl+1;subplot(iw,jw,ipl);hold on
	plot(diff(st0)./diff(dpt),dpt_dz);
	grid on,box on,title('Density gradient');
	line(get(gca,'xlim'),[1 1]*seas_thd,'color','k');
	line(get(gca,'xlim'),[1 1]*dep_range(id),'color','r');
	set(gca,'yscale',ysc);ylabel('depth')
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
	case 5
		varargout(1) = {h};
		varargout(2) = {seas_thd};
		varargout(3) = {qc};
		varargout(4) = {r};
		varargout(5) = {dep_range};
end
	
	
end %functionget_thd






