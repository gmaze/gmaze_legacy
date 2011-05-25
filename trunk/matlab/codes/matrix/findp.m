% FINDP Find the p power of 10 of a number
%
% p = FINDP(X) 
% Find p power of 10 of X
%
% Eg:
%	findp(4345134) = 6
%	findp(1e12) = 12
%
% Copyright (c) 2004 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function n = findp(X)

X = abs(X);

if X > 1
	id = -1;
	fct = 'fix';
	dd = 1;
else
	id = +1;
	fct = 'fix';
	dd = 0;
end  
n = 0;

cestfini = 0;
while cestfini~=1
%  disp(num2str([n fix(X*10^n)]));
%  if fix(X*10^n)==0 | fix(X*10^n)>10
%  if round(X*10^n)==0 | round(X*10^n)>10
%	disp(sprintf('%s(X*10^%i)==0 | %s(X*10^%i)>10',fct,n,fct,n))
	if eval(sprintf('%s(X*10^n)==0 | %s(X*10^n)>10',fct,fct))	
		n = n + id;
	else
		cestfini = 1;
	end
end
n = -n;
n = n + dd;














