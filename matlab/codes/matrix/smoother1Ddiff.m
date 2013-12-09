% smoother1Ddiff Apply a diffusive smoother on a 1D field
%
% field_out = smoother1Ddiff(field_in,dist_in1);
%
% Apply a diffusive smoother based on Weaver and Courtier, 2001.
%
% field_in:	field to be smoothed (masked with NaN)
% dist_in1:	scale in first direction
% field_out:	smoothed field
%
% The domain is assumed cyclic.
% If it is not, you want to mask edge points with NaNs.
%
% Created by Guillaume Maze on 2009-11-24.
% Developed with Gael Forget
% Copyright (c) 2008 Guillaume Maze. 
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

function [field_out] = smoother1Ddiff(field_in,dist_in1)

% Same as 2D version but much faster if performed on a single dimension

% domaine_global_def;
nt = size(field_in,1);

e1t = ones(nt,size(field_in,2));

% scale the diffusive operator:
smooth2D_dt  = 1;
smooth2D_nbt = max(max(max(dist_in1./e1t)));
smooth2D_nbt = 2*ceil(2*smooth2D_nbt^2);
smooth2D_T   = smooth2D_nbt*smooth2D_dt;

smooth2D_kh1 = dist_in1.*dist_in1/smooth2D_T/2;

% time-stepping loop:
field_out = field_in; 

for icur = 1 : smooth2D_nbt
%	if mod(icur,10) == 0, disp(sprintf('Smoother Iteration: %3.0f/%3.0f',icur,smooth2D_nbt));end
	
	circ1 = circshift(field_out,[1 0]);
	circ2 = circshift(smooth2D_kh1,[1 0]);
	tmp1 = (field_out-circ1)./e1t.^2.*(smooth2D_kh1/2+circ2/2);  
%	tmp1(find(isnan(tmp1))) = 0;
	tmp1(isnan(tmp1)) = 0;

	circ1 = circshift(field_out,[-1 0]);
	circ2 = circshift(smooth2D_kh1,[-1 0]);
	tmp2 = (circ1-field_out)./e1t.^2.*(smooth2D_kh1/2+circ2/2); 
%	tmp2(find(isnan(tmp2))) = 0;
	tmp2(isnan(tmp2)) = 0;

	field_out = field_out-(smooth2D_dt*(tmp1-tmp2))./e1t.^2;
end


end %functionsmoother1Ddiff
