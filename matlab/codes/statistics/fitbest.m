% fitbest Determine the best least-square curve fitting solution
%
% [] = fitbest(x,y)
% 
% Determine the best least-square curve fitting solution
%
% Created: 2013-07-25.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
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
%

function varargout = fitbest(xi,yi,varargin)

%- Handle inputs:
xi = xi(:);
yi = yi(:);

iok = ~isnan(xi) & ~isnan(yi);
xi = xi(iok);
yi = yi(iok);
clear iok

n  = length(xi);

if length(yi) ~= n
	error('x and y must be of similar length !')
end% if 

%- Define metric:
%err = @(y,yhat) sqrt( sum( (yhat-y).^2 ) );
rms = @(y,yhat) sqrt( sum( ( (yhat-mean(yhat)) - (y-mean(y)) ).^2 ) / length(y) );

%- 
[a1,b1] = fitlin(xi,yi);
R(1) = rms(yi,a1+b1*xi); 
label{1} = sprintf('%10s (rms = %f): y = %f + %f x','Line',R(1),a1,b1);

[a2,b2] = fitpow(xi,yi);
R(2) = rms(yi,a2*xi.^b2); 
label{2} = sprintf('%10s (rms = %f): y = %f * x ^ %f','Power Law',R(2),a2,b2);

[a3,b3] = fitlog(xi,yi);
R(3) = rms(yi,a3+b3*log(xi)); 
label{3} = sprintf('%10s (rms = %f): y = %f + %f * log(x)','Log',R(3),a3,b3);

%-
switch nargin
	case 3
		switch varargin{1}
			case 'plot'
				figure; hold on
				plot(xi,yi,...
					xi,a1+b1*xi,...
					xi,a2*xi.^b2,...
					xi,a3+b3*log(xi));
				legend({'Data',label{:}});
				grid on, box on
		end% switch 
		
end% switch 


end %functionfitbest