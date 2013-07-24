% bin1mat create a 1D matrix from scattered data without interpolation
%
%   YG = BIN1MAT(X,Y,XI) - creates a grid from the data 
%   in the (usually) nonuniformily-spaced vectors (x,y) 
%   using grid-cell averaging (no interpolation). The grid 
%   dimensions are specified by the uniformily spaced vectors
%   XI.
%
%   YG = BIN1MAT(...,@FUN) - evaluates the function FUN for each
%   cell in the specified grid (rather than using the default
%   function, mean). If the function FUN returns non-scalar output, 
%   the output YG will be a cell array.
%
%   YG = BIN1MAT(...,@FUN,ARG1,ARG2,...) provides aditional
%   arguments which are passed to the function FUN. 
%
% This function is 1D version of the bin2mat function from A. Stevens (astevens@usgs.gov)
% available on Matlab Central.
% 
% Created: 2013-05-13.
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

function YG = bin2mat(x,y,XI,varargin)

%check inputs
error(nargchk(3,inf,nargin,'struct'));

%make sure the vectors are column vectors
x = x(:);
y = y(:);

if all(any(diff(cellfun(@length,{x,y}))));
    error('Inputs x and y must be the same size');
end

%process optional input
fun=@mean;
test=1;
if ~isempty(varargin)
    fun=varargin{1};
    if ~isa(fun,'function_handle');
        fun=str2func(fun);
    end
    
    %test the function for non-scalar output
    test = feval(fun,rand(5,1),varargin{2:end});
    
end

%grid nodes
xi=XI(1,:);
[m,n]=size(XI);

%limit values to those within the specified grid
xmin=min(xi);
xmax=max(xi);

gind =(x>=xmin & x<=xmax);

%find the indices for each x and y in the grid
[junk,xind] = histc(x(gind),xi);

%break the data into a cell for each grid node
blc_ind=accumarray(xind,y(gind),[n 1],@(x){x},{NaN});

%evaluate the data in each grid using FUN
if numel(test)>1
    YG=cellfun(@(x)(feval(fun,x,varargin{2:end})),blc_ind,'uni',0);
else
    YG=cellfun(@(x)(feval(fun,x,varargin{2:end})),blc_ind);
end
