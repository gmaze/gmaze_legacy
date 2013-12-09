% diag_error Propagate error estimates for misc operators
%
% er = diag_error(typeOP,A,Aer,varargin)
% 
% Combine error estimates for misc operators/
% 
% Eg:
% 
% To compute the error of the sum of elements (A) given 
% their errors (Aer):
% er = diag_error('+',A,Aer);
% 
% To compute the error of the product of A elements with B elements (A) 
% given their errors (Aer and Ber):
% er = diag_error('*',A,Aer,B,Ber);
%
% Created: 2010-11-12.
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function er = diag_error(typeOP,A,Aer,varargin);
	
	switch typeOP
		
		case {'prod','*','x'} % Error on A*B
			switch nargin
				case 5
					B   = varargin{1};
					Ber = varargin{2};
					% Relative error on A:
					uA = Aer./A;
					% Relative error on B:
					uB = Ber./B;
					% Relative error in A*B:
					er = sqrt(uA.^2+uB.^2);
					% Absolute error in A*B:
					er = abs(A.*B.*er);
				otherwise
					error('You must specify B and Ber');
			end%switch nargin
			
		case {'div','/',':'} % Error on A/B:
			switch nargin
				case 5
					B   = varargin{1};
					Ber = varargin{2};
					% Relative error on A:
					uA = Aer./A;
					% Relative error on B:
					uB = Ber./B;
					% Relative error in A*B:
					er = sqrt(uA.^2+uB.^2);
					% Absolute error in A*B:
					er = abs(A./B.*er);
				otherwise
					error('You must specify B and Ber');
			end%switch nargin
			
		case {'add','+','minus','-'} % Error on A+B or A-B:
			switch nargin
				case 5
					B   = varargin{1}; % Not used
					Ber = varargin{2};
					er  = sqrt(Aer.^2 + Ber.^2);
				otherwise
					error('You must specify B and Ber');
			end%switch nargin
			
		case 'mean' % Error on the mean along dim(1) of A
			% mean = A(1,:) + A(2,:) + ...
			% mean = mean./size(A,1)
			
			% Error on the sum: A(1,:) + A(2,:) + ...
			id = 1;
			er = sqrt(sum(Aer.^2,id));
			% Error on the mean:
			er = er./size(A,id);
						
	end%switch
	
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
