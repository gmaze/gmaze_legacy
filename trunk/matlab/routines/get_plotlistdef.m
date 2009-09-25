% get_plotlistdef Display/return description of diagnostic files
%
% [LIST] = get_plotlistdef(MASTER,SUBDIR)
% 
% This function display a description of pre-defined plots/diag
% available with the MASTER.m in the folder SUBDIR
%
% Example:
% get_plotlistdef('hydro_selected_O2','.');
% % will list all hydro_selected_O2_pl* matlab files
%
% Rev. by Guillaume Maze on 2009-05-29: Remove from the output diag without descriptions
%
% Created: 2006-07-12.
% Copyright (c) 2006 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = get_plotlistdef(MASTER,SUBDIR)

global sla

% Define suffixe of plot module:
suff = '_pl';

d = dir(SUBDIR);
ii = 0;
% Select Matlab files:
for id = 1 : length(d)
  en = length( d(id).name );
  if en~=1 & (d(id).name(en-1:en) == '.m') &  ~d(id).isdir
    ii = ii + 1;
    l(ii).name = d(id).name;
  end
end

% Select Matlab files with MASTER as prefix
ii = 0;
for il = 1 : length(l)
  fil = l(il).name;
  pref = strcat(MASTER,suff);
%  iM =  findstr( strcat(SUBDIR,sla,fil) , pref ) ;
  iM =  strfind( strcat(SUBDIR,sla,fil) , pref ) ;

  if ~isempty(iM)

    % Recup description of plot module:
    fid = fopen(strcat(SUBDIR,sla,fil));
    thatsit = 0; desc = '';
	while thatsit ~= 1
		tline = fgetl(fid);
		if tline ~= -1
			if length(tline)>4 & tline(1:4) == '%DEF'
			desc    = tline(5:end);
			thatsit = 1;
			end %if
       else
%          desc = 'Not found';
          thatsit = 1;
       end %if
    end %while
	fclose(fid);
	if ~isempty(desc)
	    ii = ii + 1; 
	    LIST(ii).name = l(il).name;
	    LIST(ii).index = ii;
		LIST(ii).description = desc;
	    disp(sprintf('%3s) Module extension "%s" : %s',...
			 num2str(LIST(ii).index),...
			 fil(length(MASTER)+2:end-2),...
			 LIST(ii).description));
	end %if 
%    disp(strcat( num2str(LIST(ii).index),': Module extension: ',fil(length(MASTER)+2:end-2)));
%    disp(strcat('|-----> description :'  , LIST(ii).description ));
%    disp(char(2))

  end %if

end %for il

if ~exist('LIST')
  LIST= NaN;
end

switch nargout
	case 1
		varargout(1) = {LIST};
end


end %function