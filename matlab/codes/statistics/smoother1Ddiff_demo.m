function varargout = smoother1Ddiff_demo(varargin)
% smoother1Ddiff_demo H1LINE
%
% [] = smoother1Ddiff_demo() HELP_TEXT_1ST_FORM
%
% Inputs:
%
% Outputs:
%
% Eg:
%
% See Also: 
%
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-04-14 (G. Maze)

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

for dz = [2]
	
	%dz = 5; % Grid resolution
	z  = fliplr(-2000:dz:0)'; % Vertical grid

	ffland; iw=1;jw=3;ipl=0;
	for iprof = 1 : 3
		
		% Initial profile:
		if iprof == 1 % Step function
			u = zeros(size(z));
			u(1:find(z<=-1000,1)) = 1;
			hl = [];
		elseif iprof == 2 % Impulse function
			u = zeros(size(z));
			u(find(abs(z+1000)<50)) = 1;
			hl = [-1000];
		elseif iprof == 3 % Two peaks function
			u = zeros(size(z));
			u(find(abs(z+800)<100))  = .7;
			u(find(abs(z+1200)<100)) = 1.3;
			hl = [-800, -1200];
		end% if 
	
		% Smooth profile with diffusion equation:
		zscale = fix(120/dz);
	
		c = u; c([1 end]) = NaN; [us n k] = smoother1Ddiff(c,zscale); clear c
		k % Diffusion coefficient
		2*sqrt(k*n) 

		% Smooth profile with a Gaussian filter:
		try 
			G   = fspecial('gaussian',size(u),zscale);
			usg = imfilter(u,G,'same');
		catch
			warning('Cannot use fspecial');
			usg = ones(size(u))*NaN;
		end%try
	
		ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		plot(z,u,z,us,z,usg,'--')
		grid on, box on,vline(hl);
		legend({'Input signal',sprintf('smoother1Ddiff with dist_in1 = %i',zscale),sprintf('Gaussian filter with sigma = %i',zscale)},'location','best');
		title(sprintf('dz=%i',dz),'fontweight','bold','fontsize',14)
	
	end% for iprof
	
end% for dz




end %functionsmoother1Ddiff_demo