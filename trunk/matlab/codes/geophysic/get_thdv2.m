% get_thdv2 H1LINE
%
% [] = get_thdv2()
% 
% HELPTEXT
%
% Created: 2011-06-07.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = get_thdv2(varargin)
	
%- Load arguments:
if nargin ~= 0
	if mod(nargin,2) ~=0
		error('Arguments must come in pairs: ARG,VAL')
	end% if 
	for in = 1 : 2 : nargin
		eval(sprintf('%s = varargin{in+1};',lower(varargin{in})));
	end% for in
else
	% Display help here
end% if

%- Identify what kind of data we have to work with:
if ~exist('n2','var')
	% Provided depth and potential density
	inputype = 1;
	% Check if we have other required fields :
	% and if they're valid:
	
	% remove nans:
	ii   = ~isnan(dpt) & ~isnan(st0) & ~isnan(temp) & ~isnan(psal);
	dpt  = dpt(ii);
	st0  = st0(ii);
	temp = temp(ii);
	psal = psal(ii);
	if isempty(dpt)
		error('This profile is full of NaNs !');
	else
		clear ii
	end% if 

else
	% Provided depth and N2
	inputype = 2;
	% Check if we have other required fields :
end% if 

%-
switch inputype
	case 1 % Provided depth and potential density
		results = gomethodA(st0,temp,psal,dpt);
	case 2 % Provided depth and N2
end% switch 

end %functionget_thdv2


%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = gomethodA(st0,temp,psal,dpt)
	
	st0  = st0(:);
	temp = temp(:);
	psal = psal(:);
	dpt  = dpt(:);
	
	%-- First we work on a regular grid:
	dz = 10;
	temp = mvtozregul(temp,dpt,dz);
	psal = mvtozregul(psal,dpt,dz);
	[st0 dpt] = mvtozregul(st0,dpt,dz);
	ii   = ~isnan(dpt) & ~isnan(st0) & ~isnan(temp) & ~isnan(psal);
	dpt  = dpt(ii);
	st0  = st0(ii);
	temp = temp(ii);
	psal = psal(ii);
	
	%-- Compute the Mixed Layer Depth:
	mld = compute_mld(temp,dpt,0.2,dpt(1));

	%-- Squeeze the profile to work below the MLD:
	if ~isnan(mld)
		iz = find(dpt<mld);
		if ~isempty(iz)
			st0  = st0(iz);
			temp = temp(iz);
			psal = psal(iz);
			dpt  = dpt(iz);			
		end% if 
	end% if 
	
	stophere
	
	%-- Compute the vertical gradient of density:
	dzmethod = 1;
	[dst0dz dpt_dz] = compute_vgrad(st0,dpt,dzmethod);
	
	%-- Identify the maximum to be used as a reference:
	[a izpeak(1)] = max(dst0dz); clear a	
	[g_seasth g_seasth_thick] = fitagaussto(dpt_dz,dpt_dz(izpeak(1)),dst0dz(izpeak(1)),dst0dz);
	
	%--
	sig = g_seasth_thick*2;
	cc = ones(1,length(dpt_dz))*NaN;
	for iz = izpeak(1) : length(dpt_dz)
		cp = g_seasth + gauss(dpt_dz,sig,dpt_dz(iz),dst0dz(izpeak(1))/2);
		cc(iz) = min(min(corrcoef(cp,dst0dz)));		
	end% for iz
	
	
stophere

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%
function [g_fit g_fit_thick] = fitagaussto(x,x0,y0,y);
	
	sig = 10 : 10 : 300;
	for ii = 1 : length(sig)
		g_seasth = gauss(x,sig(ii),x0,y0);
		cc(ii) = min(min(corrcoef(y,g_seasth)));
	end% for ii
	[a isig] = max(cc); clear a
	g_fit_thick = sig(isig);
	g_fit = gauss(x,sig(isig),x0,y0);
	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%
function [st0 dpt] = mvtozregul(st0,dpt,dz)
	
	az = [fix(dpt(1)):-dz:fix(dpt(end))]';
	a  = interp1(dpt,st0,az,'linear');
	dpt = az; 
	st0 = a; 
	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%
function [dst0dz dpt_dz] = compute_vgrad(st0,dpt,method);
	
	dpt_dz = dpt(1:end-1)+diff(dpt)/2;
	
	switch method	
		case 1 % CLASSIC FORWARD DIFFERENCE (2 points):
			dst0dz  = -diff(st0)./diff(dpt);

		case 2 % CLASSIC CENTERED DIFFERENCE (3 points):
			% Move to a regular grid:
			dptend = dpt(~isnan(dpt)); dptend = dptend(end);
			a = linspace(dpt(1),dptend,max([1000 length(dpt)]));
			ddz = diff(a(1:2));
			% Interp profil:
			b = interp1(dpt(~isnan(st0)),st0(~isnan(st0)),a,'linear');
			% then compute the 3 points method for the first derivative
			db3dz = NaN*ones(1,length(b));
			for ip = 2 : length(b)-1
				db3dz(ip) = ( b(ip+1) - b(ip-1))/(2*ddz);
			end
			% move back to the original grid:
			dst0dz = -interp1(a(~isnan(db3dz)),db3dz(~isnan(db3dz)),dpt_dz);

		case 3 % CLASSIC CENTERED DIFFERENCE (5 points):	
			% Move to a regular grid:
			dptend = dpt(~isnan(dpt)); dptend = dptend(end);
			a = linspace(dpt(1),dptend,max([1000 length(dpt)]));
			ddz = diff(a(1:2));
			% Interp profil:
			b = interp1(dpt(~isnan(st0)),st0(~isnan(st0)),a,'linear');
			
			% then compute the 3 points method for the first derivative
			% db3dz = NaN*ones(1,length(b));
			% for ip = 2 : length(b)-1
			% 	db3dz(ip) = ( b(ip+1) - b(ip-1))/(2*ddz);
			% end
			% then compute the five points method for the first derivative
			db5dz = NaN*ones(1,length(b));
			for ip = 3 : length(b)-2
				db5dz(ip) = (-b(ip+2) + 8*b(ip+1) - 8*b(ip-1) + b(ip-2))/(12*ddz);
			end
			% move back to the original grid:
			dst0dz = -interp1(a(~isnan(db5dz)),db5dz(~isnan(db5dz)),dpt_dz);

	end

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%
function mld = compute_mld(t,z,dt,zref)
	
%	dt = 0.2;
%	zref = -10;
	
	z = z(~isnan(t));
	t = t(~isnan(t));
	%---- Get T(Zref):
	iz  = find(z>=-100);
	if ~isempty(iz) & length(iz) ~= length(z) & length(iz) > 2
		tref = interp1(z(iz),t(iz),zref,'linear');
		%---- Get z where dt compared to tref equals + or - dt
		izmld = find(abs(t-tref)<=dt,1,'last');
		if ~isempty(izmld)						
			mld = z(izmld);
		else
			mld = NaN;
		end% if 
	else		
		mld = NaN;
	end% if
	
end%function



