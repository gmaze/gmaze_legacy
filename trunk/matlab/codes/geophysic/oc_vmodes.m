% oc_vmodes Compute vertical mode solutions
%
% [] = oc_vmodes(Z,ST)
% 
% Computing oceanic vertical mode profiles
%
% Created: 2011-01-13.
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

% http://www.oceanographers.net/forums/showthread.php?429-Normal-Mode-Oscillation-in-the-Ocean

function varargout = oc_vmodes(varargin)

%- Inputs
Z = varargin{1};
C = varargin{2};
if nargin == 2
	ST = C;
end
g = 9.81;
n = length(Z);

% Assume Z is negative and from surface to bottom (downward):

%- Boundary conditions:


%- Compute Buoyancy frequency:
%stophere
dSTdz = diff(ST)./diff(Z); % Should be negative (density increases with depth for a stable profile)
NZZsq   = -g*dSTdz./(0.5*(ST(1:end-1)+ST(2:end))+1000);
Nsq     = [NaN nanmean([NZZsq(1:end-1) ; NZZsq(2:end)]) NaN];
iok = find(~isnan(Nsq));

iok = iok(find(Z(iok)<=-500));

%- 
clear B
for k = 1 : length(iok) - 2
	ik = iok(k);
	dzk   = Z(ik) - Z(ik+1);
 	dzkp1 = Z(ik+1) - Z(ik+2);
	B(k,k)   =  2/(dzk*dzkp1 + dzk^2)/Nsq(ik);
	B(k,k+1) = -2/(dzk*dzkp1 + 0)/Nsq(ik);
	B(k,k+2) =  2/(dzk*dzkp1 + dzkp1^2)/Nsq(ik);
end
%B = cat(1,[B(1,2:end), 0],B,[0, B(end,1:end-1)]); 
B = B(:,2:end-1);

f = ST(iok)'; f(isnan(f)) = 0;

[v,d] = eig(B);
d = diag(d);
[d id] = sort(d,1,'descend');
v = v(:,id);
id = find(d~=0);
v = v(:,id);
d = d(id);


vmodes = zeros(length(d),n);
for iv = 1 : length(d)
	vmodes(iv,iok(2:end-1)) = v(:,iv)'.*ST(iok(2:end-1));
end

stophere

end %functionoc_vmodes
















