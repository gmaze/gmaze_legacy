% ltx_tbll Print a LaTeX table line
%
% str = ltx_tbll(FORMAT,CONTENT)
% 
% Eg:
% 	ltx_tbll('%0.1f \pm %0.1f',[2 3; 34 12])
%
% Created: 2010-11-10.
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

function varargout = ltx_tbll(varargin)

form = varargin{1}; % Format of 1 cell
cont = varargin{2}; % Content to print in cells

if length(size(cont)) > 2
	error('The matrix content should only be of dimension 2 with [nvar_per_cell n_columns]');
end

% Number of variables in each cell:
nvar_percell = length(strfind(strrep(form,'%%',''),'%'));

% Reshape the content table by cell in 1st dim:
ivar_dim = find(size(cont)==nvar_percell);
if isempty(ivar_dim)
	error('The matrix content is ill formatted, it should be [nvar_per_cell n_columns]')
end
ii = 1:length(size(cont));
ii = ii(ii~=ivar_dim); 
cont2 = permute(cont,[ivar_dim ii]);
% we should have [nvar_percell ncolumns] = size(cont2)
[nvar_percell2 ncolumns] = size(cont2);
if nvar_percell2 ~= nvar_percell
	error('Something went wrong when permuting content table');
else
	clear nvar_percell2 
end
	
% Create the table line LaTeX code:
ltx_form = strrep(form,'\','\\');

% 1st cell (column):
strline = eval(['sprintf(''' ltx_form ''',cont2(:,1))']);

% Loop over the rest of columns:
for icol = 2 : ncolumns
	% Format 1 cell:
	icell = eval(['sprintf(''' ltx_form ''',cont2(:,icol))']);
	% Update line:
	strline = sprintf('%s & %s',strline,icell);		
end%for icol

% Finish the line:
strline = sprintf('%s \\\\\\hline',strline);

varargout(1) = {strline};

end %functionltx_tbll

















