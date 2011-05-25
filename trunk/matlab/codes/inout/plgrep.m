% plgrep Grep a string into definitions of sub plots/diagnostics
%
% [] = plgrep(pattern,[MASTER,SUBDIR])
% 
% 
%
%
% Created: 2009-08-25.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = plgrep(pattern,varargin)

switch nargin
	case 1
		MASTER = 'diag_Timeserie';
		SUBDIR = abspath('~/work/Postdoc/work/main/');
	case 2	
		MASTER = varargin{1};
		SUBDIR = '.';
	case 3	
		MASTER = varargin{1};
		SUBDIR = varargin{2};
	otherwise
		error('Bad nb of arguments')
end

LIST = get_plotlist(MASTER,SUBDIR);

ifou = 0;
for idiag = 1 : size(LIST,2)
	def = LIST(idiag).description;
	is = strfind(lower(def),lower(pattern));
	if ~isempty(is)
		ifou = ifou + 1;
		keep(ifou) = idiag;
	end
end
if exist('keep')
	LIST = LIST(keep);
	for ii = 1 : size(LIST,2)
		fil = LIST(ii).name;
		if 1
			disp(sprintf('#%3i: %20s // %s',ii,fil,LIST(ii).description));
		else
			disp(sprintf('%3s: DIAGNOSTIC %10s // %s',...
		                 num2str(LIST(ii).index),...
		                 fil(length(MASTER)+2:end-2),...
		                 LIST(ii).description));
		end
	end
else
	disp(sprintf('Nothing found'));
end

end %function