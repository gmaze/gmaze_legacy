% constraint_jstar H1LINE
%
% [Jstarinv Jstar zstar z0 zt zb zthd] = constraint_jstar(DPT,T,S,O2)
% 
% Eg:
% 
%
% Created: 2009-12-30.
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

function [jstarinv jstar zstar z0 zt zb thd] = constraint_jstar(varargin)

dpt   = varargin{1}; dpt= dpt(:)';
THETA = varargin{2};
SALT  = varargin{3};
OXYL  = varargin{4};

[nz ny nx] = size(THETA);

if nx>1
	THETA = reshape(THETA,[nz nx*ny]);
	SALT  = reshape(SALT,[nz nx*ny]);
	OXYL  = reshape(OXYL,[nz nx*ny]);
end

jstarinv = zeros(1,nx*ny).*NaN;
jstar = zeros(1,nx*ny).*NaN;
zstar = zeros(1,nx*ny).*NaN;
z0 = zeros(1,nx*ny).*NaN;
zt = zeros(1,nx*ny).*NaN;
zb = zeros(1,nx*ny).*NaN;
for ix = 1 : nx*ny
%for ix = 1139 : nx*ny
	[ix nx*ny]
	if ~isnan(THETA(1,ix))		
		[jstarinv(ix) jstar(ix) zstar(ix) z0(ix) zt(ix) zb(ix) oprofinv oprof tprof sprof] = diag_all(dpt,squeeze(THETA(:,ix))',...
		squeeze(SALT(:,ix))',squeeze(OXYL(:,ix))');
		thd(ix) = get_thd(densjmd95(squeeze(SALT(:,ix))',squeeze(THETA(:,ix))',0),dpt);
	end
end%for ix

if nx>1
	jstarinv = reshape(jstarinv,[ny nx]);
	jstar = reshape(jstar,[ny nx]);
	zstar = reshape(zstar,[ny nx]);
	z0 = reshape(z0,[ny nx]);
	zt = reshape(zt,[ny nx]);
	zb = reshape(zb,[ny nx]);
	thd = reshape(thd,[ny nx]);
end

end %functionconstraint_jstar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [jstarinv jstar zstar z0 zt zb oprofinv oprof tprof sprof] = diag_all(dpt,theta,salt,oxyl)


%%%%%%% FIND THE LAYER FOR WHICH THE EOS IS LINEAR:
pres = 1000*9.81*abs(dpt)/1e4;
pres = 0;
method = 2;
switch method
	case 1
		al = sw_alpha(salt,theta,pres);
		be = sw_beta(salt,theta,pres);
		r  = 1000*(1-al.*(theta)+be.*(salt))./densjmd95(salt,theta,pres);
		iz = find(r>=0.999);
		clear r
	case 2
		zthd = get_thd(densjmd95(salt,theta,pres),dpt);
		if zthd >= -3000, 
			iz = find(dpt<=zthd,1,'first'):length(dpt);
%			dpt(iz([1 end])) 
		else
			iz = [];
		end
		
end


if ~isempty(iz)

	% Layer parameter:
	zt = dpt(iz(1));
	zb = dpt(iz(end));
	dz = zt-zb;

	%%%%%%% DETERMINE Z* = z*/dz
	zstar = diag_zstar(theta,zt,zb,dpt);
	%zstar = diag_zstar(salt,zt,zb,dpt)
	Zstar = zstar./dz;

	%%%%%%% DETERMINE J* = -J/w
	[jstarinv z0] = diag_jstarinv(oxyl,zt,zb,dpt,Zstar);
	jstar = diag_jstar(oxyl,zt,zb,dpt,Zstar);

	%%%%%%% Expected profils:

	% Boundary conditions:
	Tt = theta(iz(1));
	Tb = theta(iz(end));
	St = salt(iz(1));
	Sb = salt(iz(end));
	Ot = oxyl(iz(1));
	Ob = oxyl(iz(end));

	% Profil:
	tprof    = cpart(dpt,zt,zb,zstar,Tt,Tb);
	sprof    = cpart(dpt,zt,zb,zstar,St,Sb);
	oprofinv = cpart(dpt,zt,zb,zstar,Ot,Ob) + ncpart(dpt,zt,zb,zstar,jstarinv);
	oprof    = cpart(dpt,zt,zb,zstar,Ot,Ob) + ncpart(dpt,zt,zb,zstar,jstar);

else
	jstarinv = NaN;
	jstar = NaN; zstar = NaN; z0  = NaN;zt = NaN; zb = NaN; oprofinv = NaN; oprof  = NaN;tprof = NaN; sprof = NaN;
end

end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function jstar = diag_jstar(C,zt,zb,dpt,zstar);
	
	% Layer:
	iz = find(dpt>=zb & dpt<=zt);
	dz = zt-zb;
	
	% Boundary conditions:
	Ct = C(iz(1));
	Cb = C(iz(end));

	% Standard difference between non-conservative tracer solution and observed one for various J*:
	jstar = [-20:.1:20]/dz;
	for ijstar = 1 : length(jstar)
		out = cpart(dpt,zt,zb,zstar,Ct,Cb) + ncpart(dpt,zt,zb,zstar,jstar(ijstar));
		r(ijstar) = nansum((out(iz) - C(iz)).^2);	
	end%for

	% J* is the determine where the standard difference is minimum:
	jstar = jstar(find(r==min(r),1));

end %function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [jstarinv z0] = diag_jstarinv(oxyl,zt,zb,dpt,Zstar);
	
	% Layer:
	iz = find(dpt>=zb & dpt<=zt);
	dz = zt-zb;
	
	% Boundary conditions of oxygen profil:
	Ot = oxyl(iz(1));
	Ob = oxyl(iz(end));
	if ~isnan(Ot) & ~isnan(Ob)

		% Find the minimum depth in the layer:
		izOMD = find(oxyl(iz)==min(oxyl(iz)),1,'first');
		z0    = dpt(iz(izOMD));

		% Then beta function:
		beta = (z0 - zt)/dz;

		% Then alpha coefficient:
		alpha = Zstar*(1-exp(-1/Zstar))*exp(-beta/Zstar) - 1;

		% Then J*inv:
		jstarinv = (Ot-Ob)/alpha/dz;

	else
		jstarinv = NaN;
		z0 = NaN;
	end

end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function zstar = diag_zstar(C,zt,zb,dpt);
	
	% Layer:
	iz = find(dpt>=zb & dpt<=zt);
	
	% Boundary conditions:
	Ct = C(iz(1));
	Cb = C(iz(end));

	% Standard difference between conservative tracer solution and observed one for various z*:
	zstar = [-5e3:1e2:5e3];
	for izstar = 1 : length(zstar)
		out = cpart(dpt,zt,zb,zstar(izstar),Ct,Cb);
		r(izstar) = nansum((out(iz) - C(iz)).^2);	
	end%for

	% z* is the determine where the standard difference is minimum:
	zstar = zstar(find(r==min(r),1));

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out p1 p2] = ncpart(z,zt,zb,zstar,jstar)	
	p1 =          jstar*(zt-z);
	p2 = -(zt-zb)*jstar*fz(zt,zb,zstar,z);
	out = p1 + p2;	
end %functionfz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = cpart(z,zt,zb,zstar,Ct,Cb)
	out = Ct-(Ct-Cb)*fz(zt,zb,zstar,z);
end %functionfz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = fz(zt,zb,zstar,z)
	num = 1-exp((z-zt)/zstar);
	den = 1-exp((zb-zt)/zstar);
	out =  num/den;	
end %functionfz
















