% nlinvp  Non-Linear inverse problem
%
% [Xs, Cs, FXs, FX0] = nlinvp(X0,C0,F,CT,F0,[OPTIONS])
% 
% Solve a non-linear inverse problem.
%
% Given f a set of constraints to be applied at points X
% F is the matrix of partial derivatives of f with respect to X:
%	F(t,k) = d f(t) / d X(k)
% Because the problem is non-linear, any X(k) can be found in F(t,k)
%
% With:	
% 	NC the Number of constraints and
% 	NU the Number of unknowns to be estimated,
%
% INPUTS:
%	X0: A priori unknowns estimates
%		size(X0) = NU x 1
%	C0: A priori error covariance matrix of unknowns estimates
%		size(C0) = NU x NU
%	F: Constraints matrix
%		size(F) = NC x NU
% 	CT: A priori error covariance matrix on constraints
%		size(CT) = NC x NC
% 	F0: a priori constraints estimate -> f(X0)
%		size(F0) = NC x 1
%
% OUTPUTS:
% 	Xs: unknowns estimates
%		size(Xs) = NU x 1	
% 	Cs: error covariance matrix of unknowns estimates
%		size(Cs) = NU x NU
% 	FXs = F*Xs-F0: A posteriori constraints residuals
%		size(FXs) = NC x 1
% 	FX0 = F*X0-F0 : A priori constraints residuals
%		size(FX0) = NC x 1
%
% Ref: 
%	A. Tarantola and B. Valette. Generalized nonlinear inverse problems 
%		solved using the least squares criterion. 
%		Rev. Geophys. Space Phys, 20(2):219–232, 1982.
% 	H. Mercier. Determining the general circulation of the ocean: A 
%		nonlinear inverse problem. J. Geophys. Res., 91(C4):5103–5109, 1986.
%		http://dx.doi.org/10.1029/JC091iC04p05103
%
% See Also:
%	linvp
%
% Created: 2010-09-09.
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

function varargout = nlinvp(X0,C0,F,CT,F0,varargin)

error('Sorry, this function needs corrections !')

%%%%%%%%%%%%%%%%%%%%%%%%%%% Check dimensions:
[NU b] = size(X0); 
if b ~= 1
	error('A priori unknowns matrix X0 must be NU x 1');
end, clear b

[a b] = size(C0);
if a~=b
	error('A priori unknowns error covariance matrix C0 must be square !');
elseif a~= NU
	error('A priori unknowns error covariance matrix C0 must be NU x NU');
end, clear a b

[NC b] = size(F);
if b~= NU
	error('Constraints matrix F must be NC x NU');
end,clear b

[a b] = size(CT);
if a~=b
	error('A priori constraints error covariance matrix CT must be square !');
elseif a~= NC
	error('A priori constraints error covariance matrix CT must be NC x NC');
end, clear a b

[a b] = size(F0);
if a ~= NC | b ~= 1
	error('A priori constraints estimate matrix F0 must be NC x 1');
end,clear a b


%%%%%%%%%%%%%%%%%%%%%%%%%%% ACTIONS !

% A priori constraints residuals:
FX0 = F*X0-F0; 

% Generalized least squares method solution:
Q  = C0*F'*inv(F*C0*F'+CT);
Xs = X0-Q*FX0;  % Unknowns estimates
Cs = C0-Q*F*C0; % Unknowns errors (in the diagonal)

% A posteriori constraints residuals:
FXs = F*Xs-F0; 

%%%%%%%%%%%%%%%%%%%%%%%%%%% Outputs:
varargout(1) = {Xs};

switch nargout
	case 2
		varargout(1) = {Xs};
		varargout(2) = {Cs};
	case 3
		varargout(1) = {Xs};
		varargout(2) = {Cs};
		varargout(3) = {FXs};
	case 4
		varargout(1) = {Xs};
		varargout(2) = {Cs};
		varargout(3) = {FXs};
		varargout(4) = {FX0};
end

end %functionnlinvp






